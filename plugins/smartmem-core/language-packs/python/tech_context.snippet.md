## Python toolchain
- Version: _(set explicitly, e.g. 3.12)_
- Package manager: `uv` (preferred) or `pip` + `pip-tools`
- Lint / format: `ruff check` / `ruff format`
- Type-check: `mypy` (strict mode for new code)
- Test: `pytest`
- LSP: `pyright` (or `pylsp` with plugins)

## Commands
- Install: `uv sync` _(or `pip install -e .`)_
- Test: `pytest`
- Lint: `ruff check . && mypy .`
- Format: `ruff format .`
