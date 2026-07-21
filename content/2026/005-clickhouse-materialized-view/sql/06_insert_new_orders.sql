INSERT INTO raw.orders
  (order_id, customer_id, product_id, quantity, price, created_at)
VALUES
  (1001, 601, 201, 2, 19.99, '2026-07-20 10:15:00'),
  (1002, 602, 202, 1, 49.50, '2026-07-20 10:20:00'),
  (1003, 603, 203, 3, 12.00, '2026-07-21 12:00:00'),
  (1004, 604, 204, 1, 129.99, '2026-07-21 13:30:00');

SELECT 'Step 06: new source rows inserted after MV creation' AS note;
