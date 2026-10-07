SELECT * FROM public.retail_sales
ORDER BY transactions_id ASC LIMIT 100

--Data Analysis & Business Key Problems & Answers

-- Q1. Write a SQL query to retrieve all columns for sales made on '2022-11-05'
-- Q2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q3. Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty category'
-- Q5. Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q6. Write a SQL query to find the total number of transactions (transactions_id) made by each other in each category.
-- Q7. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.
-- Q8. Write a SQL query to find the top 5 customers based on the highest toal sales.
-- Q9. Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q10. Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening > 17)

-- A1.
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

--A2.
SELECT 
  *
FROM retail_sales  
WHERE category = 'Clothing'
  AND 
  TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
  AND
  quantiy >= 4

--A3.
SELECT 
  category,
  SUM(total_sale) as net_sale,
  count(*) as total_orders
FROM retail_sales
GROUP BY 1

--A4.
SELECT 
  ROUND(AVG(age), 2) as avg_age
FROM retail_sales  
WHERE category = 'Beauty'

--A5.
SELECT * FROM retail_sales
where total_sale > 1000

--A6.
SELECT 
    category,
	gender,
	COUNT(*) as total_trans
FROM retail_sales
GROUP 
    BY
	category,
	gender
ORDER BY 1

--A7.
SELECT 
      year,
	  month,
	  avg_sale
FROM
(
	SELECT 
	    EXTRACT(YEAR FROM sale_date) as year,
	    EXTRACT(MONTH FROM sale_date) as month,
		AVG(total_sale) as avg_sale,
		RANK() OVER(PARTITION BY EXTRACT (YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
	FROM retail_sales
	GROUP BY 1,2
) as t1
WHERE rank = 1


--A8.
SELECT 
  customer_id,
  SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

--A9.
SELECT
  category,
  COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retail_sales  
GROUP BY category

--A10.
WITH hourly_sale
AS
(
SELECT *,
  CASE
    WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
	WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
	ELSE 'Evening'
  END as shift
FROM retail_sales
)
SELECT 
    shift,
	COUNT(*) as total_orders
FROM hourly_sale
GROUP BY shift

-- SELECT EXTRACT (HOUR FROM CURRENT_TIME)

 

	


