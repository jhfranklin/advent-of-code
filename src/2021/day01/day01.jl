using AdventOfCode

getinput() = readlines(getinputpath(2021, 1)) .|> x->parse(Int,x)

function part1()
    input = getinput()
    return sum(diff(input) .> 0)
end

function part2()
    input = getinput()
    roll = [input[i]+input[i+1]+input[i+2] for i in 1:length(input)-2]
    return sum(diff(roll) .> 0)
end

println("part 1: ", part1())
println("part 2: ", part2())
