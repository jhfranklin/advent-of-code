using AdventOfCode

getinput() = (readlines(getinputpath(2021, 15)) .|> collect .|> x->parse.(Int,x)) |> x->hcat(x...) |> permutedims

const ∞ = typemax(Int)
const di = CartesianIndex(1,0)
const dj = CartesianIndex(0,1)

function dijkstra(grid)
    source = CartesianIndex(1,1)
    grid_size = size(grid)
    target = CartesianIndex(grid_size...)
    unvisited = Set(CartesianIndices(grid))
    distance = Dict{CartesianIndex{2},Int}()
    distance[source] = 0
    while length(unvisited) > 0
        cur_min = ∞
        u = CartesianIndex(0,0)
        for node ∈ unvisited
            if get(distance,node,∞) < cur_min
                cur_min = get(distance,node,∞)
                u = node
            end
        end
        setdiff!(unvisited, [u])
        neighbours = [u + di, u - di, u + dj, u - dj]
        if u == target
            break
        end
        for v ∈ neighbours
            if v ∈ unvisited
                alternative = get(distance,u,∞) + grid[v]
                if alternative < get(distance,v,∞)
                    distance[v] = alternative
                end
            end
        end
    end
    return distance
end

function part1()
    grid = getinput()
    return dijkstra(grid)[CartesianIndex(100,100)]
end

function part2()
    initial_grid = getinput()
    # create first row
    row = initial_grid
    for c ∈ 2:5
        row = hcat(row, (c-1) .+ initial_grid)
    end
    grid = row
    for r ∈ 2:5
        grid = vcat(grid, (r-1) .+ row)
    end
    wrapped_grid = mod1.(grid,9)
    return dijkstra(wrapped_grid)[CartesianIndex(500,500)]
end

println("part 1: ", part1())
println("part 2: ", part2())
