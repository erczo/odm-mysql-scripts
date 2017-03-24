SET NAMES utf8;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
--  Table structure for `cfg_load_datavalues_day_sum`
-- ----------------------------
DROP TABLE IF EXISTS `cfg_load_datavalues_day_sum`;
CREATE TABLE `cfg_load_datavalues_day_sum` (
  `DatastreamID` bigint(20) NOT NULL,
  PRIMARY KEY (`DatastreamID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

SET FOREIGN_KEY_CHECKS = 1;
