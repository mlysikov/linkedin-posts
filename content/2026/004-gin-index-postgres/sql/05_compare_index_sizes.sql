\echo 'Comparing partial GIN trigram index with a full GIN trigram index'

CREATE EXTENSION IF NOT EXISTS pg_trgm;

CREATE INDEX IF NOT EXISTS products_description_trgm_idx
ON products
USING gin (
  (attributes ->> 'description') gin_trgm_ops
)
WHERE
  category = 'electronics'
  AND status = 'active';

DROP INDEX IF EXISTS products_description_full_trgm_idx;

CREATE INDEX products_description_full_trgm_idx
ON products
USING gin (
  (attributes ->> 'description') gin_trgm_ops
);

SELECT
  c.relname AS index_name,
  pg_size_pretty(pg_relation_size(c.oid)) AS index_size,
  pg_relation_size(c.oid) AS bytes
FROM pg_class AS c
WHERE
  c.relname IN (
    'products_description_trgm_idx',
    'products_description_full_trgm_idx'
  )
ORDER BY
  pg_relation_size(c.oid);

DROP INDEX IF EXISTS products_description_full_trgm_idx;
