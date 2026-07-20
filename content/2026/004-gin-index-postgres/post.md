---
title: "Postgres GIN Indexes: Use Them on Purpose"
slug: "gin-index-postgres"
status: "draft"
created: "2026-07-20"
published:
language: "en"

topics:
  - sql
  - databases
  - indexing

technologies:
  - postgresql
  - pg_trgm
  - docker

tags:
  - gin-index
  - jsonb
  - partial-index
  - trigram
  - query-plans

difficulty: "intermediate"
series:

assets:
  cover: "assets/cover.png"

---

# Postgres GIN Indexes: Use Them on Purpose

A B-Tree will not save you from `ILIKE '%wireless%'`.

Most PostgreSQL indexing advice starts with B-Tree, and for good reason. It is great for equality, ranges, ordering, joins, and "next N rows".

GIN is for a different question: "which rows contain this thing?"

It is an inverted index. Instead of one sortable value per row, it stores searchable keys extracted from a value. For `jsonb`: keys and values. For arrays: elements. With `pg_trgm`: text trigrams.

The practical rule I use:

- B-Tree for scalar equality, ranges, and sorting.
- GIN for `jsonb @>`, key existence, arrays, full-text search, and substring search with `pg_trgm`.
- For `jsonb`, choose the operator class deliberately: `jsonb_ops` is flexible; `jsonb_path_ops` is smaller for containment, but it does not support key-exists operators like `?`.

Here is the product-search pattern I wish more teams used.

We only search active electronics, so we do not index every product:

```sql
CREATE INDEX IF NOT EXISTS products_description_trgm_idx
ON products
USING gin (
  (attributes ->> 'description') gin_trgm_ops
)
WHERE
  category = 'electronics'
  AND status = 'active';
```

And the query:

```sql
SELECT *
FROM products
WHERE
  category = 'electronics'
  AND status = 'active'
  AND attributes ->> 'description' ILIKE '%wireless%';
```

Without the index, PostgreSQL scans the table, extracts `description` from every `jsonb`, and checks the pattern row by row.

With the index, the plan switches to `Bitmap Index Scan` plus `Bitmap Heap Scan`. GIN finds candidate row IDs using trigrams from "wireless"; then PostgreSQL fetches those rows and rechecks the predicate.

The partial part matters. The index only contains active electronics, so it is smaller, cheaper to update, and faster to search than a full trigram index. The catch: the query predicate must match that slice.

One mistake I learned the slow way: a GIN index on the whole `jsonb` column will not help an `ILIKE` on `attributes ->> 'description'`. That expression is text. Index it with `gin_trgm_ops`, or change the query.

GIN is not a PostgreSQL turbo button. It is a specialized index for specific data types and operators. Used on purpose, it can turn a scan over hundreds of thousands of JSON documents into a small candidate lookup.

Where have you seen GIN help the most: `jsonb`, arrays, full-text search, or trigram search?

#PostgreSQL #SQL #DataEngineering #DatabasePerformance #Indexes
