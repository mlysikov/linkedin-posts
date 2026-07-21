SELECT 'Step 09: mart.daily_sales after the second source INSERT' AS note;

SELECT
  sales_date,
  sum(orders_count) AS orders_count,
  sum(units_sold) AS units_sold,
  sum(revenue) AS revenue
FROM mart.daily_sales
GROUP BY sales_date
ORDER BY sales_date;
