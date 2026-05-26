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

--Analyze Trends and Relationship in the data
--See the total trips count during weekdays in the below query, casual and member seperately along with ride length
SELECT member_casual,COUNT(ride_id) as total_trips_count, ROUND(AVG(ride_length_m),2) as Avg_ride_length FROM cyclistic-bike-share-494916.trips_2025.super_clean_data_2025
WHERE Day_of_week IN (2,3,4,5,6)
GROUP BY member_casual
order by total_trips_count DESC;

--Weekend scenario in the below query
SELECT member_casual,COUNT(ride_id) as total_trips_count,ROUND(AVG(ride_length_m),2) as Avg_ride_length FROM cyclistic-bike-share-494916.trips_2025.super_clean_data_2025
WHERE Day_of_week IN (7,1)
GROUP BY member_casual
order by total_trips_count desc;
--During Weekdays Trip count of members are more than casual riders
--Avg.Ride length of casual riders is more than members

--During Weekend Trip count of members are again more than casual riders by ten thousand
--Avg.ride length of casual riders are agsin more than member riders
--Always the Avg.ride length of casual riders is high on both Weekdays and Weekend

--CASE Statement to find the weekdays and weekend pattern 
SELECT 
    member_casual,
    CASE 
        WHEN Day_of_week IN (1, 7) THEN 'Weekend' 
        ELSE 'Weekday' 
    END AS part_of_week,
    COUNT(ride_id) AS total_trips_count,
    ROUND(AVG(ride_length_m), 2) AS Avg_ride_length
FROM `cyclistic-bike-share-494916.trips_2025.super_clean_data_2025`
GROUP BY 1, 2
ORDER BY 1, 2;


-----To Identify Trend relationship on the trip counts between member_casual over the seasons for the entire year 2025
-----Alter table with month and year_month as String datatype
ALTER TABLE `cyclistic-bike-share-494916.trips_2025.super_clean_data_2025`
ADD COLUMN month String,
ADD COLUMN year_month String;

-----Now Update the table to fill in values for above mentioned columns
UPDATE `cyclistic-bike-share-494916.trips_2025.super_clean_data_2025`
--SET month = FORMAT_DATE('%B',started_at) WHERE month IS NULL;
SET year_month = FORMAT_DATE('%y -%m', started_at) WHERE year_month IS NULL;

SELECT * FROM `cyclistic-bike-share-494916.trips_2025.super_clean_data_2025`;


---- USE CASE STATEMENT TO CATAGORIZE SEASON TO IDENTIFY TRENDS AND RELATIONSHIP
SELECT member_casual, COUNT(ride_id) as Total_rides, ROUND(AVG(ride_length_m))as Avg_ride_length,
  CASE 
     WHEN month IN('January','February','March') THEN 'Winter'
     WHEN month IN('April','May','June') THEN 'Spring'
     WHEN month IN('July','August','September') THEN 'Summer'
     ELSE 'Autumn'
     END AS Season
FROM `cyclistic-bike-share-494916.trips_2025.super_clean_data_2025`
GROUP BY member_casual,month
ORDER BY month;

SELECT member_casual, 
  CASE 
     WHEN month IN('December','January','February') THEN 'Winter'
     WHEN month IN('March','April','May') THEN 'Spring'
     WHEN month IN('June','July','August') THEN 'Summer'
     ELSE 'Autumn'
     END AS Season,
     COUNT(ride_id) as Total_rides, ROUND(AVG(ride_length_m))as Avg_ride_length,
FROM `cyclistic-bike-share-494916.trips_2025.super_clean_data_2025`
GROUP BY member_casual,Season
ORDER BY Season;

---RENAME year_month Column to Season
ALTER TABLE `cyclistic-bike-share-494916.trips_2025.super_clean_data_2025`
RENAME COLUMN year_month to Season;

---UPDATE SUPER_CLEAN_DATA_2025 Table set column year_month to seasons
UPDATE `cyclistic-bike-share-494916.trips_2025.super_clean_data_2025`
   SET Season = CASE
   WHEN TRIM(month) IN ('December','January','February') THEN 'Winter'
   WHEN TRIM(month) IN ('March','April','May') THEN 'Spring'
   WHEN TRIM(month) IN ('June','July','August') THEN 'Summer'
   WHEN TRIM(month) IN ('September','October','November') THEN 'Autumn'
   ELSE 'Unknown'
   END
   WHERE month IS NOT NULL;

----"Audit Query" to make sure no rows ended up as 'Unknown' accidentally
SELECT month, Season, COUNT(*) as count
FROM `cyclistic-bike-share-494916.trips_2025.super_clean_data_2025`
GROUP BY 1, 2
ORDER BY Season;

SELECT AVG(ride_length_m) as Avg_ride_length, member_casual, Season
FROM `cyclistic-bike-share-494916.trips_2025.super_clean_data_2025`
GROUP BY member_casual, Season;

SELECT *  FROM `cyclistic-bike-share-494916.trips_2025.super_clean_data_2025`
WHERE rideable_type NOT IN ('classic_bike');

---Top 10 Start_station_name for members
SELECT COUNT(start_station_name) as Count_start_station_name, start_station_name, member_casual
FROM `cyclistic-bike-share-494916.trips_2025.super_clean_data_2025`
WHERE start_station_name != 'On-Street Lock' and member_casual != 'casual'
GROUP BY start_station_name,member_casual
ORDER BY count_start_station_name desc
LIMIT 10;

SELECT * FROM Top_10_start_station_members;

---Creating Temp Table for member_start_station
CREATE OR REPLACE TABLE `cyclistic-bike-share-494916.trips_2025.member_start_station` as 
SELECT COUNT(start_station_name) as Count_start_station_name, start_station_name, member_casual
FROM `cyclistic-bike-share-494916.trips_2025.super_clean_data_2025`
WHERE start_station_name != 'On-Street Lock' and member_casual != 'casual'
GROUP BY start_station_name,member_casual
ORDER BY count_start_station_name desc
LIMIT 10;

SELECT * FROM `cyclistic-bike-share-494916.trips_2025.member_start_station`;

---Top 10 Start_station_name for casual
SELECT COUNT(start_station_name) as Count_start_station_name, start_station_name, member_casual
FROM `cyclistic-bike-share-494916.trips_2025.super_clean_data_2025` 
WHERE start_station_name != 'On-Street Lock' and member_casual != 'member'
GROUP BY start_station_name,member_casual
ORDER BY count_start_station_name desc
LIMIT 10;

---Creating Temp Table for casual_start_station
CREATE OR REPLACE TABLE `cyclistic-bike-share-494916.trips_2025.casual_start_station` as 
SELECT COUNT(start_station_name) as Count_start_station_name, start_station_name, member_casual
FROM `cyclistic-bike-share-494916.trips_2025.super_clean_data_2025`
WHERE start_station_name != 'On-Street Lock' and member_casual != 'member'
GROUP BY start_station_name,member_casual
ORDER BY count_start_station_name desc
LIMIT 11;

SELECT * FROM `cyclistic-bike-share-494916.trips_2025.casual_start_station`;

---Top 10 End_station_name for members
SELECT COUNT(end_station_name) as Count_end_station_name, end_station_name, member_casual
FROM `cyclistic-bike-share-494916.trips_2025.super_clean_data_2025` 
WHERE end_station_name != 'On-Street Lock' and member_casual != 'casual'
GROUP BY end_station_name,member_casual
ORDER BY count_end_station_name desc
LIMIT 10;

---Creating Temp Table for member_end_station
CREATE OR REPLACE TABLE `cyclistic-bike-share-494916.trips_2025.member_end_station` as 
SELECT COUNT(end_station_name) as Count_end_station_name, end_station_name, member_casual
FROM `cyclistic-bike-share-494916.trips_2025.super_clean_data_2025`
WHERE end_station_name != 'On-Street Lock' and member_casual != 'casual'
GROUP BY end_station_name,member_casual
ORDER BY count_end_station_name desc
LIMIT 10;

SELECT * FROM `cyclistic-bike-share-494916.trips_2025.member_end_station`;

---Top 10 End_station_name for casual
SELECT COUNT(end_station_name) as Count_end_station_name, end_station_name, member_casual
FROM `cyclistic-bike-share-494916.trips_2025.super_clean_data_2025`  
WHERE end_station_name != 'On-Street Lock' and member_casual != 'member'
GROUP BY end_station_name,member_casual
ORDER BY count_end_station_name desc
LIMIT 10;

---Creating Temp Table for casual_end_station
CREATE OR REPLACE TABLE `cyclistic-bike-share-494916.trips_2025.casual_end_station` as 
SELECT COUNT(end_station_name) as Count_end_station_name, end_station_name, member_casual
FROM `cyclistic-bike-share-494916.trips_2025.super_clean_data_2025`
WHERE end_station_name != 'On-Street Lock' and member_casual != 'member'
GROUP BY end_station_name,member_casual
ORDER BY count_end_station_name desc
LIMIT 11;

SELECT * FROM `cyclistic-bike-share-494916.trips_2025.casual_end_station`;

---We have created 2 tables one for member_start_station and other for member_end_station
---similarly 2 tables one for casual_start_station and other for casual_end_station
---Now perform inner join to find the total number of visits for top 10 stations by joining member_start_station and other for member_end_station

CREATE OR REPLACE TABLE `cyclistic-bike-share-494916.trips_2025.member_top10_stations` as 
SELECT SUM(m.Count_start_station_name + e.Count_end_station_name) as member_total_visits_to_station,m.start_station_name, e.end_station_name,
FROM `cyclistic-bike-share-494916.trips_2025.member_start_station` AS m
INNER JOIN 
`cyclistic-bike-share-494916.trips_2025.member_end_station` as e ON m.start_station_name = e.end_station_name
GROUP BY m.start_station_name, e.end_station_name;

SELECT * FROM `cyclistic-bike-share-494916.trips_2025.member_top10_stations`;


---Now perform inner join to find the total number of visits for top 10 stations by joining casual_start_station and other for casual_end_station
CREATE OR REPLACE TABLE `cyclistic-bike-share-494916.trips_2025.casual_top10_stations` as
SELECT SUM(c.Count_start_station_name + e.Count_end_station_name) as casual_total_visits_to_station,c.start_station_name, e.end_station_name,
FROM `cyclistic-bike-share-494916.trips_2025.casual_start_station` AS c
INNER JOIN 
`cyclistic-bike-share-494916.trips_2025.casual_end_station` as e ON c.start_station_name = e.end_station_name 
OR c.start_station_name = 'Michigan Ave & 8th Street'
GROUP BY c.start_station_name, e.end_station_name;


SELECT * FROM `cyclistic-bike-share-494916.trips_2025.casual_top10_stations`;

---Extracting ride_hour for members to see at what time of the day the Cyclistic members ride more during Week Days
SELECT 
    EXTRACT(HOUR FROM started_at) AS ride_hour,
    COUNT(*) AS total_rides
FROM `cyclistic-bike-share-494916.trips_2025.super_clean_data_2025`
WHERE member_casual = 'member' --and  day_of_week NOT IN (1,7)
---To check during Weekend
and day_of_week IN (1,7)
GROUP BY ride_hour
ORDER BY total_rides DESC;

SELECT * FROM `cyclistic-bike-share-494916.trips_2025.Top10_member_stations_lat_lng`;
SELECT * FROM `cyclistic-bike-share-494916.trips_2025.Top10_casual_stations_lat_lng`;
SELECT * FROM `cyclistic-bike-share-494916.trips_2025.Top10_member_casual_lat_lng_stations_union`;

----Creating a Table with latitude and longitude columns for Top10_member_casual_lat_lng_stations to display map visualization using Tableau
CREATE OR REPLACE TABLE `cyclistic-bike-share-494916.trips_2025.Top10_member_casual_lat_lng_stations_union` as
SELECT 
    start_station_name,
    CAST(start_lat AS FLOAT64) AS latitude,
    CAST(start_lng AS FLOAT64) AS longitude,
    CAST(Total_visits_to_station AS INT64) AS count_of_visits,
    'member' AS user_type
FROM `cyclistic-bike-share-494916.trips_2025.Top10_member_stations_lat_lng`

UNION ALL

SELECT 
    start_station_name,
    CAST(start_lat AS FLOAT64) AS latitude,
    CAST(start_lng AS FLOAT64) AS longitude,
    CAST(Total_visits_to_station AS INT64) AS count_of_visits,
    'casual' AS user_type
FROM `cyclistic-bike-share-494916.trips_2025.Top10_casual_stations_lat_lng`;

------Extracting ride_hour for casual riders to see at what time of the day riders prefer trips during Week Days and Week End
CREATE OR REPLACE TABLE `cyclistic-bike-share-494916.trips_2025.hourly_usage_summary` as
SELECT 
    EXTRACT(HOUR FROM started_at) AS ride_hour,
    COUNT(*) AS total_rides,
    day_of_week,member_casual,
CASE
WHEN day_of_week IN (1,7) THEN 'Weekend'
WHEN day_of_week IN (2,3,4,5,6) THEN 'Weekday'
ELSE 'Error'
END AS day_type
FROM `cyclistic-bike-share-494916.trips_2025.super_clean_data_2025`
GROUP BY 1,3,4,5 ----ride_hour, day_of_week,day_type,member_casual
ORDER BY 1,3; ----ride_hour,day_of_week;

SELECT * FROM `cyclistic-bike-share-494916.trips_2025.hourly_usage_summary`;
