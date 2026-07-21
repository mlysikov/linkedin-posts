SELECT 'Step 07: mart.daily_sales was filled automatically by the MV' AS note;

SELECT
  sales_date,
  sum(orders_count) AS orders_count,
  sum(units_sold) AS units_sold,
  sum(revenue) AS revenue
FROM mart.daily_sales
GROUP BY sales_date
ORDER BY sales_date;

SELECT 'The rows inserted before MV creation are still only in raw.orders' AS note;

SELECT
  toDate(created_at) AS sales_date,
  count() AS source_rows_before_mv,
  sum(quantity) AS source_units_before_mv
FROM raw.orders
WHERE order_id >= 9000
GROUP BY sales_date
ORDER BY sales_date;
