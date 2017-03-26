-- MySQL command-line tool
-- $ mysql --host=gall.berkeley.edu --user=username --password=pass odm

-- MySQL version info
SHOW VARIABLES LIKE "%version%";

SHOW TABLES LIKE 'datavalues%';

-- +-----------------------------+
-- | Tables_in_odm (datavalues%) |
-- +-----------------------------+
-- | datavalues2                 |
-- | datavalues2_raw             |
-- | datavalues_30min            |
-- | datavalues_BORR             |
-- | datavalues_UCNRS            |
-- | datavalues_cum_Dec12        |
-- | datavalues_deleted          |
-- | datavalues_motes            |
-- | datavalues_sagehen          |
-- | datavalues_seasonal         |
-- | datavalues_test             |
-- +-----------------------------+

SHOW INDEX FROM `datavalues_UCNRS`;

-- +------------------+------------+------------------------------------------+--------------+-------------------------+-----------+-------------+----------+--------+------+------------+---------+
-- | Table            | Non_unique | Key_name                                 | Seq_in_index | Column_name             | Collation | Cardinality | Sub_part | Packed | Null | Index_type | Comment |
-- +------------------+------------+------------------------------------------+--------------+-------------------------+-----------+-------------+----------+--------+------+------------+---------+
-- | datavalues_UCNRS |          0 | PRIMARY                                  |            1 | ValueID                 | A         |   282727851 |     NULL | NULL   |      | BTREE      |         |
-- | datavalues_UCNRS |          0 | ValueID                                  |            1 | ValueID                 | A         |   282727851 |     NULL | NULL   |      | BTREE      |         |
-- | datavalues_UCNRS |          1 | datavalues_UCNRS_LocalDateTime           |            1 | LocalDateTime           | A         |        NULL |     NULL | NULL   |      | BTREE      |         |
-- | datavalues_UCNRS |          1 | datavalues_UCNRS_QualityControlLevelCode |            1 | QualityControlLevelCode | A         |        NULL |     NULL | NULL   |      | BTREE      |         |
-- | datavalues_UCNRS |          1 | datavalues_UCNRS_QualifierID             |            1 | QualifierID             | A         |        NULL |     NULL | NULL   |      | BTREE      |         |
-- | datavalues_UCNRS |          1 | datavalues_UCNRS_DatastreamID            |            1 | DatastreamID            | A         |        NULL |     NULL | NULL   |      | BTREE      |         |
-- | datavalues_UCNRS |          1 | datavalues_UCNRS_DerivedFromID           |            1 | DerivedFromID           | A         |        NULL |     NULL | NULL   | YES  | BTREE      |         |
-- +------------------+------------+------------------------------------------+--------------+-------------------------+-----------+-------------+----------+--------+------+------------+---------+

DROP INDEX `datavalues_UCNRS_DatastreamID` ON `datavalues_UCNRS`;
DROP INDEX `datavalues_UCNRS_LocalDateTime` ON `datavalues_UCNRS`;

CREATE INDEX `ix_datavalues_UCNRS_1` ON `datavalues_UCNRS` (`DatastreamID`, `LocalDateTime`) USING BTREE;
CREATE INDEX `ix_datavalues_UCNRS_2` ON `datavalues_UCNRS` (`LocalDateTime`, `DatastreamID`) USING BTREE;

-- Or do it all at once!
ALTER TABLE `datavalues_UCNRS`
	DROP INDEX `ValueID`,
	DROP INDEX `datavalues_UCNRS_DatastreamID`,
	DROP INDEX `datavalues_UCNRS_LocalDateTime`,
	ADD INDEX `ix_datavalues_UCNRS_1` (`DatastreamID`, `LocalDateTime`) USING BTREE,
	ADD INDEX `ix_datavalues_UCNRS_2` (`LocalDateTime`, `DatastreamID`) USING BTREE;

ANALYZE TABLE `datavalues_UCNRS`;

--
-- Verify
--

EXPLAIN EXTENDED
SELECT
	`ValueID` AS `id` ,
	`DatastreamID` AS `datastream_id` ,
	`LocalDateTime` AS `local_date_time` ,
	`UTCOffset` AS `utc_offset` ,
	`DataValue` AS `value`
FROM
	`datavalues_UCNRS` AS `t`
-- USE INDEX (`ix_datavalues_UCNRS_1`)
WHERE
	`t`.`DatastreamID` = 1596
AND(
	`t`.`LocalDateTime` >= '2013-05-07 07:10:00'
	AND `t`.`LocalDateTime` <= '2999-12-31 16:00:00'
)
ORDER BY
	`t`.`LocalDateTime` DESC
LIMIT 10;

EXPLAIN EXTENDED
SELECT
	`ValueID` AS `id` ,
	`DatastreamID` AS `datastream_id` ,
	`LocalDateTime` AS `local_date_time` ,
	`UTCOffset` AS `utc_offset` ,
	`DataValue` AS `value`
FROM
	`datavalues_UCNRS` AS `t`
-- USE INDEX (`ix_datavalues_UCNRS_1`)
WHERE
	`t`.`DatastreamID` = 1596
AND(
	`t`.`LocalDateTime` >= '2010-11-19 09:00:00'
	AND `t`.`LocalDateTime` <= '2010-11-19 09:00:00'
)
ORDER BY
	`t`.`LocalDateTime` DESC
LIMIT 1;
