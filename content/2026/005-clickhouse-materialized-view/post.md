---
title: "ClickHouse Materialized Views Are INSERT Pipelines"
slug: "clickhouse-materialized-view"
status: "draft"
created: "2026-07-21"
published:
language: "en"

topics:
  - sql
  - databases
  - materialized-views
  - data-warehousing

technologies:
  - clickhouse
  - docker
  - sql

tags:
  - clickhouse
  - materialized-view
  - insert-pipeline
  - dwh
  - aggregations

difficulty: "intermediate"
series:

assets:
  cover: "assets/cover.png"

---

# ⚙️ A ClickHouse Materialized View is not a stored SELECT.

A ClickHouse Materialized View is not a stored SELECT. It is an INSERT pipeline with a misleading name.

That naming trap catches a lot of people coming from PostgreSQL, Oracle, or SQL Server.

🧠 In PostgreSQL and Oracle, a materialized view usually means: "store this query result, then refresh it." In SQL Server, indexed views are maintained by the engine, but they still behave like a constrained, indexed query result.

ClickHouse uses the same words for a different idea.

🚰 When you create a Materialized View with `TO mart.daily_sales`, the view object does not become the place where your data lives. It listens to INSERTs into the source table, runs its SELECT over the inserted block, and writes the result into a target table.

The flow is:

`INSERT -> raw.orders -> Materialized View -> mart.daily_sales`

📦 That target table matters. You choose its engine, partitioning, sorting key, TTL, and aggregation behavior. For daily sales, I usually write into `SummingMergeTree` or `AggregatingMergeTree`, then query it with a final `GROUP BY` because ClickHouse may store several partial aggregate rows before background merges compact them.

📌 The most important practical detail:

✅ The view reacts to new INSERTs only.
❌ It does not scan old rows when you create it.
❌ It does not replay UPDATEs or DELETEs.
❌ It does not wake up when you insert directly into the target table.

I learned this the hard way on an early ClickHouse mart: the MV was correct, but I created it after loading historical data and wondered why the aggregate was empty. Nothing was broken. I had skipped the backfill. 😅

⚠️ ClickHouse also has `POPULATE` for a one-time read of existing rows, but in 25.8 it is not allowed with the `TO target` pattern above. It fills the MV's own storage.

I rarely recommend `POPULATE` in production anyway:

⚠️ concurrent inserts can be missed
⚠️ big source tables make creation expensive
✅ explicit backfills are easier to control

A safer pattern:

1. create the target table
2. create the MV for new data
3. run an explicit backfill with a controlled cutoff

The mental model I use now:

❌ Cached SELECT
✅ Automatic INSERT-time transformation

Once that clicks, ClickHouse MVs become much easier to design: raw events in, pre-aggregated facts out, with storage controlled by the target table.

💬 What was the first ClickHouse feature whose name meant something different than you expected?

📁 Source materials for this post are available in my GitHub repo:
https://github.com/mlysikov/linkedin-posts/tree/main/content/2026/005-clickhouse-materialized-view

#ClickHouse #SQL #DataEngineering #DWH #AnalyticsEngineering
