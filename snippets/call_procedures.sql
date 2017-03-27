-- Init
TRUNCATE TABLE datavalues_day;
TRUNCATE TABLE datavalues_month;
TRUNCATE TABLE datavalues_seasonal;

-- Load datavalues for today
-- SET @startDateTime = CURDATE();
-- SET @endDateTime = ADDDATE(CURDATE(), 1);

-- Load datavalues since start of 2000
SET @startDateTime = '1980-01-01 00:00:00';
SET @endDateTime = ADDDATE(CURDATE(), 1);

-- Call SPs
CALL usp_load_datavalues_day_mma_UCNRS(@startDateTime, @endDateTime);  -- 13 minutes
CALL usp_load_datavalues_day_sum_UCNRS(@startDateTime, @endDateTime);  -- 27 seconds
CALL usp_load_datavalues_day_mma_dv2(@startDateTime, @endDateTime);  -- 24 minutes
CALL usp_load_datavalues_day_sum_dv2(@startDateTime, @endDateTime);  -- 5 minutes
CALL usp_load_datavalues_month(@startDateTime, @endDateTime);  -- 6 sec
CALL usp_load_datavalues_seasonal(1997);
CALL usp_load_datavalues_seasonal(1998);
CALL usp_load_datavalues_seasonal(1999);
CALL usp_load_datavalues_seasonal(2000);
CALL usp_load_datavalues_seasonal(2001);
CALL usp_load_datavalues_seasonal(2002);
CALL usp_load_datavalues_seasonal(2003);
CALL usp_load_datavalues_seasonal(2004);
CALL usp_load_datavalues_seasonal(2005);
CALL usp_load_datavalues_seasonal(2006);
CALL usp_load_datavalues_seasonal(2007);
CALL usp_load_datavalues_seasonal(2008);
CALL usp_load_datavalues_seasonal(2009);
CALL usp_load_datavalues_seasonal(2010);
CALL usp_load_datavalues_seasonal(2011);
CALL usp_load_datavalues_seasonal(2012);
CALL usp_load_datavalues_seasonal(2013);
CALL usp_load_datavalues_seasonal(2014);
CALL usp_load_datavalues_seasonal(2015);
CALL usp_load_datavalues_seasonal(2016);

--
