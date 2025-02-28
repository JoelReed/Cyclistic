-- Select all our bike trip records for the entire year!

SELECT COUNT(*)
FROM [Cyclistic].[dbo].[annual-cyclistic-tripdata];

 -- Duplicate trip_id

SELECT trip_id,
       COUNT(*) AS DuplicateCount
FROM [Cyclistic].[dbo].[annual-cyclistic-tripdata]
GROUP BY trip_id HAVING COUNT(*) > 1;

 -- Add a month_of_year column to our data

ALTER TABLE [Cyclistic].[dbo].[annual-cyclistic-tripdata] ADD month_of_year NVARCHAR(20);


UPDATE [Cyclistic].[dbo].[annual-cyclistic-tripdata]
SET month_of_year = DATENAME(MONTH, start_time);

 -- Add an hour_of_day column to our data

ALTER TABLE [Cyclistic].[dbo].[annual-cyclistic-tripdata] ADD hour_of_day INT;


UPDATE [Cyclistic].[dbo].[annual-cyclistic-tripdata]
SET hour_of_day = DATEPART(HOUR, start_time);

 -- Get the total number of rides split by each customer type and also get a percentage breakdown

SELECT user_type,
       COUNT(*) AS customer_count,
       ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS customer_count_percentage
FROM [Cyclistic].[dbo].[annual-cyclistic-tripdata]
GROUP BY user_type
ORDER BY user_type;

 -- Get the total number of rides by bike type for each customer type and also get a percentage breakdown

SELECT user_type,
       bike_type,
       COUNT(*) AS bike_count,
       ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS bike_count_percentage
FROM [Cyclistic].[dbo].[annual-cyclistic-tripdata]
GROUP BY user_type,
         bike_type
ORDER BY user_type,
         bike_type;

 -- Find the mean (average) length of rides across the year, including all customer types

SELECT CAST(DATEADD(MINUTE, AVG(CAST(DATEDIFF(MINUTE, '00:00:00', ride_length) AS FLOAT)), '00:00:00') AS TIME) AS average_ride_time
FROM [Cyclistic].[dbo].[annual-cyclistic-tripdata];

 -- Find the mean (average) length of rides across the year for Casual riders and Cyclistic Members

SELECT user_type,
       CAST(DATEADD(MINUTE, AVG(CAST(DATEDIFF(MINUTE, '00:00:00', ride_length) AS FLOAT)), '00:00:00') AS TIME) AS average_ride_time
FROM [Cyclistic].[dbo].[annual-cyclistic-tripdata]
GROUP BY user_type;

 -- Find the most popular days of the week that rides took place for both customer demographics

SELECT user_type,
       day_of_week,
       COUNT(*) AS rides_by_day_of_week,
       ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS weekday_count_percentage
FROM [Cyclistic].[dbo].[annual-cyclistic-tripdata]
GROUP BY user_type,
         day_of_week
ORDER BY user_type,
         rides_by_day_of_week DESC;

 -- Find the most popular time of the day that rides took place for both customer demographics

SELECT time_of_day,
       COUNT(*) AS rides_by_time_of_day,
       ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS rides_by_time_of_day_percentage
FROM [Cyclistic].[dbo].[annual-cyclistic-tripdata]
GROUP BY time_of_day
ORDER BY rides_by_time_of_day DESC;

 -- Find the most popular time of the day that rides took place for the different customer demographics

SELECT user_type,
       time_of_day,
       COUNT(*) AS rides_by_time_of_day,
       ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS rides_by_time_of_day_percentage
FROM [Cyclistic].[dbo].[annual-cyclistic-tripdata]
GROUP BY user_type,
         time_of_day
ORDER BY user_type,
         rides_by_time_of_day DESC;

 -- Find the most popular season that rides took place for both customer demographics

SELECT season_of_year,
       COUNT(*) AS rides_by_season_of_year,
       ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS rides_by_season_of_year_percentage
FROM [Cyclistic].[dbo].[annual-cyclistic-tripdata]
GROUP BY season_of_year
ORDER BY rides_by_season_of_year DESC;

 -- Find the most popular season that rides took place for the different customer demographics

SELECT user_type,
       season_of_year,
       COUNT(*) AS rides_by_season_of_year,
       ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS rides_by_season_of_year_percentage
FROM [Cyclistic].[dbo].[annual-cyclistic-tripdata]
GROUP BY user_type,
         season_of_year
ORDER BY user_type,
         rides_by_season_of_year DESC;

 -- Find the most popular months that rides took place for both customer demographics

SELECT month_of_year,
       COUNT(*) AS rides_by_month_of_year,
       ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS rides_by_month_of_year_percentage
FROM [Cyclistic].[dbo].[annual-cyclistic-tripdata]
GROUP BY month_of_year
ORDER BY rides_by_month_of_year DESC;

 -- Find the most popular months that rides took place for both customer demographics

SELECT user_type,
       month_of_year,
       COUNT(*) AS rides_by_month_of_year,
       ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS rides_by_month_of_year_percentage
FROM [Cyclistic].[dbo].[annual-cyclistic-tripdata]
GROUP BY user_type,
         month_of_year
ORDER BY user_type,
         rides_by_month_of_year DESC;

 -- Find the busiest hour of the day where bike hires were made by all customers

SELECT hour_of_day,
       COUNT(*) AS rides_by_hour_of_day,
       ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS rides_by_hour_of_day_percentage
FROM [Cyclistic].[dbo].[annual-cyclistic-tripdata]
GROUP BY hour_of_day
ORDER BY rides_by_hour_of_day DESC;

 -- Find the busiest hour of the day where bike hires were made by different customers

SELECT user_type,
       hour_of_day,
       COUNT(*) AS rides_by_hour_of_day,
       ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS rides_by_hour_of_day_percentage
FROM [Cyclistic].[dbo].[annual-cyclistic-tripdata]
GROUP BY user_type,
         hour_of_day
ORDER BY user_type,
         rides_by_hour_of_day DESC;

 -- Find the Top 10 busiest hiring stations (start) across all customers

SELECT TOP 10 start_station_name,
              COUNT(*) AS rides_by_station_name,
              ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS rides_by_station_name_percentage
FROM [Cyclistic].[dbo].[annual-cyclistic-tripdata]
GROUP BY start_station_name
ORDER BY rides_by_station_name DESC;

 -- Find the Top 10 busiest hiring stations (end) across all customers

SELECT TOP 10 end_station_name,
              COUNT(*) AS rides_by_station_name,
              ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS rides_by_station_name_percentage
FROM [Cyclistic].[dbo].[annual-cyclistic-tripdata]
GROUP BY end_station_name
ORDER BY rides_by_station_name DESC;

 -- Find the Top 10 busiest hiring stations (start) across different customers

SELECT user_type,
       start_station_name,
       COUNT(*) AS rides_by_station_name,
       ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS rides_by_station_name_percentage
FROM [Cyclistic].[dbo].[annual-cyclistic-tripdata]
GROUP BY user_type,
         start_station_name
ORDER BY user_type,
         rides_by_station_name DESC;

 -- Find the Top 10 busiest hiring stations (start) across different customers

SELECT user_type,
       end_station_name,
       COUNT(*) AS rides_by_station_name,
       ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS rides_by_station_name_percentage
FROM [Cyclistic].[dbo].[annual-cyclistic-tripdata]
GROUP BY user_type,
         end_station_name
ORDER BY user_type,
         rides_by_station_name DESC;

