---
name: python-style
description: Python coding rules — type hints, docstring policy, import order, exception handling. Apply when writing or reviewing Python code in this project.
---

# Python style

- **Type hints required** on public function signatures. Internal helpers may skip if obvious.
- **Format with `ruff format`** (or `black` if pinned). Lint with `ruff check`.
- **Imports**: stdlib → third-party → local, separated by blank lines. `isort`-compatible order.
- **Docstrings**: triple-quote, Google style. Required on modules and public classes/functions; not on trivial methods.
- **No bare `except:`**. Catch specific exception types. Re-raise with `raise … from e` to preserve cause.
- **f-strings** over `.format()` and `%`-formatting.
- **`pathlib.Path`** over `os.path` for new code.
- **Avoid mutable default args** (`def f(x=[])` → `def f(x=None)`).
- **Tests**: `pytest`, files named `test_*.py`, fixtures in `conftest.py`. No `unittest.TestCase` for new tests.
- **Async**: only when there's actual I/O concurrency. Don't `async def` for sync code.
