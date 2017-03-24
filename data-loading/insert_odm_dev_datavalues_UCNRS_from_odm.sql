INSERT INTO odm_dev.datavalues_UCNRS
SELECT * FROM odm.datavalues_UCNRS
WHERE DatastreamID = 3082
AND LocalDateTime >= '2016-01-01 00:00:00'
AND LocalDateTime < '2016-07-01 00:00:00';

TRUNCATE TABLE odm_dev.datavalues_UCNRS;

INSERT INTO odm_dev.datavalues_UCNRS
SELECT * FROM odm.datavalues_UCNRS
WHERE DatastreamID = 3350
AND LocalDateTime >= '2016-01-01 00:00:00'
AND LocalDateTime < '2016-07-01 00:00:00';

INSERT INTO odm_dev.datavalues_UCNRS
SELECT * FROM odm.datavalues_UCNRS
WHERE DatastreamID = 3082
AND LocalDateTime >= '2017-01-01 00:00:00';

-- Get all air temp values
TRUNCATE TABLE odm_dev.datavalues_UCNRS;

INSERT INTO odm_dev.datavalues_UCNRS
SELECT * FROM odm.datavalues_UCNRS
WHERE DatastreamID = 3077;
