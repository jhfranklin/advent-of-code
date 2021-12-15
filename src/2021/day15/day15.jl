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
    distance = ones(Int,grid_size...) * ∞
    #previous = Dict{CartesianIndex{2},CartesianIndex{2}}()
    distance[source] = 0
    while length(unvisited) > 0
        println(length(unvisited))
        cur_min = ∞
        u = CartesianIndex(0,0)
        for node ∈ unvisited
            if distance[node] < cur_min
                cur_min = distance[node]
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
                alternative = distance[u] + grid[v]
                if alternative < distance[v]
                    distance[v] = alternative
                    #previous[v] = u
                end
            end
        end
    end
    return distance
end

function part1()
    grid = getinput()
    return dijkstra(grid)[end,end]
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
    return dijkstra(wrapped_grid)[end,end]
end

part1()
part2()