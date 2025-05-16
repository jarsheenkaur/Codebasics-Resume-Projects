/*
Business Request - 3: City-Level Repeat Passenger Trip Frequency Report
Generate a report that shows the percentage distribution of repeat passengers by the number of trips they have taken in each city. Calculate the percentage of repeat passengers who took 2 trips, 3 trips, and so on, up to 10 trips.
Each column should represent a trip count category, displaying the percentage of repeat passengers who fall into that category out of the total repeat passengers for that city.
This report will help identify cities with high repeat trip frequency, which can indicate strong customer loyalty or frequent usage patterns.
	⚫ Fields: city_name, 2-Trips, 3-Trips, 4-Trips, 5-Trips, 6-Trips, 7-Trips, 8-Trips, 9-Trips, 10-Trips
*/

WITH 
	total_repeats AS
	(
		SELECT city_id, SUM(repeat_passenger_count) AS total_repeat_passenger
		FROM trips_db.dim_repeat_trip_distribution
		GROUP BY city_id
	),
    trip_count_repeats AS
    (
		SELECT city_id, trip_count, SUM(repeat_passenger_count) AS total_trip_count_repeat_passenger
		FROM trips_db.dim_repeat_trip_distribution
		GROUP BY city_id, trip_count
    ),
    trip_count_repeat_vs_total_repeat_contribution_pct AS
    (
		SELECT TC.city_id, TC.trip_count, TC.total_trip_count_repeat_passenger, TR.total_repeat_passenger,
               ROUND((TC.total_trip_count_repeat_passenger / TR.total_repeat_passenger)*100, 2) AS contri_pct
		FROM trip_count_repeats TC
        JOIN total_repeats TR
        ON TC.city_id = TR.city_id
	)
    SELECT C.city_name,
           MAX(CASE WHEN trip_count = "2-Trips" THEN contri_pct ELSE 0 END) AS "2-Trips %",
           MAX(CASE WHEN trip_count = "3-Trips" THEN contri_pct ELSE 0 END) AS "3-Trips %",
           MAX(CASE WHEN trip_count = "4-Trips" THEN contri_pct ELSE 0 END) AS "4-Trips %",
           MAX(CASE WHEN trip_count = "5-Trips" THEN contri_pct ELSE 0 END) AS "5-Trips %",
           MAX(CASE WHEN trip_count = "6-Trips" THEN contri_pct ELSE 0 END) AS "6-Trips %",
           MAX(CASE WHEN trip_count = "7-Trips" THEN contri_pct ELSE 0 END) AS "7-Trips %",
           MAX(CASE WHEN trip_count = "8-Trips" THEN contri_pct ELSE 0 END) AS "8-Trips %",
           MAX(CASE WHEN trip_count = "9-Trips" THEN contri_pct ELSE 0 END) AS "9-Trips %",
           MAX(CASE WHEN trip_count = "10-Trips" THEN contri_pct ELSE 0 END) AS "10-Trips %"		
	FROM trip_count_repeat_vs_total_repeat_contribution_pct RCP
    JOIN trips_db.dim_city C
    ON RCP.city_id = C.city_id
    GROUP BY C.city_name
    ORDER BY C.city_name;