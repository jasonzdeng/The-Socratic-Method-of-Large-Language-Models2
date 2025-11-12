# Development Setup

## Quick Start

This project uses `uv` for Python environment management.

```powershell
# Install dependencies
uv sync

# Run tests
uv run pytest

# Run linter
uv run ruff check .
uv run ruff format .

# Run type checker
uv run mypy src/
```

## Pre-commit Hooks

**Note:** Due to Unicode path issues on Windows with Chinese characters, `pre-commit install` may fail. Use the manual check script instead:

```powershell
# Before committing, run:
.\scripts\pre-commit-manual.ps1

# Or run checks individually:
uv run ruff check . --fix
uv run ruff format .
uv run mypy src/
uv run pytest --cov=src --cov-fail-under=0
```

If pre-commit works in your environment:
```powershell
uv run pre-commit install
uv run pre-commit run --all-files
```

## Project Structure

```
.
├── src/                # Source code
│   └── __init__.py
├── tests/              # Test files
│   ├── conftest.py
│   └── test_*.py
├── docs/               # Documentation
├── pyproject.toml      # Project configuration
└── README.md
```

## Standards

- **Python:** Black-compatible formatting (line length 100), Ruff linting, mypy strict mode
- **Tests:** >80% unit coverage, >70% integration coverage
- **Pre-commit:** ruff, mypy (when installable)

See `docs/inputs/PROJECT_CONSTITUTION.md` for complete standards.
