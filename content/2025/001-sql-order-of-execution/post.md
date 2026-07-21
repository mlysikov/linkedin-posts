---
title: "SQL Order of Execution"
slug: "sql-order-of-execution"
status: "published"
created: "2025-07-01"
published: "2025-07-01"
language: "en"

topics:
  - sql
  - databases

technologies:
  - sql
  - databases

tags:
  - order-of-execution
  - query-processing
  - select
  - joins
  - group-by

difficulty: "beginner"
series:

assets:
  cover: "assets/cover.png"

---

# SQL Order of Execution

Knowing the order in which query blocks are executed can help you write more efficient SQL queries.

💡 Interesting fact: in Oracle Database, the `CONNECT BY` condition is evaluated after `FROM` but before the `WHERE` clause.

Logical order:

1. `FROM` / `JOIN`
2. `CONNECT BY` in Oracle
3. `WHERE`
4. `GROUP BY` / aggregate functions
5. `HAVING`
6. Analytic functions
7. `SELECT`
8. `DISTINCT`
9. `ORDER BY`
10. `LIMIT`

Source materials for this post are available in my GitHub repo:
https://github.com/mlysikov/linkedin-posts/tree/main/content/2025/001-sql-order-of-execution

#SQL #Databases #QueryProcessing #OrderOfExecution #SQLTips