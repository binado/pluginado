using LinearAlgebra
using BenchmarkTools
using Random
using Statistics

abstract type DiagonalInnerProductMethod end

struct SumMethod <: DiagonalInnerProductMethod end
struct DotMethod <: DiagonalInnerProductMethod end
struct DiagMethod <: DiagonalInnerProductMethod end
struct MapReduceMethod <: DiagonalInnerProductMethod end
struct LoopMethod <: DiagonalInnerProductMethod end

inner_product_integrand(a, b, w) = w .* conj.(a) .* b


diagonal_inner_product(a, b, w, method::SumMethod) = sum(w .* conj.(a) .* b)
diagonal_inner_product(a, b, w, method::DotMethod) = dot(w .* conj.(a), b)
diagonal_inner_product(a, b, w, method::DiagMethod) = dot(conj.(a), Diagonal(w), b)
diagonal_inner_product(a, b, w, method::MapReduceMethod) = mapreduce(inner_product_integrand, +, a, b, w)
diagonal_inner_product(a, b, w, method::LoopMethod) = begin
    result = zero(eltype(a))
    for i in eachindex(a)
        result += w[i] * conj(a[i]) * b[i]
    end
    return result
end

function benchmark(; sizes = (129, 4097, 131072))
    methods = [SumMethod(), DotMethod(), DiagMethod(), MapReduceMethod(), LoopMethod()]
    rng = Xoshiro(37)
    results = []

    for n in sizes
        a = randn(rng, ComplexF64, n)
        b = randn(rng, ComplexF64, n)
        w = rand(rng, Float64, n)

        for method in methods
            println("Benchmarking n = $n, method: $(typeof(method))")
            trial = @benchmark diagonal_inner_product($a, $b, $w, $method)
            display(trial)
            push!(results, (n, nameof(typeof(method)), trial))
        end
    end

    write_csv(replace(@__FILE__, r"\.jl$" => ".csv"), results)
end

# One row per trial, with times in nanoseconds, as in the BenchmarkTools manual.
function write_csv(path, results)
    open(path, "w") do io
        println(io, "n,method,samples,evals,min_ns,median_ns,mean_ns,std_ns,allocs,memory_bytes")
        for (n, method, trial) in results
            fields = (
                n,
                method,
                length(trial.times),
                trial.params.evals,
                minimum(trial).time,
                median(trial).time,
                mean(trial).time,
                std(trial).time,
                trial.allocs,
                trial.memory,
            )
            println(io, join(fields, ","))
        end
    end
    println("Wrote $path")
end

benchmark()
