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

DROP PROCEDURE IF EXISTS `spListLikedWork`;

DELIMITER $$

CREATE PROCEDURE `spListLikedWork` (IN currentUserId INT, IN page INT, IN pageSize INT)
BEGIN

DECLARE offset INT;

SET offset = (page - 1) * pageSize;

SELECT
  TBLW.*,

  (SELECT COUNT(1) FROM UserLike UL WHERE currentUserId > 0 AND currentUserId = UL.CreatedBy AND UL.WorkId = TBLW.WorkId) IsLiked,

  C.CommentId,
  C.Body,

  U.UserId CommentUserId,
  U.AvatarUrl CommentAvatarUrl,
  U.Nickname CommentNickname
FROM (
    SELECT
      W.WorkId,
      W.Title,
      W.PictureUrl,
      W.Face,
      W.HairStyle,
      W.Gender,
      W.HairAmount,

      U.UserId StaffUserId,
      U.AvatarUrl StaffAvatarUrl,
      U.Nickname StaffNickname,

      C.CompanyId,
      C.Name CompanyName,

      (SELECT COUNT(1) FROM Comment CM WHERE CM.WorkId = W.WorkId) WorkCommentCount,
      (SELECT COUNT(1) FROM UserLike UL WHERE UL.WorkId = W.WorkId) WorkLikeCount
    FROM Work W
    INNER JOIN Users U ON U.UserId = W.UserId AND U.Role = 3
    INNER JOIN CompanyUser CU ON CU.UserId = U.UserId AND CU.Status = 1
    INNER JOIN Company C ON C.CompanyId = CU.CompanyId
    INNER JOIN UserLike UL ON UL.WorkId = W.WorkId
    WHERE UL.CreatedBy = currentUserId
    ORDER BY UL.UserLikeId DESC
    LIMIT offset, pageSize
) TBLW
LEFT OUTER JOIN Comment C ON C.CommentId = (SELECT MAX(CommentId) FROM Comment CC WHERE CC.WorkId = TBLW.WorkId)
LEFT OUTER JOIN Users U ON U.UserId = C.CreatedBy;

END$$


DELIMITER ;