-- Топ-10 товаров по выручке и их доля в общей выручке (оконная функция)
SELECT stock_code,
       MAX(description)                                        AS description,
       SUM(quantity)                                           AS units,
       ROUND(SUM(revenue), 0)                                  AS revenue,
       ROUND(100.0 * SUM(revenue) / SUM(SUM(revenue)) OVER (), 2) AS revenue_share_pct,
       COUNT(DISTINCT customer_id)                             AS buyers
FROM orders
GROUP BY stock_code
ORDER BY revenue DESC
LIMIT 10;
