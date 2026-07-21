INSERT INTO raw.orders
  (order_id, customer_id, product_id, quantity, price, created_at)
VALUES
  (1005, 605, 202, 2, 49.50, '2026-07-21 16:45:00'),
  (1006, 606, 205, 4, 7.25, '2026-07-22 09:05:00');

SELECT 'Step 08: another source INSERT was processed by the MV' AS note;
