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
  `Role` SMALLINT(1) NOT NULL DEFAULT 4,
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

DELIMITER ;;
CREATE PROCEDURE `sp_update_table_data`()
BEGIN
    IF NOT EXISTS(
      SELECT 1
      FROM `Users`
      WHERE `UserId` = 1
  ) THEN
    INSERT INTO `Users` VALUES (1,1,'admin','管理员','admin@welhair.com',0,'',0,'$pbkdf2-sha512$12000$O2jQRADP6q6x6Z.SzwR/Wg$NLuLX3ZRllnYq0bH4YqBliUOZVbyX9FbovvS5CN.VEZVnrVoMBTCG2li87szHo.yES6U8aS7d1NB4HTkC5BXxA',NULL,1,'http://welhair.com/static/img/avatar-default.jpg','',NULL,0,'2014-02-28 20:59:21','2014-03-01 00:27:41');
  END IF;
END;;

DELIMITER ;
CALL sp_update_table_data();
DROP PROCEDURE IF EXISTS `sp_update_table_data`;

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

CREATE TABLE IF NOT EXISTS `Company` (
  `CompanyId` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(50) NOT NULL,
  `Tel` VARCHAR(20) NOT NULL DEFAULT '',
  `Mobile` VARCHAR(20) NOT NULL DEFAULT '',
  `Province` INT NOT NULL,
  `City` INT NOT NULL,
  `District` INT NOT NULL,
  `Address` VARCHAR(255) NOT NULL,
  `Latitude` DOUBLE(10, 6) NOT NULL,
  `Longitude` DOUBLE(10, 6) NOT NULL,
  `PictureUrl` TEXT NULL,
  `Status` SMALLINT(1) NOT NULL DEFAULT 0,
  `CreatedDate` DATETIME NOT NULL,
  `LastModifiedDate` DATETIME NULL,
  PRIMARY KEY (`CompanyId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `CompanyUser` (
  `CompanyUserId` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `CompanyId` INT UNSIGNED NOT NULL,
  `UserId` INT UNSIGNED NOT NULL,
  `IsApproved` SMALLINT(1) DEFAULT 0,
  `CreatedDate` DATETIME NOT NULL,
  `LastModifiedDate` DATETIME NULL,
  PRIMARY KEY (`CompanyUserId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `Area` (
  `AreaId` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `ParentId` INT UNSIGNED NOT NULL DEFAULT 0,
  `Name`VARCHAR(50) NOT NULL,
  `Sort` INT NOT NULL DEFAULT 99,
  PRIMARY KEY (`AreaId`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `Work` (
  `WorkId` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `UserId` INT UNSIGNED NOT NULL,
  `Title` VARCHAR(255) NOT NULL DEFAULT '',
  `PictureUrl` TEXT NULL,
  `Gender` SMALLINT(1) UNSIGNED NOT NULL,
  `Face` VARCHAR(20) NOT NULL,
  `HairStyle` SMALLINT(1) UNSIGNED NOT NULL,
  `HairAmount` SMALLINT(1) UNSIGNED NOT NULL,
  `CreatedDate` DATETIME NOT NULL,
  `LastModifiedDate` DATETIME NULL,
  PRIMARY KEY (`WorkId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `Service` (
  `ServiceId` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `UserId` INT UNSIGNED NOT NULL,
  `Title` VARCHAR(255) NOT NULL DEFAULT '',
  `OldPrice` DECIMAL(15,2) NOT NULL DEFAULT 0.00,
  `Price` DECIMAL(15,2) NOT NULL DEFAULT 0.00,
  `CreatedDate` DATETIME NOT NULL,
  `LastModifiedDate` DATETIME NULL,
  PRIMARY KEY (`ServiceId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `PaymentTransaction` (
  `PaymentTransactionId` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `PaymentSystem` SMALLINT(1) NOT NULL DEFAULT 1,
  `ExternalId` VARCHAR(255) NOT NULL DEFAULT '',
  `Amount` DECIMAL(15,2) NOT NULL DEFAULT '0.00',
  `Fee` DECIMAL(15,2) NOT NULL DEFAULT '0.00',
  `Status` SMALLINT(1) NOT NULL DEFAULT 1,
  `CreateDate` DATETIME NOT NULL,
  `LastModifiedDate` DATETIME DEFAULT NULL,
  PRIMARY KEY (`PaymentTransactionId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `Appointment` (
  `AppointmentId` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `UserId` INT UNSIGNED NOT NULL,
  `CompanyId` INT UNSIGNED NOT NULL,
  `CompanyName` VARCHAR(50) NOT NULL,
  `CompanyAddress` VARCHAR(255) NOT NULL,
  `StaffId` INT UNSIGNED NOT NULL,
  `StaffName` VARCHAR(50) NOT NULL,
  `ServiceId` INT UNSIGNED NOT NULL,
  `ServiceTitle` VARCHAR(255) NOT NULL DEFAULT '',
  `Price` DECIMAL(15,2) NOT NULL DEFAULT 0.00,
  `Status` SMALLINT(1) NOT NULL DEFAULT 0,
  `PaymentTransactionId` INT UNSIGNED NOT NULL,
  `AppointmentDate` DATETIME NOT NULL,
  `CreatedDate` DATETIME NOT NULL,
  `LastModifiedBy` INT UNSIGNED NULL,
  `LastModifiedDate` DATETIME NULL,
  PRIMARY KEY (`AppointmentId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

delimiter $$

CREATE TABLE IF NOT EXISTS `BrandCategory` (
  `BrandCategoryId` int unsigned NOT NULL AUTO_INCREMENT COMMENT '分类ID',
  `Name` varchar(255) NOT NULL COMMENT '分类名称',
  PRIMARY KEY (`BrandCategoryId`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='品牌分类表'$$


delimiter $$

CREATE TABLE IF NOT EXISTS `Brand` (
  `BrandId` int unsigned NOT NULL AUTO_INCREMENT COMMENT '品牌ID',
  `Name` varchar(255) NOT NULL COMMENT '品牌名称',
  `Logo` varchar(255) DEFAULT NULL COMMENT 'logo地址',
  `Url` varchar(255) DEFAULT NULL COMMENT '网址',
  `Description` varchar(255) DEFAULT NULL COMMENT '描述',
  `Sort` smallint(5) NOT NULL DEFAULT '0' COMMENT '排序',
  `BrandCategoryIds` varchar(255) DEFAULT NULL COMMENT '品牌分类分类,逗号分割id ',
  PRIMARY KEY (`BrandId`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='品牌表'$$


delimiter $$

CREATE TABLE IF NOT EXISTS `Category` (
  `CategoryId` int unsigned NOT NULL AUTO_INCREMENT COMMENT '分类ID',
  `Name` varchar(50) NOT NULL COMMENT '分类名称',
  `ParentId` int unsigned NOT NULL COMMENT '父分类ID',
  `Sort` smallint(5) NOT NULL DEFAULT '0' COMMENT '排序',
  `Visibility` tinyint(1) NOT NULL DEFAULT '1' COMMENT '首页是否显示 1显示 0 不显示',
  `ModelId` int unsigned NOT NULL COMMENT '默认模型ID',
  `Keywords` varchar(255) DEFAULT NULL COMMENT 'SEO 关键词',
  `Descript` varchar(255) DEFAULT NULL COMMENT 'SEO 描述',
  `Title` varchar(255) DEFAULT NULL COMMENT 'SEO 标题 title',
  PRIMARY KEY (`CategoryId`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='产品分类表'$$


delimiter $$

CREATE TABLE IF NOT EXISTS `CategoryExtend` (
  `CategoryExtendId` int unsigned NOT NULL AUTO_INCREMENT,
  `GoodsId` int unsigned NOT NULL COMMENT '商品ID',
  `CategoryId` int unsigned NOT NULL COMMENT '商品分类ID',
  PRIMARY KEY (`CategoryExtendId`),
  KEY `GoodsId` (`GoodsId`),
  KEY `CategoryId` (`CategoryId`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COMMENT='商品扩展分类表'$$

delimiter $$

CREATE TABLE IF NOT EXISTS `Attribute` (
  `AttributeId` int unsigned NOT NULL AUTO_INCREMENT COMMENT '属性ID',
  `ModelId` int unsigned DEFAULT NULL COMMENT '模型ID',
  `Type` tinyint(1) DEFAULT NULL COMMENT '输入控件的类型,1:单选,2:复选,3:下拉',
  `Name` varchar(50) DEFAULT NULL COMMENT '名称',
  `Value` text COMMENT '属性值(逗号分隔)',
  `Search` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否支持搜索0不支持1支持',
  PRIMARY KEY (`AttributeId`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COMMENT='属性表'$$

delimiter $$

CREATE TABLE IF NOT EXISTS `Spec` (
  `SpecId` int unsigned NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) NOT NULL COMMENT '规格名称',
  `Value` text COMMENT '规格值',
  `Type` tinyint(1) NOT NULL DEFAULT '1' COMMENT '显示类型 1文字 2图片',
  `Note` varchar(255) DEFAULT NULL COMMENT '备注说明',
  `IsDeleted` tinyint(1) DEFAULT '0' COMMENT '是否删除1删除',
  PRIMARY KEY (`SpecId`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='规格表'$$

delimiter $$

CREATE TABLE IF NOT EXISTS `Model` (
  `ModelId` int unsigned NOT NULL AUTO_INCREMENT COMMENT '模型ID',
  `Name` varchar(50) NOT NULL COMMENT '模型名称',
  `SpecIds` text COMMENT '规格ID逗号分隔',
  PRIMARY KEY (`ModelId`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='模型表'$$

delimiter $$

CREATE TABLE IF NOT EXISTS `Goods` (
  `GoodsId` int unsigned NOT NULL AUTO_INCREMENT COMMENT '商品ID',
  `Name` varchar(50) NOT NULL COMMENT '商品名称',
  `GoodsNo` varchar(20) NOT NULL COMMENT '商品的货号',
  `ModelId` int unsigned NOT NULL COMMENT '模型ID',
  `SellPrice` decimal(15,2) NOT NULL COMMENT '销售价格',
  `MarketPrice` decimal(15,2) DEFAULT NULL COMMENT '市场价格',
  `CostPrice` decimal(15,2) DEFAULT NULL COMMENT '成本价格',
  `UpTime` datetime DEFAULT NULL COMMENT '上架时间',
  `DownTime` datetime DEFAULT NULL COMMENT '下架时间',
  `CreateTime` datetime NOT NULL COMMENT '创建时间',
  `StoreNums` int NOT NULL DEFAULT '0' COMMENT '库存',
  `Img` varchar(255) DEFAULT NULL COMMENT '原图',
  `IsDeleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '删除 0未删除 1已删除 2下架',
  `Content` text COMMENT '商品描述',
  `Keywords` varchar(255) DEFAULT NULL COMMENT 'SEO关键词',
  `Description` varchar(255) DEFAULT NULL COMMENT 'SEO描述',
  `SearchWords` text COMMENT '产品搜索词库,逗号分隔',
  `Weight` decimal(15,2) NOT NULL DEFAULT '0.00' COMMENT '重量',
  `Point` int NOT NULL DEFAULT '0' COMMENT '积分',
  `Unit` varchar(10) DEFAULT NULL COMMENT '计量单位',
  `BrandId` int DEFAULT NULL COMMENT '品牌ID',
  `Visit` int NOT NULL DEFAULT '0' COMMENT '浏览次数',
  `Favorite` int NOT NULL DEFAULT '0' COMMENT '收藏次数',
  `Sort` smallint(5) NOT NULL DEFAULT '99' COMMENT '排序',
  `SpecArray` text COMMENT '序列化存储规格,key值为规则ID，value为此商品具有的规格值',
  `Experience` int NOT NULL DEFAULT '0' COMMENT '经验值',
  `Comments` int NOT NULL DEFAULT '0' COMMENT '评论次数',
  `Sale` int NOT NULL DEFAULT '0' COMMENT '销量',
  `Grade` int NOT NULL DEFAULT '0' COMMENT '评分总数',
  PRIMARY KEY (`GoodsId`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='商品信息表'$$


delimiter $$

CREATE TABLE IF NOT EXISTS `GoodsAttribute` (
  `GoodsAttributeId` int unsigned NOT NULL AUTO_INCREMENT,
  `GoodsId` int unsigned NOT NULL COMMENT '商品ID',
  `AttributeId` int unsigned DEFAULT NULL COMMENT '属性ID',
  `AttributeValue` varchar(255) DEFAULT NULL COMMENT '属性值',
  `SpecId` int unsigned DEFAULT NULL COMMENT '规格ID',
  `SpecValue` varchar(255) DEFAULT NULL COMMENT '规格值',
  `ModelId` int unsigned DEFAULT NULL COMMENT '模型ID',
  `Sort` smallint(5) NOT NULL DEFAULT '99' COMMENT '排序',
  PRIMARY KEY (`GoodsAttributeId`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8 COMMENT='属性值表'$$

delimiter $$

CREATE TABLE IF NOT EXISTS `GoodsPhoto` (
  `GoodsPhotoId` char(32) NOT NULL COMMENT '图片的md5值',
  `Img` varchar(255) DEFAULT NULL COMMENT '原始图片路径',
  PRIMARY KEY (`GoodsPhotoId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='图片表'$$


delimiter $$

CREATE TABLE IF NOT EXISTS `GoodsPhotoRelation` (
  `GoodsPhotoRelationId` int unsigned NOT NULL AUTO_INCREMENT,
  `GoodsId` int unsigned NOT NULL COMMENT '商品ID',
  `PhotoId` char(32) NOT NULL DEFAULT '' COMMENT '图片ID,图片的md5值',
  PRIMARY KEY (`GoodsPhotoRelationId`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8 COMMENT='相册商品关系表'$$



delimiter $$

CREATE TABLE IF NOT EXISTS `Products` (
  `ProductsId` int unsigned NOT NULL AUTO_INCREMENT,
  `GoodsId` int unsigned NOT NULL COMMENT '货品ID',
  `ProductsNo` varchar(20) NOT NULL COMMENT '货品的货号(以商品的货号加横线加数字组成)',
  `SpecArray` text COMMENT 'json规格数据',
  `StoreNums` int NOT NULL DEFAULT '0' COMMENT '库存',
  `MarketPrice` decimal(15,2) NOT NULL DEFAULT '0.00' COMMENT '市场价格',
  `SellPrice` decimal(15,2) NOT NULL DEFAULT '0.00' COMMENT '销售价格',
  `CostPrice` decimal(15,2) NOT NULL DEFAULT '0.00' COMMENT '成本价格',
  `Weight` decimal(15,2) NOT NULL DEFAULT '0.00' COMMENT '重量',
  PRIMARY KEY (`ProductsId`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8 COMMENT='货品表'$$

delimiter $$
CREATE TABLE IF NOT EXISTS `CouponType` (
  `CouponTypeId` int unsigned NOT NULL,
  `TypeName` varchar(20) NOT NULL COMMENT '优惠券类型：代金券，减免券',
  `Description` varchar(200) NULL COMMENT '类型描述',
  `IsActive` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否有效',
  PRIMARY KEY (`CouponTypeId`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='优惠券类型'$$

DELIMITER ;;
CREATE PROCEDURE `sp_update_table_data`()
  BEGIN
  IF NOT EXISTS(
      SELECT 1
      FROM `CouponType`
      WHERE `TypeName` = '减免券' AND `CouponTypeId` = 1
  ) THEN
    INSERT INTO `CouponType` (`CouponTypeId`, `TypeName`, `Description`, `IsActive`)
    VALUES (1, '减免券', '满xx元减xx元，如：满200元减20元', 1);
  END IF;
  IF NOT EXISTS(
      SELECT 1
      FROM `CouponType`
      WHERE `TypeName` = '代金券' AND `CouponTypeId` = 2
  ) THEN
    INSERT INTO `CouponType` (`CouponTypeId`, `TypeName`, `Description`, `IsActive`)
    VALUES (2, '代金券', '代金券，xx元，如：20元', 1);
  END IF;
END;;

DELIMITER ;
CALL sp_update_table_data();
DROP PROCEDURE IF EXISTS `sp_update_table_data`;


delimiter $$
CREATE TABLE IF NOT EXISTS `CouponAmountLimitType` (
  `CouponAmountLimitTypeId` int unsigned NOT NULL,
  `TypeName` varchar(20) NOT NULL COMMENT '每个账户一张，每个账户每天一张，不限制',
  `Description` varchar(200) NULL COMMENT '类型描述',
  PRIMARY KEY (`CouponAmountLimitTypeId`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='领取数量限制'$$

DELIMITER ;;
CREATE PROCEDURE `sp_update_table_data`()
  BEGIN
  IF NOT EXISTS(
      SELECT 1
      FROM `CouponAmountLimitType`
      WHERE `TypeName` = '每个账户一张' AND `CouponAmountLimitTypeId` = 1
  ) THEN
    INSERT INTO `CouponAmountLimitType` (`CouponAmountLimitTypeId`, `TypeName`, `Description`)
    VALUES (1, '每个账户一张', '每个账户一张');
  END IF;
  IF NOT EXISTS(
      SELECT 1
      FROM `CouponAmountLimitType`
      WHERE `TypeName` = '每个账户每天一张' AND `CouponAmountLimitTypeId` = 2
  ) THEN
    INSERT INTO `CouponAmountLimitType` (`CouponAmountLimitTypeId`, `TypeName`, `Description`)
    VALUES (2, '每个账户每天一张', '每个账户每天一张');
  END IF;
  IF NOT EXISTS(
      SELECT 1
      FROM `CouponAmountLimitType`
      WHERE `TypeName` = '不限制' AND `CouponAmountLimitTypeId` = 3
  ) THEN
    INSERT INTO `CouponAmountLimitType` (`CouponAmountLimitTypeId`, `TypeName`, `Description`)
    VALUES (3, '不限制', '不限制');
  END IF;
END;;

DELIMITER ;
CALL sp_update_table_data();
DROP PROCEDURE IF EXISTS `sp_update_table_data`;


delimiter $$
CREATE TABLE IF NOT EXISTS `CouponAccountLimitType` (
  `CouponAccountLimitTypeId` int unsigned NOT NULL,
  `TypeName` varchar(20) NOT NULL COMMENT '不限制,仅QQ帐号登陆可领取,仅新浪微博帐号登陆可领取,仅淘宝帐号登陆可领取',
  `Description` varchar(200) NULL COMMENT '类型描述',
  PRIMARY KEY (`CouponAccountLimitTypeId`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='领取帐号限制'$$

DELIMITER ;;
CREATE PROCEDURE `sp_update_table_data`()
  BEGIN
  IF NOT EXISTS(
      SELECT 1
      FROM `CouponAccountLimitType`
      WHERE `TypeName` = '不限制' AND `CouponAccountLimitTypeId` = 1
  ) THEN
    INSERT INTO `CouponAccountLimitType` (`CouponAccountLimitTypeId`, `TypeName`, `Description`)
    VALUES (1, '不限制', '不限制');
  END IF;
  IF NOT EXISTS(
      SELECT 1
      FROM `CouponAccountLimitType`
      WHERE `TypeName` = '仅QQ帐号登陆可领取' AND `CouponAccountLimitTypeId` = 2
  ) THEN
      INSERT INTO `CouponAccountLimitType` (`CouponAccountLimitTypeId`, `TypeName`, `Description`)
      VALUES (2, '仅QQ帐号登陆可领取', '仅QQ帐号登陆可领取');
  END IF;
  IF NOT EXISTS(
      SELECT 1
      FROM `CouponAccountLimitType`
      WHERE `TypeName` = '仅新浪微博帐号登陆可领取' AND `CouponAccountLimitTypeId` = 3
  ) THEN
    INSERT INTO `CouponAccountLimitType` (`CouponAccountLimitTypeId`, `TypeName`, `Description`)
    VALUES (3, '仅新浪微博帐号登陆可领取', '仅新浪微博帐号登陆可领取');
  END IF;
  IF NOT EXISTS(
      SELECT 1
      FROM `CouponAccountLimitType`
      WHERE `TypeName` = '仅淘宝帐号登陆可领取' AND `CouponAccountLimitTypeId` = 4
  ) THEN
    INSERT INTO `CouponAccountLimitType` (`CouponAccountLimitTypeId`, `TypeName`, `Description`)
    VALUES (4, '仅淘宝帐号登陆可领取', '仅淘宝帐号登陆可领取');
  END IF;
END;;

DELIMITER ;
CALL sp_update_table_data();
DROP PROCEDURE IF EXISTS `sp_update_table_data`;

delimiter $$
CREATE TABLE IF NOT EXISTS `CouponPaymentType` (
  `CouponPaymentTypeId` int unsigned NOT NULL,
  `TypeName` varchar(20) NOT NULL COMMENT '免费,付费,积分',
  `Description` varchar(200) NULL COMMENT '类型描述',
  PRIMARY KEY (`CouponPaymentTypeId`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='付费'$$

DELIMITER ;;
CREATE PROCEDURE `sp_update_table_data`()
  BEGIN
  IF NOT EXISTS(
      SELECT 1
      FROM `CouponPaymentType`
      WHERE `TypeName` = '免费' AND `CouponPaymentTypeId` = 1
  ) THEN
    INSERT INTO `CouponPaymentType` (`CouponPaymentTypeId`, `TypeName`, `Description`)
    VALUES (1, '免费', '免费');
  END IF;
  IF NOT EXISTS(
      SELECT 1
      FROM `CouponPaymentType`
      WHERE `TypeName` = '付费' AND `CouponPaymentTypeId` = 2
  ) THEN
      INSERT INTO `CouponPaymentType` (`CouponPaymentTypeId`, `TypeName`, `Description`)
      VALUES (2, '付费', '付费');
  END IF;
  IF NOT EXISTS(
      SELECT 1
      FROM `CouponPaymentType`
      WHERE `TypeName` = '积分' AND `CouponPaymentTypeId` = 3
  ) THEN
    INSERT INTO `CouponPaymentType` (`CouponPaymentTypeId`, `TypeName`, `Description`)
    VALUES (3, '积分', '积分');
  END IF;
END;;

DELIMITER ;
CALL sp_update_table_data();
DROP PROCEDURE IF EXISTS `sp_update_table_data`;

delimiter $$
CREATE TABLE IF NOT EXISTS `Coupon` (
  `CouponId` INT unsigned NOT NULL AUTO_INCREMENT,
  `CouponName` varchar(20) NOT NULL COMMENT '优惠券名称',
  `CompanyId` INT NOT NULL COMMENT '商家ID',
  `CompanyName` varchar(200) NULL COMMENT '商家名称',
  `CouponTypeId` INT NOT NULL COMMENT '优惠券类型',
  `CouponTypeValue` varchar(500) COMMENT '用逗号分隔的类型值200,20，满200减20',
  `IsLiveActivity` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否现场活动',
  `LiveActivityAmount` INT NULL COMMENT '现场活动数量',
  `LiveActivityAddress` varchar(500) NULL COMMENT '现场活动领取地址',
  `HasExpire` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否有限制日期',
  `ExpireDate`  DATETIME NULL COMMENT '限制日期',
  `CouponAmountLimitTypeId` INT NOT NULL COMMENT '领取数量限制',
  `CouponAccountLimitTypeId` INT NOT NULL COMMENT '领取帐号限制',
  `CouponPaymentTypeId` INT NOT NULL COMMENT '付费',
  `CouponPaymentValue` varchar(500) NULL COMMENT '付费值',
  `CouponUsage` TEXT  COMMENT '使用说明',
  `Comments` TEXT COMMENT '温馨提示',
  `IsCouponCodeSecret` tinyint(1) NOT NULL DEFAULT '0' COMMENT '优惠码是否保密',
  `IsDeleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否删除',
  PRIMARY KEY (`CouponId`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='优惠券'$$

delimiter $$
CREATE TABLE IF NOT EXISTS `CouponCode` (
  `CouponCodeId` int unsigned NOT NULL AUTO_INCREMENT,
  `CouponId` int NOT NULL COMMENT '优惠券ID',
  `CouponName` varchar(20) NOT NULL COMMENT '优惠券名称',
  `Code` varchar(100) NOT NULL COMMENT '优惠码',
  `PassCode` varchar(100) NOT NULL COMMENT '优惠码',
  `ReceiveId` int NULL COMMENT '领取人ID',
  `ReceiverName` varchar(50) COMMENT '领取人名字',
  `ReceiveTime` DATETIME NULL COMMENT '领取时间',
  `IsDeleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否删除',
  PRIMARY KEY (`CouponCodeId`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='优惠码'$$

-- ==============================================================================

DROP PROCEDURE IF EXISTS `sp_update_table_field`;
DELIMITER ;;

CREATE PROCEDURE `sp_update_table_field`()
BEGIN
  IF NOT EXISTS (
      SELECT 1
      FROM information_schema.COLUMNS
      WHERE lower(TABLE_SCHEMA) = 'welhair'
        AND lower(TABLE_NAME) ='company'
        AND lower(COLUMN_NAME) ='logourl'
  ) THEN
    ALTER TABLE `Company` ADD `LogoUrl` VARCHAR(255) NOT NULL DEFAULT '' AFTER `Name`;
  END IF;
END;;

DELIMITER ;
CALL sp_update_table_field();
DROP PROCEDURE IF EXISTS `sp_update_table_field`;

-- ==============================================================================

CREATE TABLE IF NOT EXISTS `Roster` (
  `RosterId` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `FromId` INT UNSIGNED NOT NULL,
  `ToId` INT UNSIGNED NOT NULL,
  `Status` SMALLINT(1) NOT NULL DEFAULT 0,
  `CreatedDate` DATETIME NOT NULL,
  `LastModifiedDate` DATETIME NULL,
  PRIMARY KEY (`RosterId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `Room` (
  `RoomId` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(50) NOT NULL DEFAULT '',
  `CreatedBy` INT UNSIGNED NOT NULL,
  `CreatedDate` DATETIME NOT NULL,
  `LastModifiedDate` DATETIME NULL,
  PRIMARY KEY (`RoomId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `RoomUser` (
  `RoomUserId` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `DisplayName` VARCHAR(50) NOT NULL DEFAULT '',
  `RoomId` INT UNSIGNED NOT NULL,
  `UserId` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`RoomUserId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `Message` (
  `MessageId` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Type` SMALLINT(1) NOT NULL DEFAULT 1,
  `FromId` INT UNSIGNED NOT NULL,
  `ToId` INT UNSIGNED NOT NULL,
  `RoomId` INT UNSIGNED NOT NULL,
  `Body` TEXT NOT NULL,
  `Status` SMALLINT(1) NOT NULL DEFAULT 0,
  `CreatedDate` DATETIME NOT NULL,
  PRIMARY KEY (`MessageId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `MessageOffline` (
  `MessageOfflineId` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `UserId` INT UNSIGNED NOT NULL,
  `MessageId` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`MessageOfflineId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ==============================================================================

DROP PROCEDURE IF EXISTS `sp_update_table_field`;
DELIMITER ;;

CREATE PROCEDURE `sp_update_table_field`()
BEGIN
  IF NOT EXISTS (
      SELECT 1
      FROM information_schema.COLUMNS
      WHERE lower(TABLE_SCHEMA) = 'welhair'
        AND lower(TABLE_NAME) ='message'
        AND lower(COLUMN_NAME) ='mediatype'
  ) THEN
    ALTER TABLE `Message` ADD `MediaType` SMALLINT(1) NOT NULL DEFAULT 1 AFTER `Type`;
    ALTER TABLE `Message` ADD `MediaUrl` VARCHAR(255) NOT NULL DEFAULT '' AFTER `MediaType`;
  END IF;
END;;

DELIMITER ;
CALL sp_update_table_field();
DROP PROCEDURE IF EXISTS `sp_update_table_field`;

-- ==============================================================================

DELIMITER ;;

CREATE PROCEDURE `sp_update_table_field`()
BEGIN
  IF NOT EXISTS (
      SELECT 1
      FROM information_schema.COLUMNS
      WHERE lower(TABLE_SCHEMA) = 'welhair'
        AND lower(TABLE_NAME) ='coupon'
        AND lower(COLUMN_NAME) ='imageurl'
  ) THEN
    ALTER TABLE `Coupon` ADD `ImageUrl` VARCHAR(500) NOT NULL DEFAULT '' AFTER `CouponName`;
  END IF;
END;;

DELIMITER ;
CALL sp_update_table_field();
DROP PROCEDURE IF EXISTS `sp_update_table_field`;


DELIMITER ;;

CREATE PROCEDURE `sp_update_table_field`()
BEGIN
  IF NOT EXISTS (
      SELECT 1
      FROM information_schema.COLUMNS
      WHERE lower(TABLE_SCHEMA) = 'welhair'
        AND lower(TABLE_NAME) ='coupon'
        AND lower(COLUMN_NAME) ='isactive'
  ) THEN
    ALTER TABLE `Coupon` ADD `IsActive` SMALLINT(1) NOT NULL DEFAULT 1;
  END IF;
END;;

DELIMITER ;
CALL sp_update_table_field();
DROP PROCEDURE IF EXISTS `sp_update_table_field`;

-- ==============================================================================

CREATE TABLE IF NOT EXISTS `Comment` (
  `CommentId` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Body` TEXT NOT NULL,
  `ParentId` INT UNSIGNED NULL,
  `Deep` INT UNSIGNED NOT NULL DEFAULT 0,
  `CompanyId` INT UNSIGNED NOT NULL DEFAULT 0,
  `UserId` INT UNSIGNED NOT NULL DEFAULT 0,
  `WorkId` INT UNSIGNED NOT NULL DEFAULT 0,
  `GoodsId` INT UNSIGNED NOT NULL DEFAULT 0,
  `Rate` INT UNSIGNED NOT NULL DEFAULT 0,
  `PictureUrl` TEXT NULL,
  `CreatedBy` INT UNSIGNED NOT NULL,
  `CreatedDate` DATETIME NOT NULL,
  `LastModifiedDate` DATETIME NULL,
  PRIMARY KEY (`CommentId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `UserLike` (
  `UserLikeId` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `WorkId` INT UNSIGNED NOT NULL DEFAULT 0,
  `UserId` INT UNSIGNED NOT NULL DEFAULT 0,
  `GoodsId` INT UNSIGNED NOT NULL DEFAULT 0,
  `CreatedBy` INT UNSIGNED NOT NULL,
  `CreatedDate` DATETIME NOT NULL,
  PRIMARY KEY (`UserLikeId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `UserPoint` (
  `UserPointId` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Type` SMALLINT(1) NOT NULL DEFAULT 1,
  `UserId` INT UNSIGNED NOT NULL,
  `Value` INT UNSIGNED NOT NULL DEFAULT 0,
  `Description` VARCHAR(50) NOT NULL,
  `CreatedDate` DATETIME NOT NULL,
  PRIMARY KEY (`UserPointId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ==============================================================================


--
-- Add IsDeleted to Model table
--
DELIMITER ;;

CREATE PROCEDURE `sp_update_table_field`()
BEGIN
  IF NOT EXISTS (
      SELECT 1
      FROM information_schema.COLUMNS
      WHERE lower(TABLE_SCHEMA) = 'welhair'
        AND lower(TABLE_NAME) ='model'
        AND lower(COLUMN_NAME) ='isdeleted'
  ) THEN
    ALTER TABLE `Model` ADD `IsDeleted` SMALLINT(1) NOT NULL DEFAULT 0;
  END IF;
END;;

DELIMITER ;
CALL sp_update_table_field();
DROP PROCEDURE IF EXISTS `sp_update_table_field`;


--
-- Add IsDeleted to Brand table
--
DELIMITER ;;

CREATE PROCEDURE `sp_update_table_field`()
BEGIN
  IF NOT EXISTS (
      SELECT 1
      FROM information_schema.COLUMNS
      WHERE lower(TABLE_SCHEMA) = 'welhair'
        AND lower(TABLE_NAME) ='brand'
        AND lower(COLUMN_NAME) ='isdeleted'
  ) THEN
    ALTER TABLE `Brand` ADD `IsDeleted` SMALLINT(1) NOT NULL DEFAULT 0;
  END IF;
END;;

DELIMITER ;
CALL sp_update_table_field();
DROP PROCEDURE IF EXISTS `sp_update_table_field`;


--
-- Add IsDeleted to Category table
--
DELIMITER ;;

CREATE PROCEDURE `sp_update_table_field`()
BEGIN
  IF NOT EXISTS (
      SELECT 1
      FROM information_schema.COLUMNS
      WHERE lower(TABLE_SCHEMA) = 'welhair'
        AND lower(TABLE_NAME) ='category'
        AND lower(COLUMN_NAME) ='isdeleted'
  ) THEN
    ALTER TABLE `Category` ADD `IsDeleted` SMALLINT(1) NOT NULL DEFAULT 0;
  END IF;
END;;

DELIMITER ;
CALL sp_update_table_field();
DROP PROCEDURE IF EXISTS `sp_update_table_field`;

