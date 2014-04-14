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

DROP PROCEDURE IF EXISTS `spListLikedCompany`;

DELIMITER $$

CREATE PROCEDURE `spListLikedCompany` (IN currentUserId INT, IN latitude DOUBLE, IN longitude DOUBLE, IN page INT, IN pageSize INT)
BEGIN

DECLARE offset INT;

SET offset = (page - 1) * pageSize;

SELECT
  TBLC.*,
  (SELECT COUNT(1) FROM UserLike UL WHERE currentUserId > 0 AND currentUserId = UL.CreatedBy AND UL.CompanyId = TBLC.CompanyId) IsLiked,
  (SELECT COUNT(1) FROM CompanyUser CU INNER JOIN Users U ON U.UserId = CU.UserId WHERE U.Role = 3 AND CU.IsApproved = 1 AND CU.CompanyId = TBLC.CompanyId) StaffCount,
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
      getDistance(C.Latitude, C.Longitude, latitude, longitude) Distance
    FROM Company C
    INNER JOIN UserLike UL ON UL.CompanyId = C.CompanyId
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
    WHERE C.Status = 1 AND UL.CreatedBy = currentUserId
    GROUP BY C.CompanyId
    ORDER BY UL.UserLikeId DESC
    LIMIT offset, pageSize
) TBLC;

END$$


DELIMITER ;