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

DROP PROCEDURE IF EXISTS `spWorkSearch`;

DELIMITER $$

CREATE PROCEDURE `spWorkSearch` (IN area INT, IN gender INT, IN hairStyle INT, IN sort INT, IN page INT, IN pageSize INT)
BEGIN

DECLARE offset INT;

SET offset = (page - 1) * pageSize;

SELECT
  TBLW.*,

  C.CommentId,
  C.Body,

  U.UserId,
  U.AvatarUrl,
  U.Nickname
FROM (
    SELECT
      W.WorkId,
      W.Title,
      W.PictureUrl,

      (SELECT COUNT(1) FROM Comment CM WHERE CM.WorkId = W.WorkId) WorkCommentCount,
      (SELECT COUNT(1) FROM UserLike UL WHERE UL.WorkId = W.WorkId) WorkLikeCount
    FROM Work W
    INNER JOIN Users U ON U.UserId = W.UserId
    INNER JOIN CompanyUser CU ON CU.UserId = U.UserId
    INNER JOIN Company C ON C.CompanyId = CU.CompanyId
    WHERE (area = 0 || C.City = area) && (gender = 0 || W.Gender = gender) && (hairStyle = 0 || W.HairStyle = hairStyle)
    ORDER BY CASE WHEN sort = 0 THEN W.WorkId END DESC,
             CASE WHEN sort = 1 THEN WorkLikeCount END DESC
    LIMIT offset, pageSize
) TBLW
LEFT OUTER JOIN Comment C ON C.CommentId = (SELECT MAX(CommentId) FROM Comment CC WHERE CC.WorkId = TBLW.WorkId)
LEFT OUTER JOIN Users U ON U.UserId = C.CreatedBy;

END$$