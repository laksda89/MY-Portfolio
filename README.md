# MY-Portfolio [Cyclistic Bike Share Case Study](https://laksda89.github.io/MY-Portfolio/)
# Google Data Analytics Capstone Project
In this case study, I work for a fictional company, Cyclistic, along with some key team members.The Repository holds the analysis and visualization of actionable insights for the year 2025 that involves data from 12 months.The company has two kinds of customers casual and members. The goal is to identify the ride pattern between them and find out ways to turn the casual customers to members. In order to answer the business questions, I followed the steps of the data analysis process: Ask, Prepare, Process, Analyze, Share, and Act.The tools used are Google Bigquery for analysis in SQL and Tableau for data visualization.

# About the company
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

# PHASE 1 : ASK
## 1.What are the business Tasks?
        1.Identify how Casual riders and Annual members use Cyclistic bikes differently. From these insights, design a new marketing 
          strategy to convert casual              riders into annual members.
        2.Why would casual riders buy Cyclistic annual memberships?
        3.How can Cyclistic use digital media to influence casual riders to become members?

## 2.Who the Audience are?
        The Audience are our Stakeholders. Our Key Stakeholders are as follows.
        • Lily Moreno: The director of marketing and my manager. Moreno is responsible for the development of campaigns and initiatives 
          to promote the bike-share program. These may include email, social media, and other channels.

        • Cyclistic marketing analytics team: A team of data analysts who are responsible for collecting, analyzing, and reporting data 
          that helps guide Cyclistic marketing strategy. I joined this team six months ago and have been busy learning about 
          Cyclistic’s mission and business goals — as well as how, as a junior data analyst, can help Cyclistic achieve them.

        • Cyclistic executive team: The notoriously detail-oriented executive team will decide whether to approve the recommended 
          marketing program.

## 3. Specify a clear statement of the business task
           The main purpose of the case study is to analyze how casual riders and members use Cyclistic bikes differently and uncover 
           the trends and relationships hidden in the data. Also create a data visualization of the findings so as to create a strategy 
           to influence casual riders to become Cyclistic members.Propose the ideas along with supportive data and visualization to 
           the audience to understand, evaluate and act upon it.

# PHASE 2 : PREPARE
# GUIDING QUESTIONS
## 1.Where is the data located?
            Data is located in the link provided [https://divvy-tripdata.s3.amazonaws.com/index.html](https://divvy-tripdata.s3.amazonaws.com/index.html)

## 2.How is the data organized?
            The data is organized as zip files. I downloaded the zip files for the year 2025,12 folders for 12 months. Extracted the data 
            from zip file and converted it to csv files for Analysis purpose.

## 3.Are there issues with bias or credibility in this data? Does your data ROCCC?

            There is no bias in the data and it is credible data that follows ROCCC(Reliable,Original,Comprehensive,Current,Cited).The data 
            is licensed with an agreement, the data is ensured privacy and secured by storing the credit card details safe, the data 
            accessibility is restricted to the common bike ride details alone.

## 4.How are you addressing licensing, privacy, security, and accessibility?
            License : [https://divvybikes.com/data-license-agreement](https://divvybikes.com/data-license-agreement)

## 5.How did you verify the data’s integrity?
            Data’s integrity is verified by running SQL queries as follows.
            1.Checked for the same number of columns and same data type on the data from january 2025 – december 2025.
            2.Created a master table and checked for missing values, duplicates, null values and null records.
            3.Checked records for the time duration of rides >=24 hours <1 min as these will not be appropriate for our analysis 
              as the bike would have been stolen if rides >= 24 and technical error if rides < 1 min.

## 6.How does it help you answer your question?
            A clean new table of data is created for analysis with new parameters such as Ride length and Day of Week as additional data to help 
            identify the ride pattern for casual and member customers. This insight will draw the difference between the ride patterns.

## 7.Are there any problems with the data?
            The Start Station name and id as well as the End Station name and id had null values for 5585 records.Also some inconsistencies were 
            found in the data, either corrected if possible or removed it if not appropriate for analysis. Preapred a clean data for Analysis 
            using SQL.
            
# PHASE 3 - PROCESS
# GUIDING QUESTIONS
## 1.What tools are you choosing and why?
             To Clean, Process and  Analyze the data, Bigquery SQL is used.

## 2.Have you ensured your data’s integrity?
              Yes, Data integrity is ensured by identifying and resolving missing or null values, removing duplicate records 
              and performing data validation to catch errors through targeted filtering.

## 3.What steps have you taken to ensure that your data is clean?
                To ensure data is clean and ready for analysis, fulfilled the ROCCC standard followed by Removing duplicates, 
                Handling missing data or null values, Standardize Formatting, Validate Data and fix Outliers, Verify and Document 
                Cleaning process.

## 4.How can you verify that your data is clean and ready to analyze?
                Performed final inspection using specific metrics and tests as follows.
                1.The Duplicate Re-Check.
                2.Business Logic “Smoke Test” : The end time is more than the start time of the ride.
                3.Schema and Data Type check.

## 5.Have you documented your cleaning process so you can review and share those results?
                The Cleaning process is documented to review and share results.


 
         


