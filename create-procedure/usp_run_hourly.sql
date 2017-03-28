/**
 * Calls various stored procedures that should be run on an hourly basis; mainly to update summary tables.
 *
 * Dependencies:
 *   usp_load_datavalues_day_mma_dv2
 *   usp_load_datavalues_day_mma_UCNRS
 *   usp_load_datavalues_day_sum_dv2
 *   usp_load_datavalues_day_sum_UCNRS
 *   
 * @author J. Scott Smith
 * @license BSD-2-Clause-FreeBSD
 */
DROP PROCEDURE IF EXISTS `usp_run_hourly`;

DELIMITER //
CREATE PROCEDURE `usp_run_hourly` ()
  SQL SECURITY INVOKER
BEGIN
  SET @curDate = CURDATE();

  -- Load/revise daily values from yesterday to today
  SET @startDateTime = SUBDATE(@curDate, 1);
  SET @endDateTime = ADDDATE(@curDate, 1);
  CALL usp_load_datavalues_day_mma_dv2(@startDateTime, @endDateTime);
  CALL usp_load_datavalues_day_mma_UCNRS(@startDateTime, @endDateTime);
  CALL usp_load_datavalues_day_sum_dv2(@startDateTime, @endDateTime);
  CALL usp_load_datavalues_day_sum_UCNRS(@startDateTime, @endDateTime);

END //
DELIMITER ;
