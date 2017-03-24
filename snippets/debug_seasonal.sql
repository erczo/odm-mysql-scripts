SELECT LocalDateTime, DataValue, DatastreamID
FROM datavalues_seasonal
WHERE DatastreamID = 13082
  AND LocalDateTime >= '2016-01-01 00:00:00'
  AND LocalDateTime <  '2017-01-01 00:00:00'
ORDER BY LocalDateTime;

SELECT LocalDateTime, DataValue, DatastreamID
FROM odm.datavalues_seasonal
WHERE DatastreamID = 13082
  AND LocalDateTime >= '2016-01-01 00:00:00'
  AND LocalDateTime <  '2017-01-01 00:00:00'
ORDER BY LocalDateTime;
