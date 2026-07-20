# Postgres GIN Indexes: Use Them on Purpose

Materials for the LinkedIn post: `Postgres GIN Indexes: Use Them on Purpose`.

## Files

- `post.md` - post text and metadata
- `assets/cover.png` - LinkedIn image exported from Figma
- `docker-compose.yml` - PostgreSQL lab environment
- `sql/01_setup.sql` - extension, table, and deterministic ecommerce seed data
- `sql/02_explain_without_index.sql` - `EXPLAIN ANALYZE` before the GIN index exists
- `sql/03_create_partial_gin_index.sql` - partial GIN trigram index used in the post
- `sql/04_explain_with_index.sql` - `EXPLAIN ANALYZE` after the index exists
- `sql/05_compare_index_sizes.sql` - partial index vs full index size comparison
- `sql/06_jsonb_operator_classes.sql` - optional `jsonb_ops` vs `jsonb_path_ops` comparison
- `results/` - captured output from the local verification run

## Run

Start PostgreSQL:

```bash
docker compose up -d
```

Connection settings for DBeaver:

- PostgreSQL: `localhost:5432`, database `demo`, user `demo`, password `Password1`

Wait until the service is healthy:

```bash
docker compose ps
```

The setup script runs automatically on the first start of a fresh volume. To run it manually or reset the table:

```bash
docker compose exec postgres psql -U demo -d demo -f /sql/01_setup.sql
```

Run the demo:

```bash
docker compose exec postgres psql -U demo -d demo -f /sql/02_explain_without_index.sql
docker compose exec postgres psql -U demo -d demo -f /sql/03_create_partial_gin_index.sql
docker compose exec postgres psql -U demo -d demo -f /sql/04_explain_with_index.sql
docker compose exec postgres psql -U demo -d demo -f /sql/05_compare_index_sizes.sql
```

Optional `jsonb` operator class comparison:

```bash
docker compose exec postgres psql -U demo -d demo -f /sql/06_jsonb_operator_classes.sql
```

Reset everything:

```bash
docker compose down -v
```

## What To Look For

Before the index, the plan should use `Seq Scan` because PostgreSQL has no useful access path for `attributes ->> 'description' ILIKE '%wireless%'`.

After the index, the plan should use `Bitmap Index Scan` and `Bitmap Heap Scan`. The index finds candidate row IDs from trigrams, then PostgreSQL fetches the heap rows and rechecks the predicate.

The partial index is smaller than a full trigram index because it only stores rows where:

```sql
category = 'electronics'
AND status = 'active'
```

That is exactly the slice searched by the product query.
