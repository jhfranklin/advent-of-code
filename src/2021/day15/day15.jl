using AdventOfCode

getinput() = (readlines(getinputpath(2021, 15)) .|> collect .|> x->parse.(Int,x)) |> x->hcat(x...) |> permutedims

const ∞ = typemax(Int)
const di = CartesianIndex(1,0)
const dj = CartesianIndex(0,1)

function astar(grid)
    source = CartesianIndex(1,1)
    grid_size = size(grid)
    target = CartesianIndex(grid_size...)
    function h(coord) # use manhattan distance
        vec = (target - coord)
        return abs(vec[1]) + abs(vec[2])
    end
    open_set = Set([source])
    all_nodes = Set(CartesianIndices(grid))
    g_score = Dict{CartesianIndex{2},Int}()
    f_score = Dict{CartesianIndex{2},Int}()
    g_score[source] = 0
    f_score[source] = g_score[source] + h(source)
    while !isempty(open_set)
        cur_min = ∞
        u = CartesianIndex(0,0)
        for node ∈ open_set
            if get(f_score,node,∞) < cur_min
                cur_min = get(f_score,node,∞)
                u = node
            end
        end
        setdiff!(open_set, [u])
        neighbours = [u + di, u - di, u + dj, u - dj]
        if u == target
            break
        end
        for v ∈ neighbours
            if v ∈ all_nodes
                tentative_g_score = get(g_score,u,∞) + grid[v]
                if tentative_g_score < get(g_score,v,∞)
                    g_score[v] = tentative_g_score
                    f_score[v] = tentative_g_score + h(v)
                    union!(open_set, [v])
                end
            end
        end
    end
    return g_score[target]
end

function dijkstra(grid)
    source = CartesianIndex(1,1)
    grid_size = size(grid)
    target = CartesianIndex(grid_size...)
    unvisited = Set(CartesianIndices(grid))
    distance = Dict{CartesianIndex{2},Int}()
    distance[source] = 0
    while !isempty(unvisited)
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
    return distance[target]
end

function part1()
    grid = getinput()
    return astar(grid)
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
    return astar(wrapped_grid)
end

println("part 1: ", part1())
println("part 2: ", part2())
