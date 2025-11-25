-- 1. Find total number of customers.
SELECT COUNT(*) AS total_customers FROM customers;

-- 2. List customers with income above 10 lakh.
SELECT customer_id, customer_name, annual_income
FROM customers
WHERE annual_income > 1000000;

-- 3. Identify customers with more than 1 loan.
SELECT c.customer_id,
	   c.customer_name, 
       COUNT(l.loan_id) AS total_loan
FROM customers AS c
JOIN loans AS l
	ON c.customer_id = l.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(l.loan_id) >1;

--  4. Find top 10 highest-income customers.
SELECT customer_id, customer_name, annual_income
FROM customers
ORDER BY annual_income DESC LIMIT 10;

-- Show customers grouped by age category.
SELECT 
	  CASE
		 WHEN age BETWEEN 18 AND 25 THEN 'Young (18-25)'
         WHEN age BETWEEN 26 AND 40 THEN 'Adult (26-40)'
         WHEN age BETWEEN 41 AND 60 THEN 'Middile-age (41-60)'
         WHEN age > 60 THEN 'Senior (60+)'
         ELSE 'unknown'
	 END AS age_category,
     COUNT(customer_id) AS total_customers
FROM customers
GROUP BY age_category
ORDER BY total_customers DESC;

--  6. Find city-wise customer distribution.
SELECT city, COUNT(customer_id) AS total_customers
FROM customers
GROUP BY city
ORDER BY total_customers DESC; 

-- 7. Identify customers who joined in last 6 months.
SELECT customer_id, customer_name, join_date
FROM customers
WHERE join_date >= (
    SELECT DATE_SUB(MAX(join_date), INTERVAL 6 MONTH)
    FROM customers
);

-- 8. Detect customers with income < 4 lakh.
SELECT customer_id, customer_name, annual_income
FROM customers
WHERE annual_income < 400000
ORDER BY annual_income DESC;

-- 9. Show gender distribution.
SELECT gender, COUNT(gender) AS total_customers
FROM customers
GROUP BY gender;

-- 10. Identify customers who have only personal loans.
SELECT c.customer_id, c.customer_name, l.loan_type
FROM customers AS c
JOIN loans AS l
	ON c.customer_id = l.customer_id
WHERE loan_type = 'personal';
