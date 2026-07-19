# How I Get Better Results from OpenAI Codex

Materials for the LinkedIn post: `How I Get Better Results from OpenAI Codex`.

## Files

- `post.md` - post text and metadata
- `assets/cover.png` - LinkedIn image exported from Figma
- `demo/airflow/AGENTS.md` - minimal example of project instructions for Airflow work
- `demo/airflow/.agents/skills/code-review/SKILL.md` - usable Codex Skill for Airflow DAG review

## Run

No Docker Compose environment is required for this post.

Use the demo Skill from the `demo/airflow` directory:

```text
Use $code-review on @path/to/your_dag.py.
```
