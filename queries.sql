-- Query 1: Churn rate by contract
SELECT Contract,
       COUNT(*) AS customers,
       SUM(Churn_Value) AS churned,
       ROUND(100.0 * SUM(Churn_Value) / COUNT(*), 1) AS churn_rate_pct
FROM customers
GROUP BY Contract
ORDER BY churn_rate_pct DESC;

-- Query 2: Retention by tenure bucket
SELECT CASE
         WHEN Tenure_Months <= 12 THEN '0-12 months'
         WHEN Tenure_Months <= 24 THEN '13-24 months'
         ELSE '25+ months'
       END AS tenure_bucket,
       COUNT(*) AS customers,
       ROUND(100.0 * (COUNT(*) - SUM(Churn_Value)) / COUNT(*), 1) AS retention_pct
FROM customers
GROUP BY tenure_bucket
ORDER BY MIN(Tenure_Months);

-- Query 3: Revenue at risk (predicted churners who have not left yet)
SELECT COUNT(*) AS likely_churners,
       ROUND(SUM(Monthly_Charges), 2) AS monthly_revenue_at_risk,
       ROUND(SUM(Monthly_Charges) * 12, 2) AS yearly_revenue_at_risk
FROM customers
WHERE Predicted_Churn = 1 AND Churn_Value = 0;