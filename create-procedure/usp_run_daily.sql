/**
 * Calls various stored procedures that should be run on a daily basis; mainly to update summary tables.
 *
 * Dependencies:
 *   usp_load_datavalues_day_mma_dv2
 *   usp_load_datavalues_day_mma_UCNRS
 *   usp_load_datavalues_day_sum_dv2
 *   usp_load_datavalues_day_sum_UCNRS
 *   usp_load_datavalues_month
 *   usp_load_datavalues_seasonal
 *   
 * @author J. Scott Smith
 * @license BSD-2-Clause-FreeBSD
 */
DROP PROCEDURE IF EXISTS `usp_run_daily`;

DELIMITER //
CREATE PROCEDURE `usp_run_daily` ()
  SQL SECURITY INVOKER
BEGIN
  SET @curDate = CURDATE();

  -- Load/revise daily values from 30 days back to today
  SET @startDateTime = SUBDATE(@curDate, 30);
  SET @endDateTime = ADDDATE(@curDate, 1);
  CALL usp_load_datavalues_day_mma_dv2(@startDateTime, @endDateTime);
  CALL usp_load_datavalues_day_mma_UCNRS(@startDateTime, @endDateTime);
  CALL usp_load_datavalues_day_sum_dv2(@startDateTime, @endDateTime);
  CALL usp_load_datavalues_day_sum_UCNRS(@startDateTime, @endDateTime);

  -- Load/revise datavalues for affected months
  CALL usp_load_datavalues_month(@startDateTime, @endDateTime);

  -- Load/revise datavalues for the current season
  CALL usp_load_datavalues_seasonal(YEAR(@curDate));

END //
DELIMITER ;
