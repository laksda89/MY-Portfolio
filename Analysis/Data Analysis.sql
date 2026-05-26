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



