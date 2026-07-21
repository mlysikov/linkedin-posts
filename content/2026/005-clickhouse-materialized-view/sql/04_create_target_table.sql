CREATE TABLE mart.daily_sales
(
  sales_date   Date,
  orders_count UInt64,
  units_sold   UInt64,
  revenue      Decimal(18, 2)
)
ENGINE = SummingMergeTree
PARTITION BY toYYYYMM(sales_date)
ORDER BY sales_date;

SELECT 'Step 04: mart.daily_sales target table is ready' AS note;
