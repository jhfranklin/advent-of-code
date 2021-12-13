using AdventOfCode

getinput() = readlines(getinputpath(2020,24))

struct HexPoint
    x::Int
    y::Int
    z::Int
end

import Base.+
+(a::HexPoint, b::HexPoint) = HexPoint(a.x + b.x, a.y + b.y, a.z + b.z)

directions = Dict{String, HexPoint}(
    "ne" => HexPoint(1, 0, -1),
    "e" => HexPoint(1, -1, 0),
    "se" => HexPoint(0, -1, 1),
    "sw" => HexPoint(-1, 0, 1),
    "w" => HexPoint(-1, 1, 0),
    "nw" => HexPoint(0, 1, -1)
)

neighbours(x::HexPoint) = [x + dir for dir ∈ values(directions)]

function numblacktiles(grid, x)
    num_black_tiles = 0
    for tile ∈ neighbours(x)
        num_black_tiles += get(grid, tile, false)
    end
    return num_black_tiles
end

function extendgrid!(grid)
    start = keys(grid)
    for point ∈ start
        for n ∈ neighbours(point)
            if !haskey(grid,n) && (numblacktiles(grid,n) > 0)
                grid[n] = false
            end
        end
    end
end

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
    grid = Dict{HexPoint, Bool}()
    for point in finalPoints
        tile = get(grid, point, false)
        grid[point] = !tile
    end
    for day ∈ 1:100
        extendgrid!(grid)
        step = Dict{HexPoint, Bool}()
        for (k,v) ∈ grid
            n = numblacktiles(grid,k)
            if v # black tile
                step[k] = (n == 0) || (n > 2)
            else # white tile
                step[k] = (n == 2)
            end
        end
        for (k,v) ∈ step
            grid[k] = (grid[k] ⊻ v)
        end
    end
    return sum(values(grid))
end

println("part 1: ", part1())
println("part 2: ", part2())
