-- ==============================================================================
--
--  This file is part of the WelStory.
--
--  Copyright (c) 2012-2014 welfony.com
--
--  For the full copyright and license information, please view the LICENSE
--  file that was distributed with this source code.
--
-- ==============================================================================

DROP PROCEDURE IF EXISTS `spCompanySearch`;

DELIMITER $$

CREATE PROCEDURE `spCompanySearch` (IN currentUserId INT, IN searchText VARCHAR(255), IN city INT, IN district INT, IN sort INT, IN latitude DOUBLE, IN longitude DOUBLE, IN page INT, IN pageSize INT)
BEGIN

DECLARE offset INT;

SET offset = (page - 1) * pageSize;

SELECT
  TBLC.*,
  (SELECT COUNT(1) FROM UserLike UL WHERE currentUserId > 0 AND currentUserId = UL.CreatedBy AND UL.CompanyId = TBLC.CompanyId) IsLiked,
  (SELECT COUNT(1) FROM CompanyUser CU INNER JOIN Users U ON U.UserId = CU.UserId WHERE U.Role = 3 AND CU.Status = 1 AND CU.CompanyId = TBLC.CompanyId) StaffCount,
  (SELECT COUNT(1) FROM Comment C WHERE C.CompanyId = TBLC.CompanyId) CommentCount
FROM (
    SELECT
      C.CompanyId,
      C.Name,
      C.LogoUrl,
      C.PictureUrl,
      C.Tel,
      C.Mobile,
      C.Address,
      C.Latitude,
      C.Longitude,

      AVG(IFNULL(TBLRate.Rate, 0)) Rate,
      (SELECT
          COUNT(1)
      FROM Appointment A
      WHERE A.StaffId IN (SELECT UserId FROM CompanyUser CU WHERE CU.CompanyId = C.CompanyId AND CU.Status = 1) AND A.Status = 2 AND A.IsLiked = 1) RateCount,
      getDistance(C.Latitude, C.Longitude, latitude, longitude) Distance
    FROM Company C
    LEFT OUTER JOIN ( SELECT
                   CMC.CommentId,
                   CMC.Rate,
                   CMC.CompanyId
                 FROM Comment CMC
                 UNION
                 SELECT
                   CMU.CommentId,
                   CMU.Rate,
                   CU.CompanyId
                 FROM Comment CMU
                 INNER JOIN CompanyUser CU ON CU.UserId = CMU.UserId
                 UNION
                 SELECT
                   CMW.CommentId,
                   CMW.Rate,
                   CU.CompanyId
                 FROM Comment CMW
                 INNER JOIN Work W ON W.WorkId = CMW.WorkId
                 INNER JOIN CompanyUser CU ON CU.UserId = W.UserId
                ) AS TBLRate ON TBLRate.CompanyId = C.CompanyId
    WHERE C.Status = 1 AND (searchText = '' || C.Name LIKE CONCAT('%', searchText, '%')) AND (city = 0 || C.City = city) AND (district = 0 || C.District = district)
    GROUP BY C.CompanyId
    ORDER BY CASE WHEN sort = 0 THEN C.CompanyId END DESC,
             CASE WHEN sort = 1 THEN Distance END ASC,
             CASE WHEN sort = 2 THEN Rate END DESC
    LIMIT offset, pageSize
) TBLC;

END$$


DELIMITER ;