CREATE TABLE raw.orders
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

SELECT 'Step 02: raw.orders source table is ready' AS note;
