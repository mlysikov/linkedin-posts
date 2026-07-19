# AGENTS.md

## Repository Expectations

- Treat this folder as a minimal example of project instructions for an Apache Airflow repository.
- This demo intentionally keeps only `AGENTS.md` and the `code-review` Skill; do not assume sample DAG files exist here.
- For real DAG reviews, keep DAG files import-safe: no network calls, database queries, or heavy computation at import time.
- Prefer narrow, reviewable feedback over broad rewrites.
- When reviewing DAGs, use `$code-review` and include file references when target files are provided.

## Done Criteria

- DAG code remains deterministic for backfills.
- Partitioned writes are idempotent.
- Task IDs, DAG ID, and schedule changes are called out explicitly.
- Available project checks are run, or the reason they could not be run is stated.
