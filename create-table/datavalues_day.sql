SET NAMES utf8;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
--  Table structure for `datavalues_day`
-- ----------------------------
DROP TABLE IF EXISTS `datavalues_day`;
CREATE TABLE `datavalues_day` (
  `ValueID` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `DataValue` double DEFAULT NULL,
  `ValueAccuracy` double DEFAULT NULL,
  `LocalDateTime` datetime NOT NULL,
  `UTCOffset` tinyint(4) NOT NULL,
  `QualifierID` mediumint(8) unsigned NOT NULL,
  `DerivedFromID` smallint(5) unsigned DEFAULT NULL,
  `QualityControlLevelCode` char(4) NOT NULL,
  `DatastreamID` smallint(5) unsigned NOT NULL,
  PRIMARY KEY (`ValueID`)
) ENGINE=MyISAM AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;

CREATE UNIQUE INDEX `uk_datavalues_day_1` ON `datavalues_day` (`DatastreamID`, `LocalDateTime`) USING BTREE;
CREATE UNIQUE INDEX `uk_datavalues_day_2` ON `datavalues_day` (`LocalDateTime`, `DatastreamID`) USING BTREE;

SET FOREIGN_KEY_CHECKS = 1;
