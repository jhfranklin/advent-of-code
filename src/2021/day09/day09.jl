using AdventOfCode

getinput() = (readlines(getinputpath(2021, 9)) .|> collect .|> x->parse.(Int,x)) |> x->hcat(x...) |> permutedims

const di = CartesianIndex(1,0)
const dj = CartesianIndex(0,1)
const ∞ = typemax(Int)

function part1()
    height_map = getinput()
    total = 0
    for cell ∈ CartesianIndices(height_map)
        min_i = min(get(height_map, cell+di, ∞),get(height_map, cell-di, ∞))
        min_j = min(get(height_map, cell+dj, ∞),get(height_map, cell-dj, ∞))
        min_neighbour = min(min_i, min_j)
        if height_map[cell] < min_neighbour
            total += 1+height_map[cell]
        end
    end
    return total
end

function part2()
    height_map = getinput()
    basin_sizes = Int[]
    for cell ∈ CartesianIndices(height_map)
        min_i = min(get(height_map, cell+di, ∞),get(height_map, cell-di, ∞))
        min_j = min(get(height_map, cell+dj, ∞),get(height_map, cell-dj, ∞))
        min_neighbour = min(min_i, min_j)
        if height_map[cell] < min_neighbour # low point
            # use BFS to search
            queue = [cell]
            basin = Set{CartesianIndex{2}}()
            while !isempty(queue)
                point = popfirst!(queue)
                current_height = height_map[point]
                9 > get(height_map, point-di, ∞) > current_height && push!(queue, point-di)
                9 > get(height_map, point+di, ∞) > current_height && push!(queue, point+di)
                9 > get(height_map, point-dj, ∞) > current_height && push!(queue, point-dj)
                9 > get(height_map, point+dj, ∞) > current_height && push!(queue, point+dj)
                push!(basin, point)
            end
            # get basin size
            basin_size = length(basin)
            push!(basin_sizes, basin_size)
        end
    end
    return prod(sort(basin_sizes, rev=true)[1:3])
end

println("part 1: ", part1())
println("part 2: ", part2())
