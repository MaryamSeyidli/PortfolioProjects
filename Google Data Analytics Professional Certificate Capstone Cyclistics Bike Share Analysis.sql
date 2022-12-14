

--DELETING rows where ride_id was repeated more than 1
WITH cte AS (
    SELECT 
      *, 
        ROW_NUMBER() OVER (
            PARTITION BY 
                ride_id
            ORDER BY 
                ride_id
        ) row_num
     FROM 
        divvy_tripdata_202207
)
DELETE FROM cte
WHERE row_num > 1;
SELECT *
FROM divvy_tripdata_202207



 -- DELETING rows where STARTED_AT time is bigger than or equal to ENDED_AT time
DELETE FROM divvy_tripdata_202207
WHERE started_at>=ended_at


--Finding how long the bike was used each time
ALTER TABLE divvy_tripdata_202207
ADD biking_time time
UPDATE divvy_tripdata_202207
SET biking_time=(ended_at-started_at)

use Cyclistics_bike_share_analysis
SELECT *
FROM divvy_tripdata_202207

--Using TRIM function in order to remove all additional spaces
UPDATE divvy_tripdata_202207
SET ride_id=TRIM(ride_id),
start_station_name=TRIM(start_station_name),
end_station_name=TRIM(end_station_name)


--Writing biking time as minutes and seconds
ALTER TABLE divvy_tripdata_202207
ADD biking_time_in_minutes varchar(50)
UPDATE divvy_tripdata_202207
SET biking_time_in_minutes = CONCAT(DATEDIFF(minute, started_at,ended_at), ' minutes ', (DATEDIFF(second, started_at,ended_at))%60, ' seconds')

--Getting on which weekday the bike was used
ALTER TABLE divvy_tripdata_202207
ADD weekday varchar(20)
UPDATE divvy_tripdata_202207
SET weekday=DATENAME(WEEKDAY, started_at)

--Deleting rows where membership, rideable_type, start_station_name, end_station_name are null
DELETE FROM divvy_tripdata_202207
WHERE member_casual is NULL OR
rideable_type is NULL OR
start_station_name is NULL OR
end_station_name is NULL

