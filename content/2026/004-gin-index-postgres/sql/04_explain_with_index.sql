\echo 'Plan after creating the partial GIN trigram index'

ANALYZE products;

SELECT
  COUNT(*) AS matching_products
FROM products
WHERE
  category = 'electronics'
  AND status = 'active'
  AND attributes ->> 'description' ILIKE '%wireless%';

EXPLAIN (ANALYZE, BUFFERS)
SELECT *
FROM products
WHERE
  category = 'electronics'
  AND status = 'active'
  AND attributes ->> 'description' ILIKE '%wireless%';
