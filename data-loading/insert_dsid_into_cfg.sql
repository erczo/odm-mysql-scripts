-- Insert DatastreamID's into cfg tables

-- UCNRS
-- Precipitation Daily Sum
INSERT INTO cfg_load_datavalues_day_sum (DatastreamID) 
SELECT 
	DatastreamID
FROM datastreams 
WHERE 
	VariableCode = "Rainfall mm" AND 
	MC_Name = "UCNRS";

-- Min,Max,Averages Daily
-- 6 Variables that need to be converted into averages
-- 3077:'Air Temp Deg C Blue Oak Avg',
-- 3105:'Soil Temp Deg C 20 in Blue Oak Avg',
-- 3106:'Soil Moisture VWC Blue Oak Avg',
-- 3069:'Wind Speed m s Blue Oak Avg',
-- 3080:'Relative Humidity Per Blue Oak Avg',
-- 3081:'Barometric Pressure mbar Blue Oak Avg'

-- Air Temperature
INSERT INTO cfg_load_datavalues_day_mma (DatastreamID) 
SELECT DatastreamID FROM datastreams 
WHERE 
datastreamname like 'Air Temp Deg C%Avg' AND 
datastreamname not like 'Air Temp Deg C% m %Avg' AND 
MC_Name = "UCNRS";

-- Wind Speed 
INSERT INTO cfg_load_datavalues_day_mma (DatastreamID) 
SELECT DatastreamID FROM datastreams 
WHERE 
datastreamname like 'Wind Speed m s%Avg' AND 
MC_Name = "UCNRS";

-- Relative Humidity
INSERT INTO cfg_load_datavalues_day_mma (DatastreamID) 
SELECT DatastreamID FROM datastreams 
WHERE 
datastreamname like 'Relative Humidity Per % Avg' AND 
MC_Name = "UCNRS";

-- Barometric Pressure
INSERT INTO cfg_load_datavalues_day_mma (DatastreamID) 
SELECT DatastreamID FROM datastreams 
WHERE 
datastreamname like 'Barometric Pressure mbar % Avg' AND 
MC_Name = "UCNRS";

-- Soil Temperature <-- this is not used in the dashboard
-- 80 DSID's if all are allowed.  22 DSID's if 4 inch depth is used.
INSERT INTO cfg_load_datavalues_day_mma (DatastreamID) 
SELECT DatastreamID FROM datastreams 
WHERE 
datastreamname like 'Soil Temp Deg C % Avg' AND 
MC_Name = "UCNRS";


--
-- Angelo
-- 
-- cfg_load_datavalues_day_sum

-- Precipitation
INSERT INTO cfg_load_datavalues_day_sum (DatastreamID) 
SELECT DatastreamID FROM datastreams 
WHERE 
variablecode like 'Rainfall mm' 
AND datastreamname not like '%30min'  
AND MC_Name = "Angelo Reserve";


-- cfg_load_datavalues_day_mma

-- Well Water Levels
INSERT INTO cfg_load_datavalues_day_mma (DatastreamID) 
SELECT datastreamid, datastreamname FROM datastreams 
WHERE variablecode LIKE 'Water Level m' 
AND datastreamname NOT LIKE '%Old' 
AND datastreamname not like '%30min';

-- Air Temperature
INSERT INTO cfg_load_datavalues_day_mma (DatastreamID) 
SELECT DatastreamID,datastreamname FROM datastreams 
WHERE 
MC_Name = "Angelo Reserve" 
AND VariableCode like 'Air Temp C' 
AND datastreamname not like '%30min' 
AND datastreamname not like '%Delta%' 
AND datastreamname not like '%Min' 
AND datastreamname not like '%Max';

-- Wind Speed
INSERT INTO cfg_load_datavalues_day_mma (DatastreamID) 
SELECT DatastreamID FROM datastreams 
WHERE 
MC_Name = "Angelo Reserve" 
AND VariableCode like  '%wind speed%ms'  
AND datastreamname not like '%30min' 
AND  datastreamname not like '%ingrid%';


-- Battery Voltage 
INSERT INTO cfg_load_datavalues_day_mma (DatastreamID) 
SELECT DatastreamID FROM datastreams 
WHERE 
MC_Name = "Angelo Reserve" 
AND VariableCode = "Battery Voltage" 
AND datastreamname not like '%_2' 
AND datastreamname not like '%Avg' 
AND datastreamname not like '%Max';


-- Relative Humidity
INSERT INTO cfg_load_datavalues_day_mma (DatastreamID) 
SELECT DatastreamID FROM datastreams 
WHERE 
MC_Name = "Angelo Reserve" 
AND VariableCode like  'Rel Humidity Perc'  
AND datastreamname not like '%30min' 
AND  datastreamname not like '%ingrid%';


-- Barometric Pressure
INSERT INTO cfg_load_datavalues_day_mma (DatastreamID) 
SELECT DatastreamID FROM datastreams 
WHERE 
MC_Name = "Angelo Reserve" 
AND VariableCode like  'Barometric Pressure mb'  
AND datastreamname not like '%30min' 
AND  datastreamname not like '%ingrid%';


-- Soil Temperature <-- this is not used in the dashboard
-- 80 DSID's if all are allowed.  22 DSID's if 4 inch depth is used.
-- 63 rows used
INSERT INTO cfg_load_datavalues_day_mma (DatastreamID) 
SELECT DatastreamID FROM datastreams 
WHERE 
MC_Name = "Angelo Reserve" 
AND VariableCode like  'Soil Temperature C'  
AND datastreamname not like '%30min' 
AND datastreamname not like '%Max' 
AND datastreamname not like '%Min';


-- Soil Moisture TDR only
INSERT INTO cfg_load_datavalues_day_mma (DatastreamID) 
SELECT DatastreamID FROM datastreams 
WHERE 
MC_Name = "Angelo Reserve" 
AND VariableCode like 'Soil Moisture Pct%';  
