using LinearAlgebra
using BenchmarkTools
using Random

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

    for n in sizes
        a = randn(rng, ComplexF64, n)
        b = randn(rng, ComplexF64, n)
        w = rand(rng, Float64, n)

        for method in methods
            println("Benchmarking n = $n, method: $(typeof(method))")
            display(@benchmark diagonal_inner_product($a, $b, $w, $method))
        end
    end
end

benchmark()
