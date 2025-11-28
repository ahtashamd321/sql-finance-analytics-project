-- 1. Count total defaults.
SELECT COUNT(default_id) AS total_defaults 
FROM loan_defaults;

-- 2. Total default amount lost.
SELECT SUM(default_amount) AS total_amount_lost
FROM loan_defaults;

-- 3. Loan type with most defaults.
SELECT l.loan_type,
       COUNT(ld.default_id) AS total_defaults
FROM loan_defaults AS ld
JOIN loans AS l
	ON l.loan_id = ld.loan_id
GROUP BY l.loan_type
ORDER BY total_defaults DESC LIMIT 1;

-- 4. Top 10 highest default customers.
SELECT c.customer_id,
	   c.customer_name,
       COUNT(ld.default_id) AS total_defaults
FROM customers AS c
JOIN loans AS l
	ON c.customer_id = l.customer_id
JOIN loan_defaults AS ld
	ON l.loan_id = ld.loan_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_defaults DESC LIMIT 10;

-- 05 Customers with late payment + default history.
SELECT DISTINCT
    c.customer_id,
    c.customer_name,
    c.city,
    c.annual_income
FROM customers c
JOIN loans l 
    ON c.customer_id = l.customer_id
JOIN loan_defaults d
    ON l.loan_id = d.loan_id
JOIN payments p
    ON l.loan_id = p.loan_id
WHERE (p.payment_status) IN ('Late', 'Missed');


-- 06 City-wise default ratio.
SELECT 
    c.city,
    COUNT(DISTINCT d.loan_id) AS total_defaulted_loans,
    COUNT(DISTINCT l.loan_id) AS total_loans,
    ROUND(
        COUNT(DISTINCT d.loan_id) / COUNT(DISTINCT l.loan_id) * 100,
        2
    ) AS default_ratio_percentage
FROM customers c
JOIN loans l 
    ON c.customer_id = l.customer_id
LEFT JOIN loan_defaults d
    ON l.loan_id = d.loan_id
GROUP BY c.city
ORDER BY default_ratio_percentage DESC;
                
-- 7 Income vs default rate analysis.
SELECT 
    CASE 
        WHEN c.annual_income < 300000 THEN 'Low Income (<3L)'
        WHEN c.annual_income BETWEEN 300000 AND 700000 THEN 'Middle Income (3L-7L)'
        WHEN c.annual_income BETWEEN 700000 AND 1500000 THEN 'High Income (7L-15L)'
        ELSE 'Very High Income (>15L)'
    END AS income_group,
    
    COUNT(DISTINCT l.loan_id) AS total_loans,
    COUNT(DISTINCT d.loan_id) AS defaulted_loans,
    
    ROUND(
        COUNT(DISTINCT d.loan_id) / COUNT(DISTINCT l.loan_id) * 100, 
        2
    ) AS default_rate_percentage
FROM customers c
JOIN loans l 
    ON c.customer_id = l.customer_id
LEFT JOIN loan_defaults d 
    ON l.loan_id = d.loan_id
GROUP BY income_group
ORDER BY default_rate_percentage DESC;

-- 08 Age group vs default rate.
SELECT
    CASE
        WHEN c.age < 25 THEN '18–24'
        WHEN c.age BETWEEN 25 AND 34 THEN '25–34'
        WHEN c.age BETWEEN 35 AND 44 THEN '35–44'
        WHEN c.age BETWEEN 45 AND 54 THEN '45–54'
        WHEN c.age BETWEEN 55 AND 64 THEN '55–64'
        ELSE '65+'
    END AS age_group,

    COUNT(DISTINCT l.loan_id) AS total_loans,
    COUNT(DISTINCT d.loan_id) AS defaulted_loans,

    ROUND(
        (COUNT(DISTINCT d.loan_id) / COUNT(DISTINCT l.loan_id)) * 100,
        2
    ) AS default_rate_percentage
FROM customers c
JOIN loans l 
    ON c.customer_id = l.customer_id
LEFT JOIN loan_defaults d
    ON l.loan_id = d.loan_id
GROUP BY age_group
ORDER BY default_rate_percentage DESC;


-- 09  Missed EMIs before default.
SELECT 
    c.customer_id,
    c.customer_name,
    l.loan_id,
    d.default_date,
    COUNT(*) AS missed_emis_before_default
FROM loan_defaults d
JOIN loans l 
    ON d.loan_id = l.loan_id
JOIN customers c
    ON l.customer_id = c.customer_id
JOIN payments p
    ON p.loan_id = l.loan_id
WHERE TRIM(p.payment_status) = 'Missed'
  AND p.payment_date < d.default_date     
GROUP BY 
    c.customer_id, 
    c.customer_name,
    l.loan_id,
    d.default_date
ORDER BY missed_emis_before_default DESC;






