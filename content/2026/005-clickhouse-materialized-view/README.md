# ClickHouse Materialized Views Are INSERT Pipelines

Materials for the LinkedIn post: `ClickHouse Materialized Views Are INSERT Pipelines`.

## Files

- `post.md` - LinkedIn post text and metadata
- `assets/cover.png` - LinkedIn image exported from Figma
- `docker-compose.yml` - ClickHouse lab environment
- `sql/01_create_databases.sql` - reset and create the `raw` and `mart` databases
- `sql/02_create_source_table.sql` - create the source `raw.orders` table
- `sql/03_insert_existing_orders_before_mv.sql` - insert rows before the Materialized View exists
- `sql/04_create_target_table.sql` - create the target `mart.daily_sales` table
- `sql/05_create_materialized_view.sql` - create the INSERT-time pipeline
- `sql/06_insert_new_orders.sql` - insert rows that the Materialized View will process
- `sql/07_check_daily_sales.sql` - verify the first automatic aggregation
- `sql/08_insert_more_orders.sql` - insert another batch into the source table
- `sql/09_check_daily_sales_again.sql` - verify that the target table receives the new aggregate rows
- `sql/10_direct_insert_target_table.sql` - show that direct target inserts do not trigger the Materialized View
- `sql/11_update_delete_do_not_replay.sql` - show that source UPDATE and DELETE mutations do not replay aggregate changes
- `sql/12_populate_demo.sql` - isolated `POPULATE` example and production caveat
- `results/verification.txt` - captured output from the local verification run

## Run

Start ClickHouse:

```bash
docker compose up -d
```

Connection settings for DBeaver:

- ClickHouse HTTP: `localhost:8123`
- ClickHouse native: `localhost:9000`
- Database: `demo`
- User: `demo`
- Password: `Password1`

Wait until the service is healthy:

```bash
docker compose ps
```

Run the full demo in order:

```bash
docker compose exec -T clickhouse clickhouse-client --user demo --password Password1 --multiquery --queries-file /sql/01_create_databases.sql
docker compose exec -T clickhouse clickhouse-client --user demo --password Password1 --multiquery --queries-file /sql/02_create_source_table.sql
docker compose exec -T clickhouse clickhouse-client --user demo --password Password1 --multiquery --queries-file /sql/03_insert_existing_orders_before_mv.sql
docker compose exec -T clickhouse clickhouse-client --user demo --password Password1 --multiquery --queries-file /sql/04_create_target_table.sql
docker compose exec -T clickhouse clickhouse-client --user demo --password Password1 --multiquery --queries-file /sql/05_create_materialized_view.sql
docker compose exec -T clickhouse clickhouse-client --user demo --password Password1 --multiquery --queries-file /sql/06_insert_new_orders.sql
docker compose exec -T clickhouse clickhouse-client --user demo --password Password1 --multiquery --queries-file /sql/07_check_daily_sales.sql
docker compose exec -T clickhouse clickhouse-client --user demo --password Password1 --multiquery --queries-file /sql/08_insert_more_orders.sql
docker compose exec -T clickhouse clickhouse-client --user demo --password Password1 --multiquery --queries-file /sql/09_check_daily_sales_again.sql
docker compose exec -T clickhouse clickhouse-client --user demo --password Password1 --multiquery --queries-file /sql/10_direct_insert_target_table.sql
docker compose exec -T clickhouse clickhouse-client --user demo --password Password1 --multiquery --queries-file /sql/11_update_delete_do_not_replay.sql
docker compose exec -T clickhouse clickhouse-client --user demo --password Password1 --multiquery --queries-file /sql/12_populate_demo.sql
```

Reset everything:

```bash
docker compose down -v
```

## What To Look For

The main flow is:

```text
INSERT
      |
      v
raw.orders
      |
      v
Materialized View
      |
      v
mart.daily_sales
```

`raw.orders` stores source ecommerce orders. `mart.daily_sales` stores daily aggregates. The Materialized View itself is the pipeline between them.

Rows inserted before `sql/05_create_materialized_view.sql` are still present in `raw.orders`, but they are not written to `mart.daily_sales`. This is intentional: a ClickHouse Materialized View reacts to future INSERTs.

The target table uses `SummingMergeTree`. Query it with `sum(...) GROUP BY sales_date` for deterministic results because ClickHouse may keep multiple partial rows per day until background merges run.

## Concept Notes

In this demo, the Materialized View is not a persisted query result like many engineers expect from PostgreSQL, Oracle, or SQL Server. It is an INSERT-time transformation from `raw.orders` into `mart.daily_sales`.

The view does not store the mart data when it is created with `TO mart.daily_sales`; the target table stores it. That separation is useful because the target table owns the engine, ordering key, partitioning, TTL, and merge behavior.

Key limitations shown by the scripts:

- only INSERTs into the source table trigger the view
- rows that existed before the view was created are not processed automatically
- direct INSERTs into the target table do not trigger the view
- UPDATE and DELETE mutations on the source table do not replay aggregate corrections
- `POPULATE` is a one-time convenience, not a production backfill strategy

## Production Notes

Use `POPULATE` only when you understand the tradeoff. On ClickHouse `25.8.28`, `POPULATE` cannot be combined with `TO target`; it is demonstrated with an MV that owns its own storage. It performs a one-time read of existing source rows while the Materialized View is created, but concurrent inserts during that window can be missed. For production backfills, prefer a controlled explicit insert:

```sql
INSERT INTO mart.daily_sales
SELECT ...
FROM raw.orders
WHERE created_at < some_cutoff;
```

Then let the Materialized View process new rows after the cutoff.
