-- Insert DatastreamID's into cfg tables
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
