using AdventOfCode

getInput() = parse.(Int,readlines(getinputpath(2020,9)))

function checksumwindow(input,windowSize=25)
    N = length(input)
    currentNumber = 0
    for i ∈ (windowSize+1):N
        window = input[i-25:i-1]
        currentNumber = input[i]
        searchList = currentNumber .- window
        !any([x ∈ window for x ∈ searchList]) && return currentNumber
    end
end

function findset(input,numtosearch)
    N = length(input)
    i = 1
    j = 2
    while true
        window = input[i:j]
        s = sum(window)
        if s > numtosearch
            i += 1
        elseif s < numtosearch
            j += 1
        else
            return sum(extrema(window))
        end
    end
end

part1() = getInput() |> checksumwindow

function part2()
    input = getInput()
    return findset(input, part1())
end

println("part 1:", part1())
println("part 2:", part2())
