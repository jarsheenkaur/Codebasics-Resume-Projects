/*
Business Request - 2: Monthly City-Level Trips Target Performance Report
Generate a report that evaluates the target performance for trips at the monthly and city level. For each city and month, compare the actual total trips with the target trips and categorise the performance as follows:
	⚫ If actual trips are greater than target trips, mark it as "Above Target".
	⚫ If actual trips are less than or equal to target trips, mark it as "Below Target".
Additionally, calculate the % difference between actual and target trips to quantify the performance gap.
		Fields:
			⚫ city_name
			⚫ month_name
			⚫ actual_trips
			⚫ target_trips
			⚫ performance_status
			⚫ %_difference
*/

SELECT C.city_name, 
       D.month_name,
       COUNT(T.trip_id) AS actual_trips,
       MT.total_target_trips AS target_trips,
       CASE
       WHEN COUNT(T.trip_id) > MT.total_target_trips THEN "Above Target" ELSE "Below Target"
       END AS performance_status,
       ROUND(((COUNT(T.trip_id) - MT.total_target_trips) / MT.total_target_trips)*100, 2) AS '%_difference'
FROM trips_db.dim_city C
JOIN trips_db.fact_trips T
ON C.city_id = T.city_id
JOIN trips_db.dim_date D
ON T.date = D.date
JOIN targets_db.monthly_target_trips MT
ON MT.city_id = T.city_id AND MT.month = D.start_of_month
GROUP BY C.city_name, D.month_name, MT.total_target_trips, D.start_of_month
ORDER BY C.city_name, MONTH(D.start_of_month);