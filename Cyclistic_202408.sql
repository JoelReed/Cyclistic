-- Select all our bike trip records for Aug 2024
  
  SELECT *
  FROM [Cyclistic].[dbo].[202408-cyclistic-tripdata];

  -- Check for duplicates

  SELECT ride_id, COUNT(*) AS DuplicateCount
   FROM [Cyclistic].[dbo].[202408-cyclistic-tripdata]
   GROUP BY ride_id
   HAVING COUNT(*) > 1;

  --  Update our columns with our preferred naming conventions
  
  sp_rename '[Cyclistic].[dbo].[202408-cyclistic-tripdata].ride_id', 'trip_id', 'COLUMN';
  sp_rename '[Cyclistic].[dbo].[202408-cyclistic-tripdata].rideable_type', 'bike_type', 'COLUMN';
  sp_rename '[Cyclistic].[dbo].[202408-cyclistic-tripdata].started_at', 'start_time', 'COLUMN';
  sp_rename '[Cyclistic].[dbo].[202408-cyclistic-tripdata].ended_at', 'end_time', 'COLUMN';
  sp_rename '[Cyclistic].[dbo].[202408-cyclistic-tripdata].member_casual', 'user_type', 'COLUMN';

   -- Count every row where we have a null value within the station information

  SELECT COUNT(*)

  FROM [Cyclistic].[dbo].[202408-cyclistic-tripdata]

  WHERE (start_time is NULL) OR (end_time is NULL) OR (start_station_name is NULL) OR (end_station_name is NULL) OR (start_station_id is NULL) OR (end_station_id is NULL) OR (start_lat is NULL) OR (start_lng is NULL) OR (end_lat is NULL) OR (end_lng is NULL);

   -- Delete and remove the null rows from our dataset
  
  DELETE FROM [Cyclistic].[dbo].[202408-cyclistic-tripdata]

  WHERE (start_time is NULL) OR (end_time is NULL) OR (start_station_name is NULL) OR (end_station_name is NULL) OR (start_station_id is NULL) OR (end_station_id is NULL) OR (start_lat is NULL) OR (start_lng is NULL) OR (end_lat is NULL) OR (end_lng is NULL);

  -- Add two new columns, as per our stakeholder instruction

  -- Add a ride length column as TIME

  ALTER TABLE [Cyclistic].[dbo].[202408-cyclistic-tripdata]
  ADD ride_length TIME;

   -- Add a day of the week column. Our days of the week will be presented as strings, so we'll use NVARCHAR

  ALTER TABLE [Cyclistic].[dbo].[202408-cyclistic-tripdata]
  ADD day_of_week NVARCHAR(20);

   -- Calculate the ride_length for each journey and populate the newly created column

  UPDATE [Cyclistic].[dbo].[202408-cyclistic-tripdata]
  SET ride_length = CONVERT(TIME, DATEADD(SECOND, DATEDIFF(SECOND, start_time, end_time), '00:00:00'));

  -- Look for any negative duration journeys in our data, i.e., end time is less than the start time

  SELECT * 

  FROM [Cyclistic].[dbo].[202408-cyclistic-tripdata]

  WHERE end_time < start_time;

  -- Delete those negative journeys from the table as we can't use them. Number of rows are now 184,735

  DELETE FROM [Cyclistic].[dbo].[202408-cyclistic-tripdata]

  WHERE end_time < start_time;

 -- Populate our day_of_the_week column

  UPDATE [Cyclistic].[dbo].[202408-cyclistic-tripdata]
  SET day_of_week = DATENAME(WEEKDAY, start_time);

  -- Create two further custom columns to show the time of day and season of year.

  ALTER TABLE [Cyclistic].[dbo].[202408-cyclistic-tripdata]
  ADD time_of_day NVARCHAR(20);

  ALTER TABLE [Cyclistic].[dbo].[202408-cyclistic-tripdata]
  ADD season_of_year NVARCHAR(20);

   -- Populate our time_of_day column using CASE (IF/ELSE)

  UPDATE [Cyclistic].[dbo].[202408-cyclistic-tripdata]
    SET time_of_day = 
      CASE 
        WHEN DATEPART(HOUR, start_time) BETWEEN 6 AND 11 THEN 'Morning'
        WHEN DATEPART(HOUR, start_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        WHEN DATEPART(HOUR, start_time) BETWEEN 18 AND 21 THEN 'Evening'
        ELSE 'Night' -- Covers 22:00 - 05:59
    END;

	-- Populate our season_of_year column using CASE (IF/ELSE)

	UPDATE [Cyclistic].[dbo].[202408-cyclistic-tripdata]
      SET season_of_year =
       CASE 
          WHEN MONTH(start_time) IN (3, 4, 5) THEN 'Spring'
          WHEN MONTH(start_time) IN (6, 7, 8) THEN 'Summer'
          WHEN MONTH(start_time) IN (9, 10, 11) THEN 'Fall'
          WHEN MONTH(start_time) IN (12, 1, 2) THEN 'Winter'
      END;

	   -- Trim our NVARCHAR columns to tidy these all up

	  UPDATE [Cyclistic].[dbo].[202408-cyclistic-tripdata]
       SET start_station_name = TRIM(start_station_name);

	  UPDATE [Cyclistic].[dbo].[202408-cyclistic-tripdata]
       SET end_station_name = TRIM(end_station_name);

	  UPDATE [Cyclistic].[dbo].[202408-cyclistic-tripdata]
       SET start_station_id = TRIM(start_station_id);

	  UPDATE [Cyclistic].[dbo].[202408-cyclistic-tripdata]
       SET end_station_id = TRIM(end_station_id);

	   -- Check for issues with our bike_type column

	    SELECT *

	    FROM [Cyclistic].[dbo].[202408-cyclistic-tripdata]

	    WHERE (bike_type <> 'classic_bike') AND (bike_type <> 'electric_bike') AND (bike_type <> 'electric_scooter');

	-- Check for issues with our user_type column

	    SELECT *

	    FROM [Cyclistic].[dbo].[202408-cyclistic-tripdata]

	    WHERE (user_type <> 'casual') AND (user_type <> 'member');

	   -- Find really long rides (over 3 hours)

	   SELECT *

	   FROM [Cyclistic].[dbo].[202408-cyclistic-tripdata]

	   WHERE ride_length > '03:00:00'
	   
	   ORDER BY ride_length DESC;

	  -- Find really short rides (under 60 seconds) where the start and end station is the same, i.e., 

	   SELECT *

	   FROM [Cyclistic].[dbo].[202408-cyclistic-tripdata]

	   WHERE (ride_length < '00:01:00') AND (start_station_name = end_station_name)
	   
	   ORDER BY ride_length ASC;

	  -- Find really short rides (under 60 seconds)
	   
	   SELECT *

	   FROM [Cyclistic].[dbo].[202408-cyclistic-tripdata]

	   WHERE (ride_length < '00:01:00')
	   
	   ORDER BY ride_length DESC;

	   -- Delete short rides

	   DELETE FROM [Cyclistic].[dbo].[202408-cyclistic-tripdata]

	   WHERE (ride_length < '00:01:00');
