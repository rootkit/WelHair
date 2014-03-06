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

DELIMITER $$

CREATE FUNCTION `getDistance`(lat1 DOUBLE, lng1 DOUBLE, lat2 DOUBLE, lng2 DOUBLE) RETURNS DOUBLE

READS SQL DATA

DETERMINISTIC

BEGIN

DECLARE RAD DOUBLE;

DECLARE EARTH_RADIUS DOUBLE DEFAULT 6378137;

DECLARE radLat1 DOUBLE;

DECLARE radLat2 DOUBLE;

DECLARE radLng1 DOUBLE;

DECLARE radLng2 DOUBLE;

DECLARE s DOUBLE;

SET RAD = PI() / 180.0;

SET radLat1 = lat1 * RAD;

SET radLat2 = lat2 * RAD;

SET radLng1 = lng1 * RAD;

SET radLng2 = lng2 * RAD;

SET s = ACOS(COS(radLat1) * COS(radLat2) * COS(radLng1-radLng2) + SIN(radLat1) * SIN(radLat2)) * EARTH_RADIUS;

SET s = ROUND(s * 10000) / 10000;

RETURN s;

END$$

DELIMITER ;