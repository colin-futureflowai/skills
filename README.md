# Claude Code Skills

A collection of custom skills for Claude Code. Each skill is a self-contained module that can be installed and used independently.

## Repository Structure

```
skills/
├── skills/                  # Individual skill packages
│   └── <skill-name>/
│       ├── SKILL.md         # Skill definition (entry point)
│       ├── evals/           # Test cases and evaluation data
│       │   └── evals.json
│       ├── rules/           # Skill rules and configuration
│       │   └── *.md
│       └── assets/          # Optional assets (prompts, templates, data)
├── templates/               # Skill scaffolding templates
│   └── skill-template/
├── scripts/                 # Utility scripts (install, lint, etc.)
├── .claude/                 # Claude Code project config
│   └── CLAUDE.md
└── README.md
```

## Installation

### Install a single skill

```bash
# Copy a skill into your Claude Code settings
cp -r skills/<skill-name> ~/.claude/skills/<skill-name>
```

### Install all skills

```bash
./scripts/install.sh
```

## Available Skills

| Skill | Description | Status |
|-------|-------------|--------|
| [100m-offers-skill](skills/100m-offers-skill/) | Craft irresistible offers using Alex Hormozi's $100M Offers framework | WIP |
| [skill-creator](skills/skill-creator/) | Create new skills, improve existing skills, and test skill quality with evals | WIP |

## Creating a New Skill

The easiest way to create a new skill is to use the **skill-creator** skill:

> "I want to create a new skill for X"

This will walk you through the intent capture, interview, SKILL.md generation, and eval setup.

Alternatively, scaffold manually:

```bash
# Use the template to scaffold a new skill
cp -r templates/skill-template skills/<your-skill-name>
```

Then edit the `SKILL.md` and add your rules in the `rules/` directory.

## Skill Anatomy

Every skill must have:

- **`SKILL.md`** - The main skill definition with YAML frontmatter (`name` and `description`). This is what Claude Code loads.
- **`evals/`** - Test cases for verifying skill quality.
- **`rules/`** - Directory containing rule files that define behavior, constraints, and patterns.

Optional:
- **`agents/`** - Instructions for specialized subagents.
- **`references/`** - Documentation loaded into context as needed.
- **`scripts/`** - Executable code for deterministic tasks.
- **`assets/`** - Prompts, templates, example data, or other supporting files.

## License

MIT
