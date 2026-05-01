---
name: python-testing
description: pytest patterns and rules. Apply when writing, modifying, or running Python tests.
---

# Python testing

- One `test_*.py` per source module, mirroring the package layout.
- Fixtures: in `conftest.py` at the lowest level that needs them. No global fixture sprawl.
- Parametrize repetitive cases via `@pytest.mark.parametrize`.
- Mock at boundaries only (HTTP, FS, time). Never mock the unit under test.
- Use `pytest.raises` for expected exceptions; assert on the exception message when meaningful.
- Use `tmp_path` for filesystem tests; never write to cwd.
- Mark slow tests with `@pytest.mark.slow`; default test run excludes them.
- `pytest -x --ff` for dev; full run in CI.
- Coverage: aim for 80% line, 100% on critical paths. `pytest --cov`.
