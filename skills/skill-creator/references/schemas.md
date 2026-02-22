# Schemas Reference

JSON schemas used by the skill-creator evaluation system.

## evals.json

```json
{
  "skill_name": "string — kebab-case skill identifier",
  "evals": [
    {
      "id": "number — unique eval identifier",
      "prompt": "string — the user prompt to test",
      "expected_output": "string — description of expected result",
      "files": ["string — optional input file paths"],
      "assertions": [
        {
          "text": "string — what to check",
          "type": "string — 'programmatic' | 'qualitative'"
        }
      ]
    }
  ]
}
```

## grading.json

```json
{
  "eval_id": "number — matches eval id",
  "eval_name": "string — descriptive name",
  "expectations": [
    {
      "text": "string — the assertion checked",
      "passed": "boolean",
      "evidence": "string — specific evidence from outputs"
    }
  ],
  "overall_pass": "boolean",
  "notes": "string — optional overall notes"
}
```

## timing.json

```json
{
  "total_tokens": "number",
  "duration_ms": "number",
  "total_duration_seconds": "number"
}
```

## eval_metadata.json

```json
{
  "eval_id": "number",
  "eval_name": "string — descriptive name for this eval",
  "prompt": "string — the user's task prompt",
  "assertions": [
    {
      "text": "string — what to check",
      "type": "string — 'programmatic' | 'qualitative'"
    }
  ]
}
```

<!-- TODO: Add benchmark.json schema when aggregation script is implemented -->
