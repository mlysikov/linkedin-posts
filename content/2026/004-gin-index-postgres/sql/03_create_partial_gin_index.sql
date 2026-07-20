\echo 'Creating the partial GIN trigram index used in the post'

CREATE EXTENSION IF NOT EXISTS pg_trgm;

CREATE INDEX IF NOT EXISTS products_description_trgm_idx
ON products
USING gin (
  (attributes ->> 'description') gin_trgm_ops
)
WHERE
  category = 'electronics'
  AND status = 'active';

ANALYZE products;

SELECT
  'products_description_trgm_idx' AS index_name,
  pg_size_pretty(pg_relation_size('products_description_trgm_idx')) AS index_size;
