---
name: skill-creator
description: >
  Create new Claude Code skills from scratch, improve existing skills, and test
  skill quality with evaluation workflows. Use whenever the user wants to create
  a skill, turn a workflow into a skill, write a SKILL.md, build evals, iterate
  on skill quality, or optimize a skill description. Also trigger on "make this
  into a skill", "capture this as a skill", "skill template", "new skill",
  "improve my skill", "test my skill", "skill evals", or any request to package
  a repeatable workflow into a reusable Claude Code skill.
---

# Skill Creator

A skill for creating new skills and iteratively improving them.

At a high level, the process of creating a skill goes like this:

- Decide what you want the skill to do and roughly how it should do it
- Write a draft of the skill
- Create a few test prompts and run claude-with-access-to-the-skill on them
- Help the user evaluate the results both qualitatively and quantitatively
  - While the runs happen in the background, draft some quantitative evals if there aren't any (if there are some, you can either use as is or modify if you feel something needs to change about them). Then explain them to the user.
  - Present results directly in the conversation for the user to review
- Rewrite the skill based on feedback from the user's evaluation
- Repeat until you're satisfied
- Expand the test set and try again at larger scale

Your job when using this skill is to figure out where the user is in this process and then jump in and help them progress through these stages. So for instance, maybe they're like "I want to make a skill for X". You can help narrow down what they mean, write a draft, write the test cases, figure out how they want to evaluate, run all the prompts, and repeat.

On the other hand, maybe they already have a draft of the skill. In this case you can go straight to the eval/iterate part of the loop.

Of course, you should always be flexible and if the user is like "I don't need to run a bunch of evaluations, just vibe with me", you can do that instead.

---

## Repo Conventions

This skill lives in a repo with specific conventions. When creating skills, follow them:

- Every skill lives in `skills/<skill-name>/` (kebab-case names)
- Every skill MUST have a `SKILL.md` as its entry point with YAML frontmatter
- Rules go in `rules/*.md` inside the skill directory
- Skills should be self-contained and independent of each other
- Use `cp -r templates/skill-template skills/<new-skill-name>` as a starting point, then rename `SKILL.md.template` to `SKILL.md`

**Standard skill directory structure:**
```
skills/<skill-name>/
├── SKILL.md          # Required — entry point with YAML frontmatter
├── evals/
│   └── evals.json    # Test cases
├── rules/            # Behavioral rules and constraints
│   └── *.md
├── agents/           # Instructions for specialized subagents
├── references/       # Docs loaded into context as needed
├── scripts/          # Executable code for deterministic tasks
└── assets/           # Templates, icons, fonts used in output
```

After creating a skill, install it with:
```bash
cp -r skills/<skill-name> ~/.claude/skills/<skill-name>
```

---

## Communicating with the User

The skill creator is used by people across a wide range of familiarity with coding jargon. Pay attention to context cues to understand how to phrase your communication. In the default case:

- "evaluation" and "benchmark" are borderline, but OK
- For "JSON" and "assertion" you want to see serious cues from the user that they know what those things are before using them without explaining them

It's OK to briefly explain terms if you're in doubt.

---

## Creating a Skill

### Capture Intent

Start by understanding the user's intent. The current conversation might already contain a workflow the user wants to capture (e.g., they say "turn this into a skill"). If so, extract answers from the conversation history first — the tools used, the sequence of steps, corrections the user made, input/output formats observed. The user may need to fill the gaps, and should confirm before proceeding to the next step.

1. What should this skill enable Claude to do?
2. When should this skill trigger? (what user phrases/contexts)
3. What's the expected output format?
4. Should we set up test cases to verify the skill works? Skills with objectively verifiable outputs (file transforms, data extraction, code generation, fixed workflow steps) benefit from test cases. Skills with subjective outputs (writing style, art) often don't need them. Suggest the appropriate default based on the skill type, but let the user decide.

### Interview and Research

Proactively ask questions about edge cases, input/output formats, example files, success criteria, and dependencies. Wait to write test prompts until you've got this part ironed out.

Check available MCPs — if useful for research (searching docs, finding similar skills, looking up best practices), research in parallel via subagents if available, otherwise inline. Come prepared with context to reduce burden on the user.

### Write the SKILL.md

Based on the user interview, fill in these components:

- **name**: Skill identifier (kebab-case)
- **description**: When to trigger, what it does. This is the primary triggering mechanism — include both what the skill does AND specific contexts for when to use it. All "when to use" info goes here, not in the body. Make descriptions a little bit "pushy" — include extra trigger phrases and contexts to combat undertriggering. For example, instead of "How to build a dashboard", write "How to build a dashboard. Use whenever the user mentions dashboards, data visualization, internal metrics, or wants to display any kind of data, even if they don't explicitly ask for a 'dashboard.'"
- **compatibility**: Required tools, dependencies (optional, rarely needed)
- **the rest of the skill :)**

### Skill Writing Guide

#### Anatomy of a Skill

```
skill-name/
├── SKILL.md (required)
│   ├── YAML frontmatter (name, description required)
│   └── Markdown instructions
└── Bundled Resources (optional)
    ├── scripts/    - Executable code for deterministic/repetitive tasks
    ├── references/ - Docs loaded into context as needed
    └── assets/     - Files used in output (templates, icons, fonts)
```

#### Progressive Disclosure

Skills use a three-level loading system:
1. **Metadata** (name + description) — Always in context (~100 words)
2. **SKILL.md body** — In context whenever skill triggers (<500 lines ideal)
3. **Bundled resources** — As needed (unlimited, scripts can execute without loading)

These word counts are approximate and you can feel free to go longer if needed.

**Key patterns:**
- Keep SKILL.md under 500 lines; if approaching this limit, add hierarchy with clear pointers about where to follow up
- Reference files clearly from SKILL.md with guidance on when to read them
- For large reference files (>300 lines), include a table of contents

**Domain organization**: When a skill supports multiple domains/frameworks, organize by variant:
```
cloud-deploy/
├── SKILL.md (workflow + selection)
└── references/
    ├── aws.md
    ├── gcp.md
    └── azure.md
```
Claude reads only the relevant reference file.

#### Principle of Lack of Surprise

Skills must not contain malware, exploit code, or any content that could compromise system security. A skill's contents should not surprise the user in their intent if described. Don't go along with requests to create misleading skills or skills designed to facilitate unauthorized access, data exfiltration, or other malicious activities. Roleplay-style skills are OK.

#### Writing Patterns

Prefer using the imperative form in instructions.

**Defining output formats** — You can do it like this:
```markdown
## Report structure
ALWAYS use this exact template:
# [Title]
## Executive summary
## Key findings
## Recommendations
```

**Examples pattern** — Include examples. Format like this:
```markdown
## Commit message format
**Example 1:**
Input: Added user authentication with JWT tokens
Output: feat(auth): implement JWT-based authentication
```

### Writing Style

Try to explain to the model why things are important in lieu of heavy-handed musty MUSTs. Use theory of mind and try to make the skill general and not super-narrow to specific examples. Start by writing a draft and then look at it with fresh eyes and improve it.

### Test Cases

After writing the skill draft, come up with 2-3 realistic test prompts — the kind of thing a real user would actually say. Share them with the user: "Here are a few test cases I'd like to try. Do these look right, or do you want to add more?" Then run them.

Save test cases to `evals/evals.json`. Don't write assertions yet — just the prompts. You'll draft assertions in the next step while the runs are in progress.

```json
{
  "skill_name": "example-skill",
  "evals": [
    {
      "id": 1,
      "prompt": "User's task prompt",
      "expected_output": "Description of expected result",
      "files": []
    }
  ]
}
```

See `references/schemas.md` for the full schema (including the `assertions` field, which you'll add later).

## Running and Evaluating Test Cases

This section is one continuous sequence — don't stop partway through.

Put results in `<skill-name>-workspace/` as a sibling to the skill directory. Within the workspace, organize results by iteration (`iteration-1/`, `iteration-2/`, etc.) and within that, each test case gets a directory (`eval-0/`, `eval-1/`, etc.). Create directories as you go.

### Step 1: Spawn all runs (with-skill AND baseline) in the same turn

For each test case, spawn two subagents in the same turn — one with the skill, one without. Launch everything at once so it all finishes around the same time.

**With-skill run:**

```
Execute this task:
- Skill path: <path-to-skill>
- Task: <eval prompt>
- Input files: <eval files if any, or "none">
- Save outputs to: <workspace>/iteration-<N>/eval-<ID>/with_skill/outputs/
- Outputs to save: <what the user cares about>
```

**Baseline run** (same prompt, but the baseline depends on context):
- **Creating a new skill**: no skill at all. Same prompt, no skill path, save to `without_skill/outputs/`.
- **Improving an existing skill**: the old version. Before editing, snapshot the skill (`cp -r <skill-path> <workspace>/skill-snapshot/`), then point the baseline subagent at the snapshot. Save to `old_skill/outputs/`.

Write an `eval_metadata.json` for each test case. Give each eval a descriptive name based on what it's testing. If this iteration uses new or modified eval prompts, create these files for each new eval directory.

```json
{
  "eval_id": 0,
  "eval_name": "descriptive-name-here",
  "prompt": "The user's task prompt",
  "assertions": []
}
```

### Step 2: While runs are in progress, draft assertions

Don't just wait for the runs to finish — use this time productively. Draft quantitative assertions for each test case and explain them to the user. If assertions already exist in `evals/evals.json`, review them and explain what they check.

Good assertions are objectively verifiable and have descriptive names — they should read clearly so someone glancing at the results immediately understands what each one checks. Subjective skills (writing style, design quality) are better evaluated qualitatively — don't force assertions onto things that need human judgment.

Update the `eval_metadata.json` files and `evals/evals.json` with the assertions once drafted.

### Step 3: As runs complete, capture timing data

When each subagent task completes, you receive a notification containing `total_tokens` and `duration_ms`. Save this data immediately to `timing.json` in the run directory:

```json
{
  "total_tokens": 84852,
  "duration_ms": 23332,
  "total_duration_seconds": 23.3
}
```

This is the only opportunity to capture this data — process each notification as it arrives.

### Step 4: Grade, aggregate, and present results

Once all runs are done:

1. **Grade each run** — spawn a grader subagent (or grade inline) that reads `agents/grader.md` and evaluates each assertion against the outputs. Save results to `grading.json` in each run directory. The grading.json expectations array must use the fields `text`, `passed`, and `evidence`. For assertions that can be checked programmatically, write and run a script rather than eyeballing it.

2. **Aggregate results** — manually summarize pass rates and timing across runs. Compare with-skill vs baseline across each eval, noting pass_rate, mean time, and token usage. Save a summary as `benchmark.md` in the iteration directory. (TODO: automated aggregation script)

3. **Do an analyst pass** — read the benchmark data and surface patterns the aggregate stats might hide. Look for:
   - Assertions that always pass regardless of skill (non-discriminating)
   - High-variance evals (possibly flaky)
   - Time/token tradeoffs worth noting

4. **Present results directly in the conversation** — for each test case, show the prompt, the key outputs, grading results, and how with-skill compared to baseline. Give the user a clear summary they can act on.

5. **Ask for feedback** — "How do these results look? Anything you'd change about the skill, or should we iterate on specific test cases?"

### Step 5: Collect feedback

Empty feedback means the user thought it was fine. Focus your improvements on the test cases where the user had specific complaints.

---

## Improving the Skill

This is the heart of the loop. You've run the test cases, the user has reviewed the results, and now you need to make the skill better based on their feedback.

### How to think about improvements

1. **Generalize from the feedback.** We're trying to create skills that can be used a million times across many different prompts. Here you and the user are iterating on only a few examples because it helps move faster. But if the skill works only for those examples, it's useless. Rather than put in fiddly overfitty changes, or oppressively constrictive MUSTs, if there's some stubborn issue, you might try branching out and using different metaphors, or recommending different patterns of working. It's relatively cheap to try and maybe you'll land on something great.

2. **Keep the prompt lean.** Remove things that aren't pulling their weight. Make sure to read the transcripts, not just the final outputs — if it looks like the skill is making the model waste a bunch of time doing things that are unproductive, you can try getting rid of the parts of the skill that are making it do that and seeing what happens.

3. **Explain the why.** Try hard to explain the **why** behind everything you're asking the model to do. Today's LLMs are *smart*. They have good theory of mind and when given a good harness can go beyond rote instructions and really make things happen. Even if the feedback from the user is terse or frustrated, try to actually understand the task and what they actually wrote, and then transmit this understanding into the instructions. If you find yourself writing ALWAYS or NEVER in all caps, or using super rigid structures, that's a yellow flag — reframe and explain the reasoning so that the model understands why the thing you're asking for is important.

4. **Look for repeated work across test cases.** Read the transcripts from the test runs and notice if the subagents all independently wrote similar helper scripts or took the same multi-step approach to something. If all 3 test cases resulted in writing a similar script, that's a strong signal the skill should bundle that script. Write it once, put it in `scripts/`, and tell the skill to use it.

### The iteration loop

After improving the skill:

1. Apply your improvements to the skill
2. Rerun all test cases into a new `iteration-<N+1>/` directory, including baseline runs. If creating a new skill, the baseline is always `without_skill` (no skill). If improving an existing skill, use your judgment on what makes sense as the baseline.
3. Present results in the conversation with comparison to previous iteration
4. Wait for the user to review and provide feedback
5. Read the new feedback, improve again, repeat

Keep going until:
- The user says they're happy
- The feedback is all empty (everything looks good)
- You're not making meaningful progress

---

## Advanced: Blind Comparison

For rigorous A/B comparison between two skill versions — not yet implemented. For now, the human review loop is sufficient.

---

## Description Optimization

The description field in SKILL.md frontmatter is the primary mechanism that determines whether Claude invokes a skill. After creating or improving a skill, offer to optimize the description for better triggering accuracy.

**Manual approach** (automated optimization loop is a TODO):

1. Write 20 eval queries — a mix of 8-10 should-trigger and 8-10 should-not-trigger. Make them realistic and detailed, not abstract. Focus on edge cases. Should-not-trigger queries should be near-misses that share keywords but need something different.

2. Review the eval queries with the user and adjust based on their feedback.

3. Test the current description against each query by reasoning about whether Claude would trigger the skill. Identify failures.

4. Revise the description to fix failures without breaking passing cases. The key insight: Claude only consults skills for tasks it can't easily handle on its own — simple one-step queries may not trigger even with a perfect description.

5. Repeat until the description reliably triggers on the right queries and ignores the wrong ones.

---

## Without Subagents (including Claude.ai)

Everything above assumes you have subagents. If you don't, the core workflow is the same (draft > test > review > improve > repeat), but some mechanics change:

**Running test cases**: No subagents means no parallel execution. For each test case, read the skill's SKILL.md, then follow its instructions to accomplish the test prompt yourself. Do them one at a time. Skip the baseline runs — just use the skill to complete the task as requested.

**Reviewing results**: Present results directly in the conversation. For each test case, show the prompt and the output. If the output is a file, save it and tell the user where it is. Ask for feedback inline.

**Benchmarking**: Skip quantitative benchmarking — it relies on baseline comparisons which aren't meaningful without subagents. Focus on qualitative feedback from the user.

**The iteration loop**: Same as before — improve the skill, rerun the test cases, ask for feedback — just without parallel runs.

---

## Reference Files

The agents/ directory contains instructions for specialized subagents. Read them when you need to spawn the relevant subagent.

- `agents/grader.md` — How to evaluate assertions against outputs (TODO: expand)

The references/ directory has additional documentation:
- `references/schemas.md` — JSON structures for evals.json, grading.json, etc. (TODO: expand)

---

Good luck!
