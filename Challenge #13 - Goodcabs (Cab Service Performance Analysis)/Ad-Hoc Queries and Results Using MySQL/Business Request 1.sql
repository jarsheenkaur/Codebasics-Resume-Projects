/*
Business Request - 1: City-Level Fare and Trip Summary Report
Generate a report that displays the total trips, average fare per km, average fare per trip, and the percentage contribution of each city's trips to the overall trips. This report will help in assessing trip volume, pricing efficiency, and each city's contribution to the overall trip count.
		Fields:
			⚫ city_name
			⚫ total_trips
			⚫ avg_fare_per_km
			⚫ avg_fare_per_trip
			⚫ %_contribution_to_total_trips
*/

SELECT C.city_name, 
       COUNT(T.trip_id) AS total_trips, 
       ROUND(SUM(T.fare_amount) / SUM(T.distance_travelled_km), 2) AS avg_fare_per_km,
       ROUND(SUM(T.fare_amount) / COUNT(T.trip_id), 2) AS avg_fare_per_trip,
       ROUND(COUNT(T.trip_id) * 100.0 / (SELECT COUNT(*) FROM trips_db.fact_trips), 2) AS '%_contribution_to_total_trips'
FROM trips_db.dim_city C
JOIN trips_db.fact_trips T
ON C.city_id = T.city_id
GROUP BY C.city_name
ORDER BY total_trips DESC;