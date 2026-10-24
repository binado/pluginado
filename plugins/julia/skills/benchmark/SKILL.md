---
name: benchmark
description: Benchmark Julia code with BenchmarkTools by writing a script to ./.benchmark/<name>.jl, running it, and summarizing each trial's statistics in a table. Use when the user asks to benchmark, time, profile, or compare the speed or allocations of Julia functions or methods, or mentions BenchmarkTools or @benchmark.
---

Write a BenchmarkTools.jl script to `./.benchmark/<benchmark-name>.jl` in the repo root, run it, and report the results. Start from [benchmark_example.jl](assets/benchmark_example.jl) in this skill's directory: it compares several implementations of one function over three input sizes.

## Workflow

1. **Check the environment.** Run `julia --project=. -e 'using BenchmarkTools'` if the repo has a `Project.toml`, otherwise `julia -e 'using BenchmarkTools'`. If it fails, warn the user that BenchmarkTools is not in the active Julia environment, and ask before running `Pkg.add("BenchmarkTools")`. Do not add it without a yes.
2. **Name the benchmark.** Use kebab-case, 2-4 words, that says what is compared, e.g. `diagonal-inner-product-methods`. Create `.benchmark/` if needed.
3. **Write the script** to `.benchmark/<benchmark-name>.jl`. Follow these rules:
   - Put the code under test in functions. Benchmarks in global scope measure dispatch and boxing, not the code.
   - Interpolate every argument into `@benchmark` with `$`, e.g. `@benchmark f($a, $b)`.
   - Build inputs from a fixed seed (`Xoshiro(seed)`) so runs are reproducible.
   - Use explicit sizes, and label each case with a `println` before its `@benchmark`.
   - For code that mutates its inputs, use `setup=` and `evals=1` so each sample starts from the same state.
4. **Run it** from the repo root with `julia --project=. .benchmark/<benchmark-name>.jl` (drop `--project=.` if there is no `Project.toml`). Each case takes about 5 seconds by default, so a script with many cases can take minutes. Set a generous timeout.
5. **Summarize the results.** Report a table with one row per trial:

   | n | method | min | median | mean | allocs | memory |
   | --- | --- | --- | --- | --- | --- | --- |

   Take the values from each `Trial` report (`Time (median)`, `Time (mean ± σ)`, `Range (min … max)`, `Memory estimate`, `allocs estimate`). Keep units as printed.
6. **Explain anything surprising.** If a result is not what you expect, give a likely cause, e.g. a method allocating a temporary array in each call, a size that crosses a cache boundary, GC pauses at large `n`, or a timer too coarse for a case that runs in under a microsecond.
7. **Check the setup.** If the assumptions look weak, propose a specific change to the script and ask before editing it. Look for: globals used inside `@benchmark`, missing `$` interpolation, timings under about 1 µs (the result is mostly noise), a single size where scaling matters, and warm-up or compile time leaking into the numbers.
8. **Report the file path** so the user can rerun it. Do not commit `.benchmark/`, and add files by name as the git rules require.
