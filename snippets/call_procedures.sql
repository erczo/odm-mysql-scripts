-- Init
TRUNCATE TABLE datavalues_day;
TRUNCATE TABLE datavalues_month;
TRUNCATE TABLE datavalues_seasonal;

-- Load datavalues for today
-- SET @startDateTime = CURDATE();
-- SET @endDateTime = ADDDATE(CURDATE(), 1);

-- Load datavalues since start of 2000
SET @startDateTime = '2000-01-01 00:00:00';
SET @endDateTime = ADDDATE(CURDATE(), 1);

-- Call SPs
CALL usp_load_datavalues_day_mma_UCNRS(@startDateTime, @endDateTime);
CALL usp_load_datavalues_day_sum_UCNRS(@startDateTime, @endDateTime);
CALL usp_load_datavalues_month(@startDateTime, @endDateTime);
CALL usp_load_datavalues_seasonal(2012);
CALL usp_load_datavalues_seasonal(2013);
CALL usp_load_datavalues_seasonal(2014);
CALL usp_load_datavalues_seasonal(2015);
CALL usp_load_datavalues_seasonal(2016);
