/**
 * Populates the datavalues_seasonal table with seasonal aggregates derived from datavalues_day.
 *
 * NOTES:
 *   - The procedure is re-runnable and can be used to insert and update seasonal values as needed.
 *   - Generating seasonal data for a given year (e.g. 2016) does NOT use data from that year.
 * 
 * Dependencies:
 *   datavalues_day - must contain values for years prior to the desired season/year
 *   
 * Parameters:
 *   pYear - the season/year
 *
 * @author J. Scott Smith
 * @license BSD-2-Clause-FreeBSD
 */
DROP PROCEDURE IF EXISTS `usp_load_datavalues_seasonal`;

DELIMITER //
CREATE PROCEDURE `usp_load_datavalues_seasonal`
  (IN pYear SMALLINT)
  SQL SECURITY INVOKER
BEGIN
  DROP TEMPORARY TABLE IF EXISTS `tmp_datavalues`;
  DROP TEMPORARY TABLE IF EXISTS `tmp_datavalues_grouped`;

  -- Temp table to bin datavalues by datastream and month
  CREATE TEMPORARY TABLE `tmp_datavalues` (
    `ValueID` bigint(20) unsigned NOT NULL,
    `DataValue` double DEFAULT NULL,
    `LocalDateTime` datetime NOT NULL,
    `UTCOffset` tinyint(4) NOT NULL,
    `DerivedFromID` smallint(5) unsigned DEFAULT NULL,
    `DatastreamID` smallint(5) unsigned NOT NULL,
    KEY `ix_tmp_datavalues_1` (`DatastreamID`, `LocalDateTime`)
  );

  -- Temp table to store aggregated values, grouped by datastream and month
  CREATE TEMPORARY TABLE `tmp_datavalues_grouped` (
    `ValueID` bigint(20) unsigned NOT NULL,
    `DataValue_Min` double DEFAULT NULL,
    `DataValue_Max` double DEFAULT NULL,
    `DataValue_Avg` double DEFAULT NULL,
    `LocalDateTime` datetime NOT NULL,
    `UTCOffset` tinyint(4) NOT NULL,
    `DerivedFromID` smallint(5) unsigned DEFAULT NULL,
    `DatastreamID` smallint(5) unsigned NOT NULL,
    PRIMARY KEY (`DatastreamID`, `LocalDateTime`)
  );

  -- Collect daily datavalues, set date to start of month in season/year
  INSERT INTO tmp_datavalues (ValueID, DataValue, LocalDateTime, UTCOffset, DerivedFromID, DatastreamID)
  SELECT
    v.ValueID,
    v.DataValue,
    CAST(DATE_ADD(MAKEDATE(pYear, 1), INTERVAL (MONTH(v.LocalDateTime) - 1) MONTH) AS DATETIME),
    v.UTCOffset,
    v.DerivedFromID,
    v.DatastreamID
  FROM datavalues_day AS v
  WHERE v.LocalDateTime < CAST(MAKEDATE(pYear, 1) AS DATETIME);

  -- Group datavalues by datastream and month, perform AVG aggregation on MIN/MAX/AVG datavalues
  INSERT INTO tmp_datavalues_grouped (DatastreamID, LocalDateTime, ValueID, UTCOffset, DerivedFromID, DataValue_Avg)
  SELECT
    DatastreamID,
    LocalDateTime,
    MIN(ValueID),
    MIN(UTCOffset),
    MIN(DerivedFromID),
    AVG(DataValue)
  FROM tmp_datavalues
  WHERE DatastreamID BETWEEN 10000 AND 39999
  GROUP BY
    DatastreamID, 
    LocalDateTime;

  -- Group datavalues by datastream and month, perform MIN/MAX/AVG aggregations on SUM (cumulative) datavalues
  INSERT INTO tmp_datavalues_grouped (DatastreamID, LocalDateTime, ValueID, UTCOffset, DerivedFromID, DataValue_Min, DataValue_Max, DataValue_Avg)
  SELECT
    DatastreamID,
    LocalDateTime,
    MIN(ValueID),
    MIN(UTCOffset),
    MIN(DerivedFromID),
    MIN(DataValue),
    MAX(DataValue),
    AVG(DataValue)
  FROM tmp_datavalues
  WHERE DatastreamID BETWEEN 40000 AND 49999
  GROUP BY
    DatastreamID, 
    LocalDateTime;

  --  
  -- Insert/update seasonal datavalues
  -- NOTE: Requires a unique key on DatastreamID, LocalDateTime
  --

  INSERT INTO datavalues_seasonal (DataValue, LocalDateTime, UTCOffset, QualifierID, DerivedFromID, QualityControlLevelCode, DatastreamID)
  SELECT
    DataValue_Avg,
    LocalDateTime,
    UTCOffset,
    2,
    DerivedFromID,
    2,
    DatastreamID
  FROM tmp_datavalues_grouped
  WHERE DatastreamID BETWEEN 10000 AND 39999
  ON DUPLICATE KEY UPDATE DataValue = tmp_datavalues_grouped.DataValue_Avg;

  INSERT INTO datavalues_seasonal (DataValue, LocalDateTime, UTCOffset, QualifierID, DerivedFromID, QualityControlLevelCode, DatastreamID)
  SELECT
    DataValue_Min,
    LocalDateTime,
    UTCOffset,
    2,
    DerivedFromID,
    2,
    10000 + DerivedFromID
  FROM tmp_datavalues_grouped
  WHERE DatastreamID BETWEEN 40000 AND 49999
  ON DUPLICATE KEY UPDATE DataValue = tmp_datavalues_grouped.DataValue_Min;

  INSERT INTO datavalues_seasonal (DataValue, LocalDateTime, UTCOffset, QualifierID, DerivedFromID, QualityControlLevelCode, DatastreamID)
  SELECT
    DataValue_Max,
    LocalDateTime,
    UTCOffset,
    2,
    DerivedFromID,
    2,
    30000 + DerivedFromID
  FROM tmp_datavalues_grouped
  WHERE DatastreamID BETWEEN 40000 AND 49999
  ON DUPLICATE KEY UPDATE DataValue = tmp_datavalues_grouped.DataValue_Max;

  INSERT INTO datavalues_seasonal (DataValue, LocalDateTime, UTCOffset, QualifierID, DerivedFromID, QualityControlLevelCode, DatastreamID)
  SELECT
    DataValue_Avg,
    LocalDateTime,
    UTCOffset,
    2,
    DerivedFromID,
    2,
    20000 + DerivedFromID
  FROM tmp_datavalues_grouped
  WHERE DatastreamID BETWEEN 40000 AND 49999
  ON DUPLICATE KEY UPDATE DataValue = tmp_datavalues_grouped.DataValue_Avg;

  -- Cleanup
  DROP TEMPORARY TABLE IF EXISTS `tmp_datavalues`;
  DROP TEMPORARY TABLE IF EXISTS `tmp_datavalues_grouped`;
END //
DELIMITER ;
