/*
Business Request - 5: Identify Month with Highest Revenue for Each City
Generate a report that identifies the month with the highest revenue for each city. For each city, display the month_name, the revenue amount for that month, and the percentage contribution of that month's revenue to the city's total revenue.
		Fields
			⚫ city_name
			⚫ highest_revenue_month
			⚫ revenue
			⚫ percentage_contribution (%)
*/

WITH city_total_revenue AS 
(
    SELECT C.city_id,
           C.city_name,
           SUM(T.fare_amount) AS total_revenue
    FROM trips_db.dim_city C
    JOIN trips_db.fact_trips T
    ON C.city_id = T.city_id
    GROUP BY C.city_id, C.city_name
),
city_total_monthly_revenue AS 
(
    SELECT T.city_id,
           D.month_name,
           SUM(T.fare_amount) AS month_revenue
    FROM trips_db.fact_trips T
    JOIN trips_db.dim_date D
    ON T.date = D.date
    GROUP BY T.city_id, D.month_name
)

SELECT city_name, 
	   month_name AS highest_revenue_month,
       month_revenue AS revenue,
       ROUND((month_revenue / total_revenue) * 100, 2) AS percentage_contribution
FROM city_total_revenue CTR
JOIN city_total_monthly_revenue CTMR
ON CTR.city_id = CTMR.city_id
WHERE CTMR.month_revenue = (SELECT MAX(month_revenue) FROM city_total_monthly_revenue WHERE city_id = CTR.city_id)
ORDER BY percentage_contribution DESC;