using AdventOfCode

getinput() = readlines(getinputpath(2021, 6))

function answer(n)
    input = getinput()[1] |> x->split(x,",") .|> x->parse(Int,x)
    school = [count(isequal(i), input) for i ∈ 0:8]
    for day ∈ 1:n
        num_zeros = popfirst!(school)
        school[7] += num_zeros
        push!(school, num_zeros)
    end
    return sum(school)
end

println("part 1: ", answer(80))
println("part 2: ", answer(256))
