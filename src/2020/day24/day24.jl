using AdventOfCode

getinput() = readlines(getinputpath(2020,24))

struct HexPoint
    x::Int
    y::Int
    z::Int
end

import Base.+
+(a::HexPoint, b::HexPoint) = HexPoint(a.x + b.x, a.y + b.y, a.z + b.z)
manhattandistance(a::HexPoint) = max(abs(a.x), abs(a.y), abs(a.z))

directions = Dict{String, HexPoint}(
    "ne" => HexPoint(1, 0, -1),
    "e" => HexPoint(1, -1, 0),
    "se" => HexPoint(0, -1, 1),
    "sw" => HexPoint(-1, 0, 1),
    "w" => HexPoint(-1, 1, 0),
    "nw" => HexPoint(0, 1, -1)
)

function parserow(row)
    em = eachmatch(r"(e|se|sw|w|nw|ne)", row)
    return [directions[x.captures[1]] for x in em]
end

function part1()
    input = getinput()
    finalPoints = sum.(parserow.(input))
    counts = Dict{HexPoint, Bool}()
    for point in finalPoints
        flag = get(counts, point, false)
        counts[point] = !flag
    end
    return sum(values(counts))
end

function part2()
    finalPoints = getinput() .|> parserow .|> sum
    # get initial black tiles
    initialBlackTiles = Dict{HexPoint, Bool}()
    for point in finalPoints
        tile = get(initialBlackTiles, point, false)
        initialBlackTiles[point] = !tile
    end
    # current grid size
    maxDistance = maximum(manhattandistance.(finalPoints))

    return maxDistance
end

println("part 1: ", part1())
println("part 2: ", part2())
