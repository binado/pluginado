---
paths:
  - "**/test_*.py"
---

# Python test style

- Prefer `pytest` over `unittest` (plain `assert` statements, no `self.assertEqual`-style APIs).
- Organize test data as pytest fixtures rather than module-level constants or setup methods.
- Use `pytest.mark.parametrize` for inlined fixtures / batch-style tests instead of hand-rolled loops over cases inside a single test function.
- Use `conftest.py` for fixtures shared across multiple test modules; keep module-local fixtures in the test file that uses them. Place a `conftest.py` at the shallowest directory common to the modules that need it, not at the repo root by default.
- Avoid testing implementation: don't assert `fn(args) == <reimplementation of fn's logic>(args)`. Assert against known/expected values, properties, or behavior instead.
- Avoid mocks and `monkeypatch` unless the test specifically needs to isolate an external dependency (network, filesystem, time, randomness, third-party API). Prefer exercising real code paths.
- Only test code that lives in the package source (e.g. `src/`). Don't write tests for standalone/one-off scripts (CLI entry points, notebooks, migration or data scripts) that live outside the package.

## Additional conventions

- Name tests `test_<unit>_<condition>_<expected outcome>` so failures and `-k` filters are self-explanatory.
- One behavior per test function. Multiple unrelated assertions in one test make failures ambiguous about what broke.
- Use `pytest.raises` for expected exceptions instead of try/except + manual assert.
- Use `pytest.approx` for scalar floating-point comparisons instead of direct `==`. For array/ndarray comparisons, use NumPy's test utilities (e.g. `numpy.testing.assert_allclose`, `assert_array_equal`) instead of `pytest.approx` or manual loops — they give element-wise diffs on failure.
- Use the built-in `tmp_path` / `tmp_path_factory` fixtures for temporary files/dirs instead of the `tempfile` module or manual cleanup.
- Default fixture scope to `function`; only widen to `module`/`session` for genuinely expensive, side-effect-free setup.
- Use `autouse=True` fixtures sparingly — implicit setup makes tests harder to read in isolation.
- Tests must be independent and order-independent; don't rely on state leaked from another test.
- Prefer fixture factories (a fixture that returns a builder function) over class-based `setUp`/`tearDown` when tests need many variations of an object.
