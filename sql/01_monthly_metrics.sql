-- Ключевые метрики по месяцам: выручка, заказы, покупатели, средний чек
-- Таблица orders: очищенные строки чеков (одна строка = одна позиция)
SELECT
    strftime('%Y-%m', invoice_date)                          AS month,
    ROUND(SUM(revenue), 0)                                   AS revenue,
    COUNT(DISTINCT invoice_no)                               AS orders,
    COUNT(DISTINCT customer_id)                              AS customers,
    ROUND(SUM(revenue) / COUNT(DISTINCT invoice_no), 1)      AS avg_order_value,
    ROUND(1.0 * COUNT(DISTINCT invoice_no)
          / COUNT(DISTINCT customer_id), 2)                  AS orders_per_customer
FROM orders
GROUP BY month
ORDER BY month;
