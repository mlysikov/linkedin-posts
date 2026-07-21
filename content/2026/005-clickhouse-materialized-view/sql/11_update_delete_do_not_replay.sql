ALTER TABLE raw.orders
  UPDATE quantity = 10
  WHERE order_id = 1001
  SETTINGS mutations_sync = 1;

ALTER TABLE raw.orders
  DELETE
  WHERE order_id = 1002
  SETTINGS mutations_sync = 1;

SELECT 'Step 11: source mutations finished; the target aggregate was not replayed' AS note;

SELECT
  'source recomputed now' AS place,
  toDate(created_at) AS sales_date,
  count() AS orders_count,
  sum(quantity) AS units_sold,
  sum(quantity * price) AS revenue
FROM raw.orders
WHERE toDate(created_at) = '2026-07-20'
GROUP BY sales_date

UNION ALL

SELECT
  'target still has old MV result' AS place,
  sales_date,
  sum(orders_count) AS orders_count,
  sum(units_sold) AS units_sold,
  sum(revenue) AS revenue
FROM mart.daily_sales
WHERE sales_date = '2026-07-20'
GROUP BY sales_date
ORDER BY place;
