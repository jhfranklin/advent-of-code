using AdventOfCode

getInput() = readlines(getinputpath(2020,7))

function createDict(input)
    bagDict = Dict()
    for row ∈ input
        (bag, inside) = split(row, " bags contain ")
        bagDict[bag] = []
        for inner ∈ split(inside,", ")
            m = match(r"(\d+) (.+) bag",inner)
            m !== nothing && push!(bagDict[bag], (parse(Int,m.captures[1]), m.captures[2]))
        end
    end
    return bagDict
end

function containsGold(colour, bags)
    contents = bags[colour]
    isempty(contents) && return false
    nextToCheck = [x[2] for x ∈ contents]
    any(isequal("shiny gold"), nextToCheck) && return true
    nextContainsGold = [containsGold(col,bags) for col in nextToCheck]
    return any(nextContainsGold)
end

function part1()
    input = getInput()
    bags = createDict(input)
    numContainsGold = 0
    for bag in keys(bags)
        containsGold(bag, bags) && (numContainsGold += 1)
    end
    return numContainsGold
end

function getCost(colour, bags)
    contents = bags[colour]
    isempty(contents) && return 0
    totalOfContents = 0
    for bag in contents
        num = bag[1]
        newColour = bag[2]
        costOfBag = num * (1 + getCost(newColour,bags))
        totalOfContents += costOfBag
    end
    return totalOfContents
end

function part2()
    input = getInput()
    bags = createDict(input)
    return getCost("shiny gold", bags)
end

println("part 1: ", part1())
println("part 2: ", part2())
