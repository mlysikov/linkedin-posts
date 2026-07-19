---
name: code-review
description: Review Apache Airflow DAGs for correctness, data interval semantics, idempotency, retries, task boundaries, observability, and production readiness. Use when asked to review Airflow DAGs, DAG changes, operators, sensors, schedules, backfills, datasets, or orchestration code.
---

# Airflow DAG Code Review

Use this skill to review Airflow DAGs like a production data platform reviewer.

## Workflow

1. Read the target DAG files and any local `AGENTS.md` files that apply.
2. Inspect Python modules, SQL files, shell scripts, or configs referenced by the DAG when they are available.
3. Identify bugs, behavior risks, missing tests, and operational gaps before style comments.
4. Return findings first, ordered by severity, with file and line references when possible.
5. If the user asks for fixes, keep changes narrow and run the relevant checks available in the project.

## Review Focus

- DAG parse safety: no network, database, filesystem-heavy, or time-dependent work at import time.
- Schedule semantics: correct `start_date`, `schedule`, `catchup`, `max_active_runs`, and data interval usage.
- Idempotency: repeated runs for the same partition should produce the same result without duplicates.
- Backfills: historical runs should not read or write "today" by accident.
- Task design: task IDs are stable, dependencies are explicit, and tasks have clear ownership.
- Reliability: retries, retry delay, timeouts, pools, sensors, and concurrency limits are deliberate.
- Observability: logs, alerts, metrics, and failure messages help an operator debug quickly.
- Data quality: row counts, null checks, freshness checks, and reconciliation exist where risk warrants them.
- Tests: pure business logic is testable outside Airflow; DAG import or structure tests exist for critical DAGs.

## Output Format

Use this format unless the user asks for something else:

```text
1. Severity level [P0/P1/P2/P3]: Brief description of the problem.
   Code example:
   What is wrong:
   How to fix:

2. Severity level [P0/P1/P2/P3]: Brief description of the problem.
   Code example:
   What is wrong:
   How to fix:
```

Severity guide:

- `P0`: production outage, data loss, or security issue.
- `P1`: likely incorrect data, failed backfill, or broken schedule.
- `P2`: operational risk, missing guardrail, or important test gap.
- `P3`: maintainability issue or low-risk improvement.

## Example Prompt

```text
Use $code-review on @path/to/your_dag.py.
Focus on idempotency, data interval handling, retries, observability, and test gaps.
Do not rewrite the DAG unless there is a real bug.
```
