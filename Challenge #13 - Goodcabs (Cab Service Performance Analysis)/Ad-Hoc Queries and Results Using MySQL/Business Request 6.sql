/*
Business Request - 6: Repeat Passenger Rate Analysis
Generate a report that calculates two metrics:
	1. Monthly Repeat Passenger Rate: Calculate the repeat passenger rate for each city and month by comparing the number of repeat passengers to the total passengers. 
	2. City-wide Repeat Passenger Rate: Calculate the overall repeat passenger rate for each city, considering all passengers across months.
These metrics will provide insights into monthly repeat trends as well as the overall repeat behaviour for each city.
		Fields:
			⚫ city_name 
			⚫ month
			⚫ total_passengers
			⚫ repeat_passengers
			⚫ monthly_repeat_passenger_rate (%): Repeat passenger rate at the city and month level
			⚫ city_repeat_passenger_rate (%): Overall repeat passenger rate for each city, aggregated across months
*/

WITH city_passenger_data AS
(
	SELECT C.city_name,
           D.start_of_month,
		   D.month_name AS month,
		   SUM(PS.total_passengers) AS total_passengers,
		   SUM(PS.repeat_passengers) AS repeat_passengers
	FROM trips_db.dim_city C
	JOIN trips_db.fact_passenger_summary PS
	ON C.city_id = PS.city_id
	JOIN trips_db.dim_date D
	ON PS.month = D.start_of_month
	GROUP BY C.city_name, D.start_of_month, D.month_name
)
SELECT city_name,
	   month,
       total_passengers,
       repeat_passengers,
       ROUND(CASE WHEN total_passengers = 0 THEN 0 
             ELSE (repeat_passengers / total_passengers) * 100 
             END, 2) AS monthly_repeat_passenger_rate_percentage,
	   ROUND(CASE 
             WHEN SUM(total_passengers) OVER (PARTITION BY city_name) = 0 THEN 0 
             ELSE (SUM(repeat_passengers) OVER (PARTITION BY city_name) / SUM(total_passengers) OVER (PARTITION BY city_name)) * 100 
             END, 2) AS city_repeat_passenger_rate_percentage
FROM city_passenger_data
ORDER BY city_name, start_of_month;