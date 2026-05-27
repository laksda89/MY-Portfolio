# MY-Portfolio 

[Cyclistic Bike Share Case Study](https://laksda89.github.io/MY-Portfolio/)

<img width="1821" height="661" alt="image" src="https://github.com/user-attachments/assets/62322095-e91e-45c0-a695-17d0447ac41e" />


# Google Data Analytics Capstone Project

In this case study, I work for a fictional company, Cyclistic, along with some key team members.The Repository holds the analysis and visualization of actionable insights for the year 2025 that involves data from 12 months.The company has two kinds of customers casual and members. The goal is to identify the ride pattern between them and find out ways to turn the casual customers to members. In order to answer the business questions, I followed the steps of the data analysis process: Ask, Prepare, Process, Analyze, Share, and Act.The tools used are Google Bigquery for analysis in SQL and Tableau for data visualization.

## About the company

In 2016, Cyclistic launched a successful bike-share offering. Since then, the program has grown
to a fleet of 5,824 bicycles that are geotracked and locked into a network of 692 stations across
Chicago. The bikes can be unlocked from one station and returned to any other station in the
system anytime.
Until now, Cyclistic’s marketing strategy relied on building general awareness and appealing to
broad consumer segments. One approach that helped make these things possible was the
flexibility of its pricing plans: single-ride passes, full-day passes, and annual memberships.
Customers who purchase single-ride or full-day passes are referred to as casual riders.
Customers who purchase annual memberships are Cyclistic members.
Cyclistic’s finance analysts have concluded that annual members are much more profitable
than casual riders. Although the pricing flexibility helps Cyclistic attract more customers,
Moreno believes that maximizing the number of annual members will be key to future growth.
Rather than creating a marketing campaign that targets all-new customers, Moreno believes
there is a solid opportunity to convert casual riders into members. She notes that casual riders
are already aware of the Cyclistic program and have chosen Cyclistic for their mobility needs.
Moreno has set a clear goal: Design marketing strategies aimed at converting casual riders into
annual members. In order to do that, however, the team needs to better understand how
annual members and casual riders differ, why casual riders would buy a membership, and how
digital media could affect their marketing tactics. Moreno and her team are interested in
analyzing the Cyclistic historical bike trip data to identify trends.

I download the datasets for the year 2025 from the link below
[https://divvy-tripdata.s3.amazonaws.com/index.html](https://divvy-tripdata.s3.amazonaws.com/index.html)

## PHASE 1 : ASK

### GUIDING QUESTIONS

### 1.What are the business Tasks?

1.Identify how Casual riders and Annual members use Cyclistic bikes differently. From these insights, design a new marketing strategy to convert casual          riders into annual members.

2.Why would casual riders buy Cyclistic annual memberships?

3.How can Cyclistic use digital media to influence casual riders to become members?

### 2.Who the Audience are?

The Audience are our Stakeholders. Our Key Stakeholders are as follows.

• Lily Moreno: The director of marketing and my manager. Moreno is responsible for the development of campaigns and initiatives to promote the bike-share program. These may include email, social media, and other channels.

• Cyclistic marketing analytics team: A team of data analysts who are responsible for collecting, analyzing, and reporting data that helps guide Cyclistic marketing strategy. I joined this team six months ago and have been busy learning about Cyclistic’s mission and business goals — as well as how, as a junior data analyst, can help Cyclistic achieve them.

• Cyclistic executive team: The notoriously detail-oriented executive team will decide whether to approve the recommended marketing program.

### 3. Specify a clear statement of the business task.

The main purpose of the case study is to analyze how casual riders and members use Cyclistic bikes differently and uncover the trends and relationships hidden in the data. Also create a data visualization of the findings so as to create a strategy to influence casual riders to become Cyclistic members.Propose the ideas along with supportive data and visualization to the audience to understand, evaluate and act upon it.

## PHASE 2 : PREPARE

### GUIDING QUESTIONS

### 1.Where is the data located?

Data is located in the link provided below
[https://divvy-tripdata.s3.amazonaws.com/index.html](https://divvy-tripdata.s3.amazonaws.com/index.html)

### 2.How is the data organized?

The data is organized as zip files. I downloaded the zip files for the year 2025,12 folders for 12 months. Extracted the data from zip file and converted it to csv files for Analysis purpose.

### 3.Are there issues with bias or credibility in this data? Does your data ROCCC?

There is no bias in the data and it is credible data that follows ROCCC(Reliable,Original,Comprehensive,Current,Cited).The data is licensed with an agreement, the data is ensured privacy and secured by storing the credit card details safe, the data accessibility is restricted to the common bike ride details alone.

### 4.How are you addressing licensing, privacy, security, and accessibility?
 
[License-Agreement](https://divvybikes.com/data-license-agreement)

### 5.How did you verify the data’s integrity?

Data’s integrity is verified by running SQL queries as follows.

1.Checked for the same number of columns and same data type on the data from january 2025 – december 2025.

2.Created a master table and checked for missing values, duplicates, null values and null records.

3.Checked records for the time duration of rides >=24 hours <1 min as these will not be appropriate for our analysis as the bike would have been stolen if rides >= 24 and technical error if rides < 1 min.

### 6.How does it help you answer your question?

A clean new table of data is created for analysis with new parameters such as Ride length and Day of Week as additional data to help identify the ride pattern for casual and member customers. This insight will draw the difference between the ride patterns.

### 7.Are there any problems with the data?

The Start Station name and id as well as the End Station name and id had null values for 5585 records.Also some inconsistencies were found in the data, either corrected if possible or removed it if not appropriate for analysis. Preapred a clean data for Analysis using SQL.
            
## PHASE 3 - PROCESS

### GUIDING QUESTIONS

### 1.What tools are you choosing and why?

To Clean, Process and  Analyze the data, Bigquery SQL is used.

### 2.Have you ensured your data’s integrity?

Yes, Data integrity is ensured by identifying and resolving missing or null values, removing duplicate records and performing data validation to catch errors through targeted filtering.

### 3.What steps have you taken to ensure that your data is clean?

To ensure data is clean and ready for analysis, fulfilled the ROCCC standard followed by Removing duplicates, Handling missing data or null values, Standardize Formatting, Validate Data and fix Outliers, Verify and Document cleaning process.

### 4.How can you verify that your data is clean and ready to analyze?

Performed final inspection using specific metrics and tests as follows.

1.The Duplicate Re-Check.

2.Business Logic “Smoke Test” : The end time is more than the start time of the ride.

3.Schema and Data Type check.

### 5.Have you documented your cleaning process so you can review and share those results?

The Cleaning process is documented to review and share results.

## PHASE 4 - ANALYZE

### GUIDING QUESTIONS

### 1.How should you organize your data to perform analysis on it?

The data from csv files for 12 months of the year 2025 have been extracted to form a raw data table. This table has been checked for Data integrity, Data Validation and formed into a clean data master table for analysis.

### 2.Has your data been properly formatted?

Yes, Standardized Formatting.

### 3.What surprises did you discover in the data?

1.The end time of the ride started before the start time of the ride in some records. These were eliminated.

2.The Start Station name and id was null for some records. In the same way the End Station name and id was also null for some records.On deeper analysis, it is found that the rideable bike type was electric on both the above cases. This looks like a technical error.So updated the null records to Start Station name/End Station name – On-Street Lock and Start Station id/End Station id – Stationless.

### 4.What trends or relationships did you find in the data?

1.The Customers both casual and members prefer to ride Electric bike more than Classic bike as per the data of year 2025.

2.The total trip counts as well as Average Ride Length on weekdays and weekend separately for both casual and member customers.

3.Catagorize the rides according to 4 seasons (Spring, Summer, Autumn and Winter) and Average Ride Length to see behavior of casual and member customers.

4.Identify top 10 stations for casual and member customers respectively by performing JOINS.

5.Extract ride hour from the started at column of raw data to get insights about hourly ride pattern on weekdays and weekend for both casual and member customers.
                  
### See the Analysis folder for entire analysis process.
     
### 5.How will these insights help answer your business questions?

1.The Average ride Length of customers was high on all four seasons of the year 2025. This insight shows that casual customers ride leisurely and for a long time than Cyclistic member customers who ride bikes for commute to office on a daily basis, according to information provided earlier in case study. 

2.The casual customers ride on weekend in high numbers than weekdays. The peak time for casual customers on weekdays is after office hours and on weekend it is 8 am in the morning. The casual customers ride mostly near attraction places like parks,lakes,harbor,aquarium etc and some casual customers use bikes to commute to office on weekdays too. These casual customers are our target to propose annual membership.

## PHASE 5 - SHARE

## GUIDING QUESTIONS

### 1.What is your final conclusion based on your analysis?

1.The casual customers total rides count is less than members for the year 2025, but the Average Ride Length of casual customers is always higher irrespective of season than members. This shows that casual customers ride leisurely for long hours than members who ride for commute to office. Some casual customers use the bike for commute to office other than leisure ride. This is to watch out for.

2.The casual customers are more in number during weekend than weekdays with higher Average Ride Length.As Said earlier, some casual customers ride during weekdays to office. 

3.The casual customers are more around the attraction places like parks,lakes,harbor,aquarium etc.

4.The Top 10 casual stations are nearly 90% attraction spots while Top10 member stations are Corporate areas.

5.The Hourly ride pattern shows the casual customers are intersted to ride bikes more after 5 pm that is office hours during weekdays and from 8 am in the morning till 8 pm in the evening peaking at 3pm during weekend.

### 2.What tool is used for Data Visualization?

My data findings is presented as data visualization through Tableau.

For the full interactive analysis, please visit the live dashboard here.
               
[Click for Data Visualization - Tableau](https://public.tableau.com/app/profile/palaniappan.venkatachalam/viz/MyPortfolio_17790754816860/TotalRidesRideableTypeAvg_RideLengthOnSeason)

## PHASE 6 - ACT

### GUIDING QUESTIONS

### 1.How do annual members and casual riders use Cyclistic bikes differently?

1.Annual members count of rides is larger than casual customers for the year 2025. But the Average ride length of Casual customer is always more than members irrespective of season. 

2.Casual customers ride leisurely for long hours with high average ride length on weekend than weekdays while annual members use cyclistic bikes to commute to office.

3.Casual customers are seen more around tourist attraction places while annual members are seen more near corporate areas.

### 2.Why would casual riders buy Cyclistic annual memberships?

1.The frequent casual riders have to spend more money on bike rides. If they become annual members, they can definetely save money.

2.When casual riders opt for membership they can enjoy the deals and benefits provided for Cyclistic members.

### 3.How can Cyclistic use digital media to influence casual riders to become members?

1.Weekend Discounts and deals for annual membership could be introduced to make our casual customers into members. This can be telecasted in                     advertisements through you tube, news channels, televisions at stores,gym etc, stalls can be put on weekends near attraction places to influence casual customers.

2.Loyalty program, sweepstakes can be conducted to attract some casual customers, who rides to office on weekday to become Cyclistic members.

3.Referral program can be started so that current members can help add on more members by explaining the benefits they would enjoy through becoming a member. Doing this it is possible to get members from casual riders lot as well as public. 


## PROJECT STRUCTURE

[Data pre-processing and cleaning](https://github.com/laksda89/MY-Portfolio/blob/main/Analysis/Data%20pre-processing%20and%20cleaning.sql) : Queries to remove duplicates, handle null and missing values, perform data validation to catch errors through targeted filtering.

[Data Analysis](https://github.com/laksda89/MY-Portfolio/blob/main/Analysis/Data%20Analysis.sql) : Create columns for Season and Day of Week in master table, create temporary tables to find top10 stations, perform inner join to find total number of station visits for members and casual customers.


## Summary of Tableau Dashboard

[Tableau Public Profile](https://public.tableau.com/app/profile/palaniappan.venkatachalam/viz/MyPortfolio_17790754816860/TotalRidesRideableTypeAvg_RideLengthOnSeason)

### Dashboard 1 : Total Rides\Rideable Type\Avg.Ride Length On Season

1.**Electric bike usage > Classic Bike usage** by both members and casual customers.

2.The Average Ride Length is high for casual customers than members on all the 4 seasons of the year 2025.

3.**casual X2 more than members** define that Average Ride Length for casual customers is 2 times more than members irrespective of the trip counts.


### Dashboard 2 : Top10 Stations of Year 2025

Top10 member stations and Top10 casual customer stations depending on the Number of visits made by respective customers as both Start stations and End Stations. This data will be helpful in constructing a map.

### Dashboard 3 : Geospatial Analysis of Bike Share Stations

1.The map is constructed from Top10 stations data for both members and casual customers depending on the latitude and longitude column provided in the raw data from data source.

2.It can be seen that the member stations are inside city mostly Corporate areas while casual customer stations are tourist attraction spots near seas, parks etc.
This justifies the highest Average Ride Length(relaxing bike rides) by casual custoers on weekend near attraction places.

### Dashboard 4 : Average Ride Length and Hourly Ride Pattern

The Average Ride Length is always high for casual customers eventhough their trip counts are much lesser than members. Casual customers ride leisurely for a long time than members who commute to office for short time.

**Hourly Ride Pattern - Weekday**

1.Cyclistic member rides peak times are regular office hours, 8 am in the morning and 5 pm in the evening.

2.Casual customer rides can be seen during after office hours, after 5 pm for leisure rides.

**Hourly Ride Pattern - Weekend**

The rides peak gradually during the day for both members and casual customers with the maximum count at 3 pm.







                    






 
         


