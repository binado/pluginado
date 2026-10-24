---
name: benchmark
description: Benchmark Julia code with BenchmarkTools by writing a script to ./.benchmark/<name>/benchmark.jl, running it, and summarizing each trial's statistics in a table saved as results.md and results.csv. Use when the user asks to benchmark, time, profile, or compare the speed or allocations of Julia functions or methods, or mentions BenchmarkTools or @benchmark.
---

Write a BenchmarkTools.jl script to `./.benchmark/<benchmark-name>/benchmark.jl` in the repo root, run it, and report the results. Each benchmark gets its own directory, so its script, `results.csv` and `results.md` stay together. The template is [benchmark_example.jl](assets/benchmark_example.jl) in this skill's directory.

## Workflow

1. **Create the script.** Run `scripts/new-benchmark-script.sh <benchmark-name>` from this skill's directory. Use kebab-case, 2-4 words, that says what is compared, e.g. `diagonal-inner-product-methods`. The script copies the template to `<repo root>/.benchmark/<benchmark-name>/benchmark.jl` and prints its path. It never overwrites a directory, so if the name is taken, pick another name or ask the user.
2. **Relay its warnings** (on stderr):
   - `BenchmarkTools is not in the active Julia environment`: warn the user and ask before running `Pkg.add("BenchmarkTools")`. Do not add it without a yes.
   - `julia is not on PATH`: stop and tell the user.
   - `.benchmark/ is not gitignored`: suggest adding it to `.gitignore`, and edit the file only if the user says yes.
3. **Adapt the script** at the printed path. The template's setup is only an example. Its sizes, input generation, element types, and the choice to benchmark with `@benchmark` at default settings are placeholders. Before running, make them match the function you are measuring:
   - **Sizes and inputs:** pick sizes that match where the function is used in practice, and make sure the inputs have the right types, shapes, and value ranges (e.g. sparse vs. dense, `Float32` vs. `Float64`, sorted vs. unsorted). A size chosen for a different algorithm can hide the behavior you want to see.
   - **Trial count:** the default `@benchmark` runs until about 5 seconds or the default sample count. Fast functions (well under a microsecond) need `evals` raised so timings aren't dominated by timer resolution, while slow functions may need `samples` or `seconds` lowered so the run finishes in reasonable time. Set `samples=`, `seconds=`, or `evals=` per case when the defaults do not fit.
   - **Setup:** use `setup=` for code that mutates its inputs, with `evals=1` so each sample starts from the same state. Use it for expensive input construction that should not be timed.
   - **Structure rules that always apply:**
     - Put the code under test in functions. Benchmarks in global scope measure dispatch and boxing, not the code.
     - Interpolate every argument into `@benchmark` with `$`, e.g. `@benchmark f($a, $b)`.
     - Build inputs from a fixed seed (`Xoshiro(seed)`) so runs are reproducible.
     - Label each case with a `println` before its `@benchmark`.
   - Keep the `write_csv` and `write_table_md` steps. They write `results.csv` (times in nanoseconds) and `results.md` (a readable table) into the benchmark's directory.
4. **Run it** from the repo root with `julia --project=. .benchmark/<benchmark-name>/benchmark.jl` (drop `--project=.` if there is no `Project.toml`). The run time depends on the trial settings you chose, so a script with many cases can take minutes. Set a generous timeout.
5. **Summarize the results.** Read `.benchmark/<benchmark-name>/results.md` and paste its table into the reply unchanged. It has one row per trial, with the columns min, median, mean, std, allocs and memory. Quote the median as the typical time. The min is the least-noisy lower bound, and the mean moves with outliers. Use `results.csv` only for analysis the table does not cover. For the full sample distribution, use `BenchmarkTools.save` and `BenchmarkTools.load` on the trials.
6. **Explain anything surprising.** If a result is not what you expect, give a likely cause, e.g. a method allocating a temporary array in each call, a size that crosses a cache boundary, GC pauses at large `n`, or a timer too coarse for a case that runs in under a microsecond.
7. **Check the setup.** If the assumptions look weak, propose a specific change to the script and ask before editing it. Look for: globals used inside `@benchmark`, missing `$` interpolation, timings under about 1 µs (the result is mostly noise), a single size where scaling matters, inputs that do not represent real use, trial counts too low to give a stable median, and warm-up or compile time leaking into the numbers.
8. **Report the file path** so the user can rerun it, e.g. `.benchmark/<benchmark-name>/benchmark.jl`. Do not commit `.benchmark/`, and add files by name as the git rules require.
