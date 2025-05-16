/*
Business Request - 4: Identify Cities with Highest and Lowest Total New Passengers
Generate a report that calculates the total new passengers for each city and ranks them based on this value. Identify the top 3 cities with the highest number of new passengers as well as the bottom 3 cities with the lowest number of new passengers, categorising them as "Top 3" or "Bottom 3" accordingly.
		Fields
			⚫ city_name
			⚫ total_new_passengers
			⚫ city_category ("Top 3" or "Bottom 3")
*/

WITH ranked_cities AS 
(
	SELECT C.city_name,
		   SUM(PS.new_passengers) AS total_new_passengers,
		   ROW_NUMBER() OVER(ORDER BY SUM(PS.new_passengers) DESC) AS city_rank,
           COUNT(*) OVER() AS total_cities
	FROM trips_db.dim_city C
	JOIN trips_db.fact_passenger_summary PS
	ON C.city_id = PS.city_id
	GROUP BY C.city_name
	ORDER BY total_new_passengers DESC
),
city_rank_category AS 
(
	SELECT city_name,
		   total_new_passengers,
		   CASE 
		   WHEN city_rank <= 3 THEN "Top 3"
		   WHEN city_rank > (total_cities - 3) THEN "Bottom 3"
           ELSE NULL
		   END AS city_category
	FROM ranked_cities
)
SELECT * 
FROM city_rank_category
WHERE city_category IS NOT NULL
ORDER BY total_new_passengers DESC;