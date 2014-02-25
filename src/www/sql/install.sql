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

CREATE TABLE IF NOT EXISTS `Users` (
  `UserId` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Username` VARCHAR(50) NOT NULL,
  `Nickname` VARCHAR(50) NOT NULL,
  `Email` VARCHAR(255) NOT NULL DEFAULT '',
  `EmailVerified` SMALLINT(1) NOT NULL DEFAULT 0,
  `Mobile` VARCHAR(20) NOT NULL DEFAULT '',
  `MobileVerified` SMALLINT(1) NOT NULL DEFAULT 0,
  `Password` VARCHAR(130) NOT NULL,
  `Birthday` DATETIME NULL,
  `Gender` SMALLINT(1) NOT NULL DEFAULT 1,
  `AvatarUrl` VARCHAR(255) NOT NULL DEFAULT '',
  `ProfileBackgroundUrl` VARCHAR(255) NOT NULL DEFAULT '',
  `ReferralUserId` INT NULL,
  `Reward` INT NOT NULL DEFAULT 0,
  `CreatedDate` DATETIME NOT NULL,
  `LastModifiedDate` DATETIME NULL,
  PRIMARY KEY (`UserId`),
  INDEX `IX_Users_Username` (`Username` ASC),
  INDEX `IX_Users_Email` (`Email` ASC),
  INDEX `IX_Users_Mobile` (`Mobile` ASC),
  CONSTRAINT `UK_Users_Username` UNIQUE (`Username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

ALTER TABLE `Users`
AUTO_INCREMENT = 1001;

CREATE TABLE IF NOT EXISTS `Social` (
  `SocialId` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `UserId` INT UNSIGNED NOT NULL,
  `Type` SMALLINT(1) NOT NULL DEFAULT 1,
  `ExternalId` VARCHAR(255) NOT NULL,
  `Email` VARCHAR(200) NOT NULL DEFAULT '',
  `DisplayName` VARCHAR(150) NOT NULL DEFAULT '',
  `Firstname` VARCHAR(100) NOT NULL DEFAULT '',
  `Lastname` VARCHAR(100) NOT NULL DEFAULT '',
  `ProfileUrl` VARCHAR(300) NOT NULL DEFAULT '',
  `PhotoUrl` VARCHAR(300) NOT NULL DEFAULT '',
  `WebsiteUrl` VARCHAR(300) NOT NULL DEFAULT '',
  `CreatedDate` DATETIME NOT NULL,
  `LastModifiedDate` DATETIME NULL,
  PRIMARY KEY (`SocialId`),
  CONSTRAINT `FK_Social_UserId` FOREIGN KEY (`UserId`) REFERENCES `Users`(`UserId`),
  INDEX `IX_Social_UserId` (`UserId` ASC),
  INDEX `IX_Social_ExternalId` (`ExternalId` ASC)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
