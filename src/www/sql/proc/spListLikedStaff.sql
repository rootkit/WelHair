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

DROP PROCEDURE IF EXISTS `spListLikedStaff`;

DELIMITER $$

CREATE PROCEDURE `spListLikedStaff` (IN currentUserId INT, IN latitude DOUBLE, IN longitude DOUBLE, IN page INT, IN pageSize INT)
BEGIN

DECLARE offset INT;

SET offset = (page - 1) * pageSize;

SELECT
  TBLC.*,
  (SELECT COUNT(1) FROM UserLike UL WHERE currentUserId > 0 AND currentUserId = UL.CreatedBy AND UL.UserId = TBLC.UserId) IsLiked
FROM (
    SELECT
      C.CompanyId,
      C.Name,
      C.Address,
      C.Latitude,
      C.Longitude,

      U.UserId,
      U.Nickname,
      U.AvatarUrl,
      U.Email,
      U.EmailVerified,
      U.Mobile,
      U.MobileVerified,

      (SELECT MAX(W.WorkId) FROM Work W WHERE W.UserId = U.UserId) MaxWorkId,
      (SELECT COUNT(1) FROM Work W WHERE W.UserId = U.UserId) WorkCount,
      AVG(IFNULL(TBLRate.Rate, 0)) Rate,
      getDistance(C.Latitude, C.Longitude, latitude, longitude) Distance
    FROM Users U
    INNER JOIN CompanyUser CU ON CU.UserId = U.UserId AND CU.Status = 1
    INNER JOIN Company C ON CU.CompanyId = C.CompanyId
    INNER JOIN UserLike UL ON UL.UserId = U.UserId
    LEFT OUTER JOIN (
      SELECT
        CMU.CommentId,
        CMU.Rate,
        CMU.UserId
      FROM Comment CMU
      UNION
      SELECT
        CMW.CommentId,
        CMW.Rate,
        W.UserId
      FROM Comment CMW
      INNER JOIN Work W ON W.WorkId = CMW.WorkId
    ) AS TBLRate ON TBLRate.UserId = U.UserId
    WHERE U.Role = 3 AND UL.CreatedBy = currentUserId
    GROUP BY U.UserId
    ORDER BY UL.UserLikeId DESC
    LIMIT offset, pageSize
) TBLC;

END$$


DELIMITER ;