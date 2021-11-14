using AdventOfCode

getInput() = readlines(getinputpath(2020,5))

function convert(input)
    binary = replace(replace(input, r"R|B" => "1"), r"L|F" => "0")
    rowBin = binary[1:end-3]
    colBin = binary[end-2:end]
    y = parse(Int, rowBin, base=2)
    x = parse(Int, colBin, base=2)
    return 8y + x
end

function part1()
    input = getInput()
    return maximum(convert.(input))
end

function part2()
    input = getInput()
    convertedInput = convert.(input)
    sortedIDs = sort(convertedInput)
    diffedIDs = diff(sortedIDs)
    gapLocation = findfirst(isequal(2), diffedIDs)
    return sortedIDs[gapLocation] + 1
end

println("part 1: ", part1())
println("part 2: ", part2())