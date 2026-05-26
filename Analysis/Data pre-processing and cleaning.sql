---SELECT Qyery to check the column names and data type in all 12 tables (jan2025-dec2025)
SELECT table_name, column_name, data_type
FROM `cyclistic-bike-share-494916.trips_2025.INFORMATION_SCHEMA.COLUMNS`
WHERE table_name IN ('jan_2025', 'feb_2025', 'mar_2025', 'apr_2025', 'may_2025', 'jun_2025', 'july_2025', 'aug_2025', 'sep_2025', 'oct_2025', 'nov_2025', 'dec_2025') -- add all 12 here
ORDER BY column_name;

---SELECT Query to check whether each column is repeated in all 12 tables (12 count)
SELECT 
  column_name, 
  data_type, 
  COUNT(table_name) AS table_count,
  STRING_AGG(table_name, ', ') AS tables_with_this_column
FROM 
  `cyclistic-bike-share-494916.trips_2025.INFORMATION_SCHEMA.COLUMNS`
WHERE 
  table_name IN ('jan_2025', 'feb_2025', 'mar_2025', 'apr_2025', 'may_2025', 'jun_2025', 
                 'july_2025', 'aug_2025', 'sep_2025', 'oct_2025', 'nov_2025', 'dec_2025')
GROUP BY 
  1, 2
ORDER BY 
  table_count ASC; -- Tables with mismatches will float to the top

  --CREATE A MASTER TABLE
CREATE OR REPLACE TABLE `cyclistic-bike-share-494916.trips_2025.raw_data_2025` AS

SELECT * FROM `cyclistic-bike-share-494916.trips_2025.jan_2025`
UNION ALL
SELECT * FROM `cyclistic-bike-share-494916.trips_2025.feb_2025`
UNION ALL
SELECT * FROM `cyclistic-bike-share-494916.trips_2025.mar_2025`
UNION ALL
SELECT * FROM `cyclistic-bike-share-494916.trips_2025.apr_2025`
UNION ALL
SELECT * FROM `cyclistic-bike-share-494916.trips_2025.may_2025`
UNION ALL
SELECT * FROM `cyclistic-bike-share-494916.trips_2025.jun_2025`
UNION ALL
SELECT * FROM `cyclistic-bike-share-494916.trips_2025.july_2025`
UNION ALL
SELECT * FROM `cyclistic-bike-share-494916.trips_2025.aug_2025`
UNION ALL
SELECT * FROM `cyclistic-bike-share-494916.trips_2025.sep_2025`
UNION ALL
SELECT * FROM `cyclistic-bike-share-494916.trips_2025.oct_2025`
UNION ALL
SELECT * FROM `cyclistic-bike-share-494916.trips_2025.nov_2025`
UNION ALL
SELECT * FROM `cyclistic-bike-share-494916.trips_2025.dec_2025`;

--TO CHECK DATA INTEGRITY
--IDENTIFY DUPLICATES
SELECT COUNT(ride_id) as total_rides_count,COUNT(DISTINCT ride_id) as Original_rides_count, COUNT(ride_id) - COUNT(DISTINCT ride_id) as Duplicates_count FROM cyclistic-bike-share-494916.trips_2025.raw_data_2025;

--NULL ANALYSIS
SELECT 
  COUNTIF(ride_id IS NULL) AS null_ids,
  COUNTIF(rideable_type IS NULL) AS null_types,
  COUNTIF(started_at IS NULL) AS null_started_at,
  COUNTIF(start_station_name IS NULL) AS null_start_stations,
  COUNTIF(start_station_id IS NULL) AS null_start_station_ids,
  COUNTIF(ended_at IS NULL) AS null_ended_at,
  COUNTIF(end_station_name IS NULL) AS null_end_stations,
  COUNTIF(end_station_id IS NULL) AS null_end_station_ids,
  COUNTIF(member_casual IS NULL) AS null_user_type
FROM `cyclistic-bike-share-494916.trips_2025.raw_data_2025`;

--SQL Query to check if null start station names and ids & null end ststion names and ids are of same rideable type 
SELECT rideable_type, member_casual from `cyclistic-bike-share-494916.trips_2025.raw_data_2025` WHERE start_station_name IS NULL AND 
end_station_name IS NULL
GROUP BY rideable_type, member_casual;

--FETCH NULL RECORDS
SELECT * FROM `cyclistic-bike-share-494916.trips_2025.raw_data_2025` WHERE start_station_name IS NULL and start_station_id IS NULL;


---TO GET THE PERCENTAGE OF RIDES THAT ARE OF ELECTRIC RIDEABLE TYPE from raw_data_2025 (raw data for case study)
SELECT 
  member_casual,
  rideable_type,
  COUNT(*) AS total_rides,
  COUNTIF(start_station_name IS NULL) AS null_starts,
  ROUND(COUNTIF(start_station_name IS NULL) / COUNT(*) * 100, 2) AS percent_null
FROM `cyclistic-bike-share-494916.trips_2025.raw_data_2025` 
GROUP BY 1, 2;

--TO CHECK THE TOTAL RIDES THAT LASTED FOR MORE THAN 24 HOURS from raw_data_2025
SELECT 
    member_casual,
    COUNT(*) AS long_ride_count,
    MIN(TIMESTAMP_DIFF(ended_at, started_at, HOUR)) AS shortest_long_ride,
    MAX(TIMESTAMP_DIFF(ended_at, started_at, DAY)) AS longest_ride_days
FROM `cyclistic-bike-share-494916.trips_2025.raw_data_2025`
WHERE TIMESTAMP_DIFF(ended_at, started_at, HOUR) >= 24
GROUP BY 1;

--Checking records that has ended at - started at time difference >= 24   it is 5585 records
SELECT 
    member_casual,
    ride_id,ended_at, started_at
    --MIN(TIMESTAMP_DIFF(ended_at, started_at, HOUR)) AS shortest_long_ride,
    --MAX(TIMESTAMP_DIFF(ended_at, started_at, DAY)) AS longest_ride_days
FROM `cyclistic-bike-share-494916.trips_2025.raw_data_2025`
WHERE TIMESTAMP_DIFF(ended_at, started_at, HOUR) >= 24;

----TO CHECK THE AVG AND MAX DURATION FOR RIDERS
----Each ride should be atleast 1 min duration and not more than 23 hours duration from cleaned_data_2025
SELECT 
    member_casual,
    AVG(ride_length_m) AS avg_ride_duration,
    MAX(ride_length_m) AS max_ride_duration,
    COUNT(*) AS total_rides
FROM `cyclistic-bike-share-494916.trips_2025.cleaned_data_2025`
WHERE 
    TIMESTAMP_DIFF(ended_at, started_at, SECOND) > 60 
    AND TIMESTAMP_DIFF(ended_at, started_at, HOUR) < 24
GROUP BY 1;

-----TO CALCULATE RIDE LENGTH IN MINUTES
SELECT 
    ride_id,
    started_at,
    ended_at,
    -- 1. Calculate length in minutes
    TIMESTAMP_DIFF(ended_at, started_at, MINUTE) AS ride_length_m,
    FROM `cyclistic-bike-share-494916.trips_2025.raw_data_2025`;

--Create a table cleaned_data_2025 which has ride_length in minutes, >60 seconds and less than 24 hours
    CREATE OR REPLACE TABLE `cyclistic-bike-share-494916.trips_2025.cleaned_data_2025` AS
SELECT 
    *,
    -- Adding the new column here
    TIMESTAMP_DIFF(ended_at, started_at, MINUTE) AS ride_length_m
FROM `cyclistic-bike-share-494916.trips_2025.raw_data_2025`
WHERE 
    TIMESTAMP_DIFF(ended_at, started_at, SECOND) > 60 
    AND TIMESTAMP_DIFF(ended_at, started_at, HOUR) < 24;

--query to be executed later
SELECT 
    member_casual,
    AVG(ride_length_m) AS avg_ride_duration,
    MAX(ride_length_m) AS max_ride_duration,
    COUNT(*) AS total_rides
FROM `cyclistic-bike-share-494916.trips_2025.raw_data_2025`
WHERE 
    TIMESTAMP_DIFF(ended_at, started_at, SECOND) > 60 
    AND TIMESTAMP_DIFF(ended_at, started_at, HOUR) < 24
GROUP BY 1;

-- super clean table is created here
CREATE OR REPLACE TABLE `cyclistic-bike-share-494916.trips_2025.super_clean_data_2025` AS
SELECT 
    ride_id,
    rideable_type,
    started_at,
    ended_at,
    -- Handle the station names and IDs we discussed
    COALESCE(start_station_name, 'On-Street Lock') AS start_station_name,
    COALESCE(start_station_id, 'STATIONLESS') AS start_station_id,
    COALESCE(end_station_name, 'On-Street Lock') AS end_station_name,
    COALESCE(end_station_id, 'STATIONLESS') AS end_station_id,
    -- Calculate metrics
    TIMESTAMP_DIFF(ended_at, started_at, MINUTE) AS ride_length_m,
    EXTRACT(DAYOFWEEK FROM started_at) AS day_of_week,
    member_casual
FROM `cyclistic-bike-share-494916.trips_2025.raw_data_2025`
WHERE 
    -- The "Sweet Spot" for valid data:
    TIMESTAMP_DIFF(ended_at, started_at, SECOND) > 60 
    AND TIMESTAMP_DIFF(ended_at, started_at, HOUR) < 24
    AND ride_id IS NOT NULL;


    SELECT * FROM cyclistic-bike-share-494916.trips_2025.super_clean_data_2025 WHERE start_station_id = 'STATIONLESS';

   SELECT * FROM cyclistic-bike-share-494916.trips_2025.cleaned_data_2025;
   SELECT * FROM cyclistic-bike-share-494916.trips_2025.super_clean_data_2025;
   SELECT * FROM cyclistic-bike-share-494916.trips_2025.raw_data_2025;

   --Data Validation for super_clean_data_2025 : No duplicate values, no null values
   --Range Validation is done below
   SELECT 
  MIN(ride_length_m) AS min_length, 
  MAX(ride_length_m) AS max_length
FROM `cyclistic-bike-share-494916.trips_2025.super_clean_data_2025`;
-- Validation: min should be > 0, max should be < 1440
--Logic Check next up
SELECT *
FROM `cyclistic-bike-share-494916.trips_2025.super_clean_data_2025`
WHERE ended_at < started_at;
-- Validation: This is "Time Travel" data and should be removed.
--Typo Check
SELECT DISTINCT member_casual 
FROM `cyclistic-bike-share-494916.trips_2025.super_clean_data_2025`;
-- Validation: Should only show 'member' and 'casual'. 
-- If you see 'membr' or 'm', it is data entry error.

--Check For Empty Strings (blanks)
SELECT count(*) as blank_rows_count
FROM `cyclistic-bike-share-494916.trips_2025.super_clean_data_2025`
---WHERE start_station_name='';

WHERE '' IN (rideable_type,start_station_name,start_station_id,end_station_name,end_station_id,member_casual);

--MASTER CHECK (NULLs + Blanks + spaces) next up
SELECT 
    start_station_name, 
    COUNT(*) AS total_blanks
FROM `cyclistic-bike-share-494916.trips_2025.super_clean_data_2025`
WHERE start_station_name IS NULL 
   OR TRIM(start_station_name) = ''
GROUP BY 1;
   
--Started Analyzing data here
--Temporal Formatting : Format and get month
SELECT *, FORMAT_DATE('%B', started_at) AS month,FORMAT_DATE('%Y-%m', started_at) as Year_month FROM `cyclistic-bike-share-494916.trips_2025.super_clean_data_2025`;
--ROUND AVG.RIDE LENGTH TO 2 DECIMAL PLACES
SELECT 
    member_casual,
    ROUND(AVG(ride_length_m), 2) AS avg_ride_m,  -- 15.44 instead of 15.4439281
    CAST(COUNT(*) AS INT64) AS total_trips      -- Ensures no decimal points in counts
FROM `cyclistic-bike-share-494916.trips_2025.super_clean_data_2025`
GROUP BY 1;

--CATAGORICAL FORMATTING (Labeling Week days to words using CASE to display charts in Tableau/Power Bi correctly)
SELECT
    CASE 
        WHEN EXTRACT(DAYOFWEEK FROM started_at) = 1 THEN 'Sunday'
        WHEN EXTRACT(DAYOFWEEK FROM started_at) = 2 THEN 'Monday'
        WHEN EXTRACT(DAYOFWEEK FROM started_at) = 3 THEN 'Tuesday'
        WHEN EXTRACT(DAYOFWEEK FROM started_at) = 4 THEN 'Wednesday'
        WHEN EXTRACT(DAYOFWEEK FROM started_at) = 5 THEN 'Thursday'
        WHEN EXTRACT(DAYOFWEEK FROM started_at) = 6 THEN 'Friday'
        -- ... and so on
        ELSE 'Saturday' 
    END AS day_of_week_name,
    member_casual,
    COUNT(*) AS trip_count
FROM `cyclistic-bike-share-494916.trips_2025.super_clean_data_2025`
GROUP BY 1, 2
ORDER BY trip_count DESC;

--Check whether rideable_type has typo error
SELECT rideable_type, COUNT(rideable_type) AS total_count_rideable_type FROM cyclistic-bike-share-494916.trips_2025.super_clean_data_2025
GROUP BY rideable_type;

