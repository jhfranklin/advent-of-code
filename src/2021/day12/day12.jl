using AdventOfCode

getinput() = readlines(getinputpath(2021, 12))

function getgraph(input)
    graph = Dict{String,Set{String}}() # adjacency list representation
    for row ∈ input
        l,r = split(row,"-")
        if haskey(graph, l)
            push!(graph[l], r)
        else
            graph[l] = Set([r])
        end
        if haskey(graph, r)
            push!(graph[r], l)
        else
            graph[r] = Set([l])
        end
    end
    return graph
end

issmallcave(s) = all(collect(s) .|> islowercase)

function numpaths(current, visited)
    if current == "end"
        return 1
    elseif current ∈ visited && issmallcave(current)
        return 0
    else
        visited = visited ∪ [current]
        return sum([numpaths(next, visited) for next ∈ graph[current]])
    end
end

function numpaths2(current, visited, visited_twice)
    if current == "end"
        return 1
    elseif current ∈ visited && current == "start"
        return 0
    elseif current ∈ visited && issmallcave(current)
        if !visited_twice
            visited_twice = true
        else
            return 0
        end
    end
    visited = visited ∪ [current]
    return sum([numpaths2(next, visited, visited_twice) for next ∈ graph[current]])
end

global graph = getinput() |> getgraph

part1() = numpaths("start", Set{String}())
part2() = numpaths2("start", Set{String}(), false)

println("part 1: ", part1())
println("part 2: ", part2())
