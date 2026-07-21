INSERT INTO raw.orders
  (order_id, customer_id, product_id, quantity, price, created_at)
VALUES
  (9001, 501, 101, 1, 19.99, '2026-07-18 09:10:00'),
  (9002, 502, 102, 2, 15.00, '2026-07-18 11:20:00');

SELECT 'Step 03: existing source rows inserted before MV creation' AS note;

SELECT
  toDate(created_at) AS sales_date,
  count() AS source_rows,
  sum(quantity) AS source_units,
  sum(quantity * price) AS source_revenue
FROM raw.orders
GROUP BY sales_date
ORDER BY sales_date;
