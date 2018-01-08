/**
 * Populates the datavalues_day table with daily SUM (cumulative) aggregates derived from datavalues2.
 *
 * NOTES:
 *   - The procedure is re-runnable and can be used to insert and update daily values as needed.
 *
 * Dependencies:
 *   cfg_load_datavalues_day_sum - must contain datastream IDs to evaluate
 *   datavalues2 - should contain values within the desired days
 *
 * Parameters:
 *   pStartDateTime - the starting day (inclusive)
 *   pEndDateTime - the ending day (exclusive)
 *
 * @author J. Scott Smith
 * @license BSD-2-Clause-FreeBSD
 */
DROP PROCEDURE IF EXISTS `usp_load_datavalues_day_sum_dv2`;

DELIMITER //
CREATE PROCEDURE `usp_load_datavalues_day_sum_dv2`
  (IN pStartDateTime DATETIME, IN pEndDateTime DATETIME)
  SQL SECURITY INVOKER
BEGIN
  DROP TEMPORARY TABLE IF EXISTS `tmp_datavalues`;
  DROP TEMPORARY TABLE IF EXISTS `tmp_datavalues_grouped`;

  -- Temp table to bin datavalues by datastream and day
  CREATE TEMPORARY TABLE `tmp_datavalues` (
    `ValueID` bigint(20) unsigned NOT NULL,
    `DataValue` double DEFAULT NULL,
    `LocalDateTime` datetime NOT NULL,
    `UTCOffset` tinyint(4) NOT NULL,
    `QualifierID` mediumint(8) unsigned NOT NULL,
    `DatastreamID` smallint(5) unsigned NOT NULL,
    KEY `ix_tmp_datavalues_1` (`DatastreamID`, `LocalDateTime`),
    KEY `ix_tmp_datavalues_2` (`QualifierID`)
  );

  -- Temp table to store aggregated values, grouped by datastream and day
  CREATE TEMPORARY TABLE `tmp_datavalues_grouped` (
    `ValueID` bigint(20) unsigned NOT NULL,
    `DataValue_Sum` double DEFAULT NULL,
    `LocalDateTime` datetime NOT NULL,
    `UTCOffset` tinyint(4) NOT NULL,
    `DatastreamID` smallint(5) unsigned NOT NULL,
    PRIMARY KEY (`DatastreamID`, `LocalDateTime`)
  );

  -- Collect datavalues for configured datastreams, truncate time component
  INSERT INTO tmp_datavalues (ValueID, DataValue, LocalDateTime, UTCOffset, QualifierID, DatastreamID)
  SELECT
    v.ValueID,
    v.DataValue,
    CAST(DATE(v.LocalDateTime) AS DATETIME),
    v.UTCOffset,
    v.QualifierID,
    v.DatastreamID
  FROM datavalues2 AS v
    INNER JOIN cfg_load_datavalues_day_sum AS c ON v.DatastreamID = c.DatastreamID
  WHERE v.LocalDateTime >= CAST(DATE(pStartDateTime) AS DATETIME)
    AND v.LocalDateTime < CAST(DATE(pEndDateTime) AS DATETIME);

  -- Remove datavalues (FROM tmp!) that are not qualified
  -- NOTE: Could be added to above query; but wanted to use only DatastreamID/LocalDateTime in the initial fetch
  DELETE FROM tmp_datavalues
  WHERE (DataValue = -9999) OR (QualifierID IN (SELECT QualifierID
    FROM qualifiers
    WHERE QualifierCode = 'VB' OR QualifierCode LIKE 'VB %'
      OR QualifierCode = 'VE' OR QualifierCode LIKE 'VE %'
      OR QualifierCode = 'X' OR QualifierCode LIKE 'X %'));

  -- Group datavalues by datastream and day, perform SUM aggregation
  INSERT INTO tmp_datavalues_grouped (DatastreamID, LocalDateTime, ValueID, UTCOffset, DataValue_Sum)
  SELECT
    DatastreamID,
    LocalDateTime,
    MIN(ValueID),
    MIN(UTCOffset),
    SUM(DataValue)
  FROM tmp_datavalues
  GROUP BY
    DatastreamID,
    LocalDateTime;

  --
  -- Insert/update daily datavalues
  -- NOTE: Requires a unique key on DatastreamID, LocalDateTime
  --

  INSERT INTO datavalues_day (DataValue, LocalDateTime, UTCOffset, QualifierID, DerivedFromID, QualityControlLevelCode, DatastreamID)
  SELECT
    DataValue_Sum,
    LocalDateTime,
    UTCOffset,
    2,
    DatastreamID,
    2,
    40000 + DatastreamID
  FROM tmp_datavalues_grouped
  ON DUPLICATE KEY UPDATE DataValue = tmp_datavalues_grouped.DataValue_Sum;

  -- Cleanup
  DROP TEMPORARY TABLE IF EXISTS `tmp_datavalues`;
  DROP TEMPORARY TABLE IF EXISTS `tmp_datavalues_grouped`;
END //
DELIMITER ;
