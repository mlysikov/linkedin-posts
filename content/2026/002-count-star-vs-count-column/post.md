---
title: "COUNT(*) vs COUNT(column)"
slug: "count-star-vs-count-column"
status: "draft"
created: "2026-07-17"
published:
language: "en"

topics:
  - sql
  - databases
  - nulls

technologies:
  - postgresql
  - clickhouse
  - oracle
  - docker

tags:
  - count
  - null
  - empty-string
  - sql-aggregates
  - data-quality

difficulty: "beginner"
series:

assets:
  cover: "assets/cover.png"

---

# COUNT(*) vs COUNT(column)

Most posts about `COUNT(*)` vs `COUNT(column)` stop at `NULL`. That part is important, but it is not the whole trap.

`COUNT(*)` and `COUNT(value)` look almost the same, but they answer different questions:

- `COUNT(*)` counts rows.
- `COUNT(value)` counts non-NULL values.

The part I see discussed much less often: empty strings.

Here is a tiny example:

```sql
CREATE TABLE count_demo (
  id    INTEGER,
  value VARCHAR(20)
);

INSERT INTO count_demo (id, value) VALUES
  (1, NULL),
  (2, ''),
  (3, ' '),
  (4, 'SQL');
```

Now compare:

```sql
SELECT
  COUNT(*) AS all_rows,
  COUNT(value) AS non_null_values
FROM count_demo;
```

`COUNT(*)` counts every row in the result. `COUNT(value)` counts only rows where `value` is not `NULL`.

So far, so good. But this is where many reports quietly go wrong: developers treat “non-NULL” as “filled in”.

In PostgreSQL and ClickHouse, `''` is just a normal empty string. It is not `NULL`, so `COUNT(value)` includes it. The same is true for `' '`, a string that contains one space. It may look empty in a UI, but it is still a value.

Oracle is the special case: it treats `''` as `NULL`. So inserting an empty string into a `VARCHAR2` column gives you `NULL`. But `' '` is still not an empty string, and it is still counted.

So this common check is often wrong for data-quality metrics:

```sql
COUNT(value)
```

It answers: “How many values are not NULL?” It does not answer: “How many values are actually filled in?”

For PostgreSQL and ClickHouse, I usually write:

```sql
COUNT(NULLIF(TRIM(value), ''))
```

`TRIM(value)` removes surrounding whitespace. `NULLIF(..., '')` turns the empty result into `NULL`. Then `COUNT(...)` counts only the remaining non-null values.

For Oracle, because `''` is already `NULL`, the equivalent idea is:

```sql
COUNT(CASE WHEN TRIM(value) IS NOT NULL THEN 1 END)
```

The memorable rule:

`COUNT(*)` counts rows.
`COUNT(column)` counts non-NULL values.
If you want filled values, normalize whitespace first.

Have empty strings ever changed a number you thought was just about NULLs?

#SQL #PostgreSQL #ClickHouse #Oracle #DataEngineering
