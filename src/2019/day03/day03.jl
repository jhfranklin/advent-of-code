using AdventOfCode
struct Instruction
    direction::Symbol
    length::Int
    Instruction(x) = new(Symbol(x[1]), parse(Int,x[2:end]))
end

function getinput()
    rawInput = readlines(getinputpath(2019,3))
    rawPaths = split.(rawInput,",")
    paths = [[Instruction.(i) for i in x] for x ∈ rawPaths]
    return paths
end

function instructiontopath(ins)
    directionDict = Dict(
    :R => 1+0im,
    :L => -1+0im,
    :U => 0+1im,
    :D => 0-1im
    )
    direction = directionDict[ins.direction]
    length = ins.length
    return repeat([direction], length)
end

function creategridpath(path)
    individualGridPath = [instructiontopath(ins) for ins in path]
    return accumulate(+, vcat(individualGridPath...))
end

manhattan(port) = abs(real(port)) + abs(imag(port))


function part1()
    paths = getinput()
    gridPaths = creategridpath.(paths)
    intersections = intersect(gridPaths[1], gridPaths[2])
    distances = manhattan.(intersections)
    return minimum(distances)
end

function part2()
    paths = getinput()
    gridPaths = creategridpath.(paths)
    intersections = intersect(gridPaths[1], gridPaths[2])
    locationOfIntersection = [(findfirst(isequal(x),gridPaths[1]),findfirst(isequal(x),gridPaths[2])) for x ∈ intersections]
    combinedLength = [sum(loc) for loc in locationOfIntersection]
    return minimum(combinedLength)
end


println("part 1: ", part1())
println("part 2: ", part2())
