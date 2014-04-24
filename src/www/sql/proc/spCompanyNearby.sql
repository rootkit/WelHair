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

DROP PROCEDURE IF EXISTS `spCompanyNearby`;

DELIMITER $$

CREATE PROCEDURE `spCompanyNearby` (IN dis INT, IN latitude DOUBLE, IN longitude DOUBLE)
BEGIN

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

  getDistance(C.Latitude, C.Longitude, latitude, longitude) Distance
FROM Company C
WHERE C.Status = 1 AND getDistance(C.Latitude, C.Longitude, latitude, longitude) <= dis
LIMIT 0, 100;

END$$

DELIMITER ;