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

DROP PROCEDURE IF EXISTS `spGoodsSearch`;

DELIMITER $$

CREATE PROCEDURE `spGoodsSearch` (IN currentUserId INT, IN searchText VARCHAR(255), IN city INT, IN district INT, IN sort INT, IN latitude DOUBLE, IN longitude DOUBLE, IN page INT, IN pageSize INT)
BEGIN

DECLARE offset INT;

SET offset = (page - 1) * pageSize;

SELECT
  TBLG.*,
  (SELECT COUNT(1) FROM UserLike UL WHERE currentUserId > 0 AND currentUserId = UL.CreatedBy AND UL.GoodsId = TBLG.GoodsId) IsLiked,
  (SELECT COUNT(1) FROM Comment C WHERE C.GoodsId = TBLG.GoodsId) CommentCount
FROM (
    SELECT
      G.GoodsId,
      G.Name,
      G.SellPrice,
      G.Img,

      C.CompanyId,
      C.Name CompanyName,
      C.LogoUrl,
      C.PictureUrl,
      C.Tel,
      C.Mobile,
      C.Address,
      C.Latitude,
      C.Longitude,

      (SELECT COUNT(1) FROM UserLike UL WHERE UL.GoodsId = G.GoodsId) LikeCount,
      getDistance(C.Latitude, C.Longitude, latitude, longitude) Distance
    FROM Goods G
    LEFT OUTER JOIN CompanyGoods CG ON CG.GoodsId = G.GoodsId
    LEFT OUTER JOIN Company C ON C.CompanyId = CG.CompanyId
    WHERE C.Status = 1 AND G.IsDeleted = 0 AND (searchText = '' || G.Name LIKE CONCAT('%', searchText, '%') || C.Name LIKE CONCAT('%', searchText, '%')) AND (city = 0 || C.City = city) AND (district = 0 || C.District = district)
    GROUP BY G.GoodsId, C.CompanyId
    ORDER BY CASE WHEN sort = 0 THEN G.GoodsId END DESC,
             CASE WHEN sort = 1 THEN Distance END ASC,
             CASE WHEN sort = 2 THEN LikeCount END DESC
    LIMIT offset, pageSize
) TBLG;

END$$

DELIMITER ;