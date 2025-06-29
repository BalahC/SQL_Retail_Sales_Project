# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Level**: Intermediate 
**Database**: `SQL_PROJECT_db`

This project showcases my SQL skills in the context of real-world retail sales data—demonstrating techniques I’ve used as a data analyst to explore, clean, and extract meaningful insights from raw datasets. I set up a structured retail sales database and conducted exploratory data analysis (EDA) to uncover trends and answer key business questions using efficient, well-structured SQL queries. It reflects my approach to practical problem-solving and is a great example of how I apply foundational SQL techniques to drive data-informed decisions—especially valuable for those beginning their journey into data analytics.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `SQL_PROJECT_db`.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
CREATE DATABASE SQL_PROJECT_db;

CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
SELECT COUNT(*) FROM retail_sales;
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
SELECT DISTINCT category FROM retail_sales;

SELECT * FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:


1. **How many sale we've made so far?** 
```sql
SELECT COUNT(transactions_id) As total_orders FROM retail_sales;
```

**How many unique customers do we have?** 
```sql
SELECT COUNT(DISTINCT customer_id) As total_customers FROM retail_sales;
```
**Which categories are we selling?**
```sql
SELECT DISTINCT category FROM retail_sales;
```
### **DATA ANALYSIS & BUSINESS KEY PROBLEMS & ANSWERS**

**Retrieve all information from sales made on 2024-11-05 for investigations**
```sql
SELECT * FROM retail_sales
	WHERE sale_date = '2024-11-05';
```

2. **Retrieve all transactions where the category is 'Clothing' & the quantity sold is more than 2 in the month of november 2024.**:
```sql
SELECT * FROM retail_sales 
	WHERE
        category = 'Clothing'
    	AND
    	quantity >2
    	AND     --sale_date BETWEEN '2024-11-01' AND '2024-11-30'
    	TO_CHAR (sale_date, 'YYYY-MM')='2024-11';

```

3. **Return the TOtal sales for each categories.**:
```sql
SELECT category,
	sum (total_sale) as Net_sales,
	COUNT(*) as total_orders
	FROM retail_sales
GROUP BY category;

```

4. **Find Age group (Av age) of customer who purchased 'beauty' products category.**:
```sql
SELECT ROUND(AVG(age),0) as avg_age
 FROM retail_sales
 WHERE category = 'Beauty'; -- mostly Elderly people ( 40 years old) 
```

5. **Retrieve all transactions where total_sales is > 1000.**:
```sql
SELECT * FROM retail_sales
WHERE total_sale > 1000
```

6. **Get the total number of transactions made by each gender in each category.**:
```sql
SELECT category,gender,
	    COUNT(transactions_id) as Total_orders
FROM retail_sales
GROUP 
	BY
        category,
		gender	
ORDER BY 1;
```

7. **Find Av sales for each month & in descending order. Find out best selling month in each year**:
```sql
SELECT 
	EXTRACT(YEAR FROM sale_date) as year,
	EXTRACT(MONTH FROM sale_date) as month,
	ROUND(AVG(total_sale),1) as AVG_sales
FROM retail_sales
GROUP BY year,month
ORDER BY 1, 3 DESC;
```
7.1. **Find out best selling month in each year**:
```sql
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

```
8. **find the top 5 customers based on the highest total sales **:
```sql
SELECT customer_id,
	SUM(total_sale) as "Sales"
FROM retail_sales
	GROUP BY customer_id
	ORDER BY "Sales" DESC
	LIMIT 5; -- limitting to the top 5 customers
```

9. **Find number of unique customers who purchased fro each category.**:
```sql
SELECT
        category,
        COUNT(DISTINCT customer_id) FROM retail_sales
 GROUP BY category
 ORDER BY 2 DESC;
```
10. **What are the number of orders during each time of the day (shift of the day e.g Morning <12, Afternoon Between 12 & 17, Evening >17)**:
```sql
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

SELECT
        time_of_day,
		COUNT(transactions_id) as "Total_orders",
		SUM(quantity)as "Total_Qty",
		SUM(total_sale) as "Total_Sales"
		
FROM  hourly_sale
GROUP BY time_of_day
ORDER BY "Total_orders" DESC;
```

## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and time_of_day.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

This project serves as a hands-on introduction to SQL, reflecting the core tasks I perform as a data analyst—from setting up databases to cleaning and exploring retail sales data. Through structured SQL queries, I analyzed customer behavior, sales trends, and product performance to extract insights that can support smarter business decisions. It's a practical example of how I use SQL not just to explore data, but to tell a clear, actionable story that aligns with business goals.



## Author - SHING The Analyst

This project is a part of my portfolio and highlights the SQL skills that are fundamental to my work as a data analyst. I'm always open to feedback, questions, or opportunities to collaborate—feel free to reach out!




- **LinkedIn**: [Connect with me professionally](https://www.linkedin.com/in/shingbalahclouston/)


Thank you for your time and I look forward to connecting with you!
