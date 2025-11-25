--  01. Count total loans issued.
SELECT COUNT(*) AS total_loans
FROM loans;

-- 02. Total loan amount disbursed.
SELECT SUM(loan_amount) AS total_disbursed_amount
FROM loans;

-- 03. Loan count by loan type.
SELECT loan_type, COUNT(loan_id) AS total_loans
FROM loans
GROUP BY loan_type;

-- 04. Highest loan amount per loan type.
SELECT loan_type, MAX(loan_amount) AS highest_loan_amount
FROM loans
GROUP BY loan_type;

-- 05. Average interest rate by loan type.
SELECT loan_type, ROUND(AVG(interest_rate),2) AS avg_interest_rate
FROM loans
GROUP BY loan_type;

-- 06. Loans with tenure > 5 years.
SELECT loan_id, loan_type, tenure_months
FROM loans
WHERE tenure_months > 60;

-- 07. Loans approved in last 12 months.
SELECT loan_id, loan_type, start_date
FROM loans
WHERE start_date >=(
					SELECT DATE_SUB(MAX(start_date), INTERVAL 12 MONTH)
                    FROM loans);
                    
-- 8. Customer-wise loan exposure.
SELECT customer_id,
       SUM(loan_amount) AS total_loan_exposure
FROM loans
GROUP BY customer_id
ORDER BY total_loan_exposure;

-- 09. Loans with interest rate > 15%.
SELECT loan_id, loan_type, interest_rate
FROM loans
WHERE interest_rate >15
ORDER BY interest_rate;

-- 10 Loan distribution by city.
SELECT c.city,
	   l.loan_type,
	   COUNT(l.loan_id) AS total_loans
FROM customers AS c
JOIN loans AS l
	ON c.customer_id = l.customer_id
GROUP BY c.city, l.loan_type;
       