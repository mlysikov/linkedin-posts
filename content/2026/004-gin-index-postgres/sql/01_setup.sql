\echo 'Setting up ecommerce product demo'

CREATE EXTENSION IF NOT EXISTS pg_trgm;

DROP TABLE IF EXISTS products;

CREATE TABLE products (
  id         bigint    NOT NULL,
  category   text      NOT NULL,
  status     text      NOT NULL,
  attributes jsonb     NOT NULL,
  created_at timestamp NOT NULL
);

INSERT INTO products (id, category, status, attributes, created_at) VALUES
  (
    1,
    'electronics',
    'active',
    '{
      "name": "Mechanical Keyboard",
      "brand": "KeyMaster",
      "tags": ["keyboard", "gaming", "rgb"],
      "description": "Hot-swappable mechanical keyboard with RGB backlight"
    }'::jsonb,
    timestamp '2026-01-01 10:00:00'
  ),
  (
    2,
    'electronics',
    'active',
    '{
      "name": "Wireless Mouse",
      "brand": "Pointer",
      "tags": ["mouse", "wireless", "office"],
      "description": "Silent ergonomic wireless mouse"
    }'::jsonb,
    timestamp '2026-01-02 10:00:00'
  );

INSERT INTO products (id, category, status, attributes, created_at)
SELECT
  gs AS id,
  CASE
    WHEN gs % 10 IN (0, 1, 2, 3) THEN 'electronics'
    WHEN gs % 10 IN (4, 5) THEN 'home'
    WHEN gs % 10 IN (6, 7) THEN 'sports'
    ELSE 'books'
  END AS category,
  CASE
    WHEN gs % 8 = 0 THEN 'inactive'
    ELSE 'active'
  END AS status,
  jsonb_strip_nulls(jsonb_build_object(
    'name',
    CASE
      WHEN gs % 12 = 0 THEN 'Mechanical Keyboard'
      WHEN gs % 11 = 0 THEN 'Wireless Mouse'
      WHEN gs % 9 = 0 THEN 'USB-C Dock'
      WHEN gs % 7 = 0 THEN 'Noise Cancelling Headphones'
      ELSE 'Everyday Product'
    END,
    'brand',
    CASE
      WHEN gs % 13 = 0 THEN 'KeyMaster'
      WHEN gs % 11 = 0 THEN 'Pointer'
      WHEN gs % 7 = 0 THEN 'SoundPeak'
      ELSE 'Northwind'
    END,
    'tags',
    CASE
      WHEN gs % 12 = 0 THEN jsonb_build_array('keyboard', 'gaming', 'rgb')
      WHEN gs % 11 = 0 THEN jsonb_build_array('mouse', 'wireless', 'office')
      WHEN gs % 9 = 0 THEN jsonb_build_array('usb-c', 'dock', 'office')
      WHEN gs % 7 = 0 THEN jsonb_build_array('audio', 'wireless', 'travel')
      ELSE jsonb_build_array('standard', 'catalog', 'demo')
    END,
    'description',
    CASE
      WHEN gs % 97 = 0 THEN 'Portable wireless charger with braided cable and fast USB-C support'
      WHEN gs % 89 = 0 THEN 'Silent ergonomic wireless mouse for office desks'
      WHEN gs % 83 = 0 THEN 'Noise-cancelling wireless headphones with long battery life'
      WHEN gs % 12 = 0 THEN 'Hot-swappable mechanical keyboard with RGB backlight'
      WHEN gs % 9 = 0 THEN 'Compact USB-C docking station for laptops and monitors'
      ELSE 'Durable product with standard accessories and everyday build quality'
    END,
    'promo',
    CASE
      WHEN gs % 997 = 0 THEN 'summer-sale'
      ELSE NULL
    END
  )) AS attributes,
  timestamp '2026-01-01 00:00:00' + ((gs % 180) * interval '1 day') AS created_at
FROM generate_series(3, 300000) AS gs;

ANALYZE products;

\echo 'Rows loaded'

SELECT
  COUNT(*) AS total_products,
  COUNT(*) FILTER (
    WHERE
      category = 'electronics'
      AND status = 'active'
  ) AS active_electronics,
  COUNT(*) FILTER (
    WHERE
      category = 'electronics'
      AND status = 'active'
      AND attributes ->> 'description' ILIKE '%wireless%'
  ) AS active_electronics_wireless
FROM products;
