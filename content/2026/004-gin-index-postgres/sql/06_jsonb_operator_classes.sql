\echo 'Optional comparison: jsonb_ops vs jsonb_path_ops'

DROP INDEX IF EXISTS products_attributes_jsonb_ops_idx;
DROP INDEX IF EXISTS products_attributes_jsonb_path_ops_idx;

CREATE INDEX products_attributes_jsonb_ops_idx
ON products
USING gin (attributes jsonb_ops);

CREATE INDEX products_attributes_jsonb_path_ops_idx
ON products
USING gin (attributes jsonb_path_ops);

ANALYZE products;

SELECT
  c.relname AS index_name,
  pg_size_pretty(pg_relation_size(c.oid)) AS index_size,
  pg_relation_size(c.oid) AS bytes
FROM pg_class AS c
WHERE
  c.relname IN (
    'products_attributes_jsonb_ops_idx',
    'products_attributes_jsonb_path_ops_idx'
  )
ORDER BY
  pg_relation_size(c.oid);

\echo 'Containment query: both operator classes support @>; planner usually prefers the smaller path_ops index'

EXPLAIN (ANALYZE, BUFFERS)
SELECT COUNT(*)
FROM products
WHERE
  attributes @> '{"name": "Mechanical Keyboard", "brand": "KeyMaster"}'::jsonb;

\echo 'Key-exists query: jsonb_ops supports ?, jsonb_path_ops does not'

EXPLAIN (ANALYZE, BUFFERS)
SELECT COUNT(*)
FROM products
WHERE
  attributes ? 'promo';

DROP INDEX IF EXISTS products_attributes_jsonb_ops_idx;
DROP INDEX IF EXISTS products_attributes_jsonb_path_ops_idx;
