using AdventOfCode

getinput() = readlines(getinputpath(2021, 7))[1] |> x->split(x,",") .|> x->parse(Int,x)

function part1()
    input = getinput()
    m,n = extrema(input)
    min_distance = typemax(Int)
    for i ∈ m:n
        distance = sum(abs.(input .- i))
        min_distance = min(distance, min_distance)
    end
    return min_distance
end

moves(x) = (x+1)*x ÷ 2

function part2()
    input = getinput()
    m,n = extrema(input)
    min_distance = typemax(Int)
    for i ∈ m:n
        distance = sum(moves.(abs.(input .- i)))
        min_distance = min(distance, min_distance)
    end
    return min_distance
end

println("part 1: ", part1())
println("part 2: ", part2())
