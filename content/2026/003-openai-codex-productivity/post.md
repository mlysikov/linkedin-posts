---
title: "How I Get Better Results from OpenAI Codex"
slug: "openai-codex-productivity"
status: "draft"
created: "2026-07-19"
published:
language: "en"

topics:
  - ai
  - developer-productivity
  - data-engineering
  - code-review

technologies:
  - openai-codex
  - apache-airflow
  - mcp
  - figma

tags:
  - codex
  - prompts
  - agents-md
  - skills
  - mcp

difficulty: "intermediate"
series:

assets:
  cover: "assets/cover.png"

---

# How I Get Better Results from OpenAI Codex

Codex gets much better when you stop treating it like a chat box and start treating it like an engineer with project context.

The biggest difference is not the model. It’s how much context you give it.

A weak prompt:

```text
Review this Airflow DAG.
```

A better prompt:

```text
Review @path/to/your_dag.py with $code-review.
Focus on idempotency, data interval usage, retries, observability, and test gaps.
Do not rewrite the DAG unless there is a real bug.
Finish with prioritized findings and exact file references.
```

What changed?

The prompt now includes the goal, relevant files, constraints, review criteria, and a clear definition of done.

For large or ambiguous tasks, I switch to Plan Mode first. Codex reads the repo, asks clarifying questions, compares options, and proposes a plan. Only after I confirm the direction does it start implementing. That saves me from the most expensive failure mode: a fast solution to the wrong problem.

Then I move repeated instructions out of the prompt:

- `AGENTS.md` for project rules: commands, architecture, style, review expectations, and "do not touch" constraints.
- Skills for repeatable workflows: code review, release notes, migration plans, incident writeups.
- MCP for external systems: GitHub PRs, Figma designs, Jira tickets, databases, internal docs.

My daily shortcut is simple:

```text
Use @ to point Codex at the exact files.
Use $ to force the right Skill.
```

Example:

```text
Use $code-review on @path/to/your_dag.py
and check any SQL or Python it depends on.
```

One more underrated feature: Continue in New Task. When I am unsure whether to refactor, patch, or add tests first, I branch the context into a new task and explore the option there. The original thread stays clean, and I can compare approaches without losing the reasoning trail.

This is the workflow that made Codex feel less like autocomplete and more like a teammate with a very good memory: precise prompts, Plan Mode for ambiguity, `AGENTS.md` for project defaults, Skills for repeatable expertise, MCP for external context, and task branching for experiments.

What Codex habit has saved you the most time?

#OpenAI #Codex #DataEngineering #SoftwareEngineering #AI
