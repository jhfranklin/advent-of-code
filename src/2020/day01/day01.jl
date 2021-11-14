using AdventOfCode
using Base.Iterators

getInput() = parse.(Int, readlines(getinputpath(2020,1)))

function part1(input) 
    return [i*j for (i,j) ∈ product(input,input) if i+j == 2020][1]
end

function part2(input)
   input = sort(input)
    for i ∈ input
        for j ∈ input
            j >= (2020 - i) && break
            k = 2020 - (i + j)
            location = searchsortedfirst(input, k)
            input[location] == k && return i*j*k
        end
    end
end

println("part 1: ", part1(getInput()))
println("part 2: ", part2(getInput()))
