-- Когортный анализ: сколько покупателей каждой когорты возвращается в месяц N
-- Когорта = месяц первой покупки клиента
WITH first_purchase AS (
    SELECT customer_id,
           MIN(strftime('%Y-%m', invoice_date)) AS cohort
    FROM orders
    GROUP BY customer_id
),
activity AS (
    SELECT DISTINCT customer_id,
           strftime('%Y-%m', invoice_date) AS activity_month
    FROM orders
),
cohort_activity AS (
    SELECT f.cohort,
           a.customer_id,
           (CAST(substr(a.activity_month, 1, 4) AS INTEGER)
              - CAST(substr(f.cohort, 1, 4) AS INTEGER)) * 12
           + CAST(substr(a.activity_month, 6, 2) AS INTEGER)
              - CAST(substr(f.cohort, 6, 2) AS INTEGER) AS month_number
    FROM activity a
    JOIN first_purchase f USING (customer_id)
)
SELECT cohort,
       month_number,
       COUNT(DISTINCT customer_id) AS active_customers,
       ROUND(100.0 * COUNT(DISTINCT customer_id)
             / FIRST_VALUE(COUNT(DISTINCT customer_id)) OVER (
                   PARTITION BY cohort ORDER BY month_number), 1) AS retention_pct
FROM cohort_activity
GROUP BY cohort, month_number
ORDER BY cohort, month_number;
