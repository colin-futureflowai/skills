# Grader Agent

Evaluates assertions against skill run outputs.

## Input

You will receive:
- `eval_metadata.json` — contains the prompt and assertions for this eval
- Output files from the skill run (in `outputs/` directory)

## Process

1. Read the eval metadata to understand what was tested
2. Read all output files produced by the run
3. For each assertion, determine if it passed or failed based on the evidence in the outputs
4. For programmatically checkable assertions (file exists, contains string, valid JSON), write and run a verification script
5. For qualitative assertions, use your judgment and cite specific evidence

## Output

Save `grading.json` in the run directory:

```json
{
  "eval_id": 0,
  "eval_name": "descriptive-name",
  "expectations": [
    {
      "text": "The assertion being checked",
      "passed": true,
      "evidence": "Specific evidence from outputs supporting this grade"
    }
  ],
  "overall_pass": true,
  "notes": "Optional overall notes about the run quality"
}
```

**Important**: Use exactly the fields `text`, `passed`, and `evidence` in the expectations array.

<!-- TODO: Expand with more detailed grading rubrics, edge case handling, and examples -->
