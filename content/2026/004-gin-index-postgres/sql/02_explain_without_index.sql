\echo 'Plan before creating the GIN trigram index'

DROP INDEX IF EXISTS products_description_trgm_idx;
DROP INDEX IF EXISTS products_description_full_trgm_idx;

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
