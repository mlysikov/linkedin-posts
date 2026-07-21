DROP TABLE IF EXISTS mart.populate_orders_to_daily_sales_mv;
DROP TABLE IF EXISTS raw.populate_orders;

CREATE TABLE raw.populate_orders
(
  order_id    UInt64,
  customer_id UInt64,
  product_id  UInt64,
  quantity    UInt32,
  price       Decimal(10, 2),
  created_at  DateTime
)
ENGINE = MergeTree
PARTITION BY toYYYYMM(created_at)
ORDER BY (created_at, order_id);

INSERT INTO raw.populate_orders
  (order_id, customer_id, product_id, quantity, price, created_at)
VALUES
  (2001, 701, 301, 1, 10.00, '2026-07-10 09:00:00'),
  (2002, 702, 302, 2, 20.00, '2026-07-10 10:00:00');

CREATE MATERIALIZED VIEW mart.populate_orders_to_daily_sales_mv
ENGINE = SummingMergeTree
PARTITION BY toYYYYMM(sales_date)
ORDER BY sales_date
POPULATE
AS
SELECT
  toDate(created_at) AS sales_date,
  count() AS orders_count,
  sum(quantity) AS units_sold,
  CAST(sum(toDecimal128(quantity, 0) * price), 'Decimal(18, 2)') AS revenue
FROM raw.populate_orders
GROUP BY sales_date;

SELECT 'Step 12a: POPULATE processed existing rows into the MV-owned storage' AS note;

SELECT
  sales_date,
  sum(orders_count) AS orders_count,
  sum(units_sold) AS units_sold,
  sum(revenue) AS revenue
FROM mart.populate_orders_to_daily_sales_mv
GROUP BY sales_date
ORDER BY sales_date;

INSERT INTO raw.populate_orders
  (order_id, customer_id, product_id, quantity, price, created_at)
VALUES
  (2003, 703, 303, 5, 3.50, '2026-07-11 14:00:00');

SELECT 'Step 12b: after creation, the same MV also processes future INSERTs' AS note;

SELECT
  sales_date,
  sum(orders_count) AS orders_count,
  sum(units_sold) AS units_sold,
  sum(revenue) AS revenue
FROM mart.populate_orders_to_daily_sales_mv
GROUP BY sales_date
ORDER BY sales_date;
