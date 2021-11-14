using AdventOfCode

getinput() = parse.(Int, readlines(getinputpath(2019,1)))

function fuel(mass)
    return (mass ÷ 3) - 2
end

function allfuel(mass)
    currentFuel = 0
    while mass > 0
        mass = max(0,fuel(mass))
        currentFuel += mass
    end
    return currentFuel
end

function part1(input)
    return input .|> fuel |> sum
end

function part2(input)
    return input .|> allfuel |> sum
end

println("part 1: ", part1(getinput()))
println("part 2: ", part2(getinput()))
