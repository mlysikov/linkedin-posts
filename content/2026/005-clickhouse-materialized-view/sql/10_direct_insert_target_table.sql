INSERT INTO mart.daily_sales
  (sales_date, orders_count, units_sold, revenue)
VALUES
  ('2026-07-23', 99, 999, 12345.67);

SELECT 'Step 10: direct target insert changed mart.daily_sales only' AS note;

SELECT
  sales_date,
  sum(orders_count) AS orders_count,
  sum(units_sold) AS units_sold,
  sum(revenue) AS revenue
FROM mart.daily_sales
GROUP BY sales_date
ORDER BY sales_date;

SELECT
  count() AS raw_orders_on_2026_07_23
FROM raw.orders
WHERE toDate(created_at) = '2026-07-23';
