-- База для RFM-сегментации: давность, частота и сумма покупок по клиенту
-- Точка отсчёта: день после последней транзакции в данных
WITH ref AS (
    SELECT DATE(MAX(invoice_date), '+1 day') AS ref_date FROM orders
)
SELECT o.customer_id,
       CAST(julianday(ref.ref_date) - julianday(DATE(MAX(o.invoice_date))) AS INTEGER) AS recency_days,
       COUNT(DISTINCT o.invoice_no)                                                   AS frequency,
       ROUND(SUM(o.revenue), 2)                                                       AS monetary
FROM orders o
CROSS JOIN ref
GROUP BY o.customer_id;
