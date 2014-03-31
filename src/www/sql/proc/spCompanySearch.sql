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

CREATE PROCEDURE `spCompanySearch` (IN city INT, IN district INT, IN sort INT, IN latitude DOUBLE, IN longitude DOUBLE, IN page INT, IN pageSize INT)
BEGIN

DECLARE offset INT;

SET offset = (page - 1) * pageSize;

SELECT
  TBLC.*
FROM (
    SELECT
      C.CompanyId,
      C.Name,
      C.LogoUrl,
      C.Tel,
      C.Mobile,
      C.Address,
      C.Latitude,
      C.Longitude,

      AVG(IFNULL(TBLRate.Rate, 0)) Rate,
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
    WHERE (city = 0 || C.City = city) && (district = 0 || C.District = district)
    GROUP BY C.CompanyId
    ORDER BY CASE WHEN sort = 0 THEN Distance END ASC,
             CASE WHEN sort = 1 THEN Rate END DESC
    LIMIT offset, pageSize
) TBLC;

END$$


DELIMITER ;