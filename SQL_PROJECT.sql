SELECT * FROM retail_sales;

SELECT COUNT(*) FROM retail_sales; -- Counting the nb of rows

-- checking for all nulls values accross rows

SELECT * FROM retail_sales
WHERE transactions_id IS null ;

-- Data Cleaning
-- checking for all nulls values accross the columns at once

SELECT * FROM retail_sales
	WHERE 
		transactions_id IS null
		OR
		sale_date IS null
		OR
		sale_time IS null
		OR
		customer_id IS null
		OR
		gender IS null
		OR 
		category IS null
		OR 
		quantity IS null
		OR 
		price_per_unit IS null
		OR 
		cost_price IS null
		OR 
		total_sale IS null;

-- Deleting null VALUES
DELETE FROM retail_sales
	WHERE price_per_unit IS null
		OR 
		cost_price IS null
		OR 
		total_sale IS null;

-- Data Exploration

-- How many sale we've made so far?

SELECT COUNT(transactions_id) As total_orders FROM retail_sales;

-- How many unique customers do we have?

SELECT COUNT(DISTINCT customer_id) As total_customers FROM retail_sales;

-- Which categories are we selling?

SELECT DISTINCT category FROM retail_sales;

-- DATA ANALYSIS & BUSINESS KEY PROBLEMS & ANSWERS

-- Retrieve all information from sales made on 2024-11-05 for investigations.ABORT
SELECT * FROM retail_sales
	WHERE sale_date = '2024-11-05';

-- Retrieve all transactions where the category is 'Clothing' & the quantity
-- sold is more than 2 in the month of november 2024.

SELECT * FROM retail_sales 
	WHERE category = 'Clothing'
	AND
	quantity >2
	AND     --sale_date BETWEEN '2024-11-01' AND '2024-11-30'
	TO_CHAR (sale_date, 'YYYY-MM')='2024-11';


-- Return the TOtal sales for each categories

SELECT category,

	sum (total_sale) as Net_sales,
	COUNT(*) as total_orders
	
	FROM retail_sales
GROUP BY category;

-- Find Age group (Av age) of customer who purchased 'beauty' products category
 SELECT ROUND(AVG(age),0)
 FROM retail_sales
 WHERE category = 'Beauty'; -- mostly Elderly people ( 40 years old) 


 -- Retrieve all transactions where total_sales is > 1000

 SELECT * FROM retail_sales
 	WHERE total_sale > 1000;


--- Get the total number of transactions made by each gender in each category

SELECT category,gender,
	COUNT(transactions_id) as Total_orders FROM retail_sales
GROUP 
	BY 
		category,
		gender
		
ORDER BY 1;


-- Find Av sales for each month & in descending order

SELECT 
	EXTRACT(YEAR FROM sale_date) as year,
	EXTRACT(MONTH FROM sale_date) as month,
	ROUND(AVG(total_sale),1) as AVG_sales
FROM retail_sales
GROUP BY year,month
ORDER BY 1, 3 DESC;

-- Return the best selling MONTH in each YEAR
-- Using the RANK function to get the best selling month

SELECT 
	year,
	month,
	avg_sales
	FROM 
		(
 SELECT 
	EXTRACT(YEAR FROM sale_date) as year,
	EXTRACT(MONTH FROM sale_date) as month,
	ROUND(AVG(total_sale),1) as AVG_sales,
	
	RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) 
	ORDER BY ROUND(AVG(total_sale),1) DESC ) as "Rank"
FROM retail_sales
GROUP BY year,month
		) as ranking 
WHERE "Rank"=1; -- can clearly see my top selling month in each year

-- Find top 5 customer based on total_Sales

SELECT customer_id,
	SUM(total_sale) as "Sales"
FROM retail_sales
	GROUP BY customer_id
	ORDER BY "Sales" DESC
	LIMIT 5; -- limitting to the top 5 customers


-- Find number of unique customers who purchased fro each category

SELECT category,
COUNT(DISTINCT customer_id) FROM retail_sales
GROUP BY category
ORDER BY 2 DESC


--- What are the number of orders during each time of the day (shift of the day)
 
 WITH hourly_sale AS ---- saving as CDE and creating a table called hourly_sale 
 (
 SELECT *,
 		CASE
 			WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
			 WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
			 ELSE 'Evening'
			 END as time_of_day
 
 FROM retail_sales
)

SELECT time_of_day,
		COUNT(transactions_id) as "Total_orders",
		SUM(quantity)as "Total_Qty",
		SUM(total_sale) as "Total_Sales"
		
FROM  hourly_sale
GROUP BY time_of_day
ORDER BY "Total_orders" DESC;