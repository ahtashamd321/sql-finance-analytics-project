-- 1. Count total EMI payments.
SELECT COUNT(*) AS total_emi_payments
FROM payments;

-- 2. % On-time vs Late vs Missed payments.
SELECT payment_status,
	   COUNT(*) AS total_payments,
       ROUND(
             COUNT(*) * 100.0 / ( SELECT COUNT(*) FROM payments), 2) AS percentage
FROM payments
GROUP BY payment_status;

-- 3. Customers with >3 late payments.
SELECT c.customer_id, 
       c.customer_name,
       COUNT(*) AS late_payments
FROM customers AS c
JOIN loans AS l
	ON c.customer_id = l.customer_id
JOIN payments AS p
	ON l.loan_id = p.loan_id
WHERE payment_status = 'Late'
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(*) >3; 

-- 4. Months with highest late payments.
SELECT 
      MONTHNAME(payment_date) AS month_name,
      MONTH(payment_date) AS month_number,
      COUNT(*) AS total_late_payments
FROM payments
WHERE payment_status = 'Late'
GROUP BY month_name, month_number
ORDER BY total_late_payments DESC;

-- 5. EMI payments for last 3 months.
SELECT payment_id,
       loan_id,
       payment_date,
       emi_amount,
       payment_status
FROM payments
WHERE payment_date >= DATE_SUB(
					 (SELECT MAX(payment_date) FROM payments),
                     INTERVAL 3 MONTH)
ORDER BY payment_date DESC;

-- 6. Total EMI amount collected.
SELECT SUM(emi_amount) AS total_amount_collected
FROM payments;

-- 7. Missing EMI payments per customer.
SELECT c.customer_id,
       c.customer_name,
       l.Loan_id,
       COUNT(p.payment_id) AS total_missed_emi
FROM customers AS c
JOIN loans AS l
	ON c.customer_id = l.customer_id
LEFT JOIN payments AS p
	ON p.loan_id = l.loan_id
	AND p.payment_status = 'Missed'
GROUP BY c.customer_id, c.customer_name, l.loan_id
ORDER BY total_missed_emi;

-- 8. Perfect on-time payments.
SELECT c.customer_id,
       c.customer_name,
       COUNT(p.payment_id) AS total_On_time_payments
FROM customers AS c
JOIN loans AS l
	ON c.customer_id = l.customer_id
LEFT JOIN payments AS p
	ON p.loan_id = l.loan_id 
    AND p.payment_status = 'On-Time'
GROUP BY c.customer_id, c.customer_name;

-- 9. Loans with >5 missed EMIs.
SELECT c.customer_id,
       l.loan_id,
       c.customer_name,
       COUNT(p.payment_id) AS total_emi_missed
FROM customers AS c
JOIN loans AS l
	ON c.customer_id = l.customer_id
LEFT JOIN payments AS p
	On p.loan_id = l.loan_id
    AND p.payment_status = 'Missed'
GROUP BY c.customer_id, l.loan_id, c.customer_name
HAVING COUNT(p.payment_id) >2;

-- 10. Customers who pay 5+ days late often.
SELECT c.customer_id,
	   c.customer_name,
       COUNT(p.payment_id) AS late_payment_count
FROM customers AS c
JOIN loans AS l
	ON c.customer_id = l.customer_id
JOIN payments AS p
	ON p.loan_id = l.loan_id
WHERE DATEDIFF(p.payment_date, p.due_date) >= 5
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(p.payment_id) > 2
ORDER BY late_payment_count DESC;
       
	

