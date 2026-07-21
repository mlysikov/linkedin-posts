CREATE MATERIALIZED VIEW mart.orders_to_daily_sales_mv
TO mart.daily_sales
AS
SELECT
  toDate(created_at) AS sales_date,
  count() AS orders_count,
  sum(quantity) AS units_sold,
  CAST(sum(toDecimal128(quantity, 0) * price), 'Decimal(18, 2)') AS revenue
FROM raw.orders
GROUP BY sales_date;

SELECT 'Step 05: Materialized View is ready, but old rows were not replayed' AS note;

SELECT
  count() AS rows_in_target_after_mv_creation
FROM mart.daily_sales;
