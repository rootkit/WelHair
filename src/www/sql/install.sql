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
CREATE DATABASE IF NOT EXISTS welhair DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;

GRANT ALL PRIVILEGES ON welhair.* TO whusr@'%' IDENTIFIED BY 'black123' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON welhair.* TO whusr@localhost IDENTIFIED BY 'black123' WITH GRANT OPTION;

USE welhair;