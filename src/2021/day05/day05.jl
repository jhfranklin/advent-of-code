using AdventOfCode

getinput() = readlines(getinputpath(2021, 5))

convertpoint(point) = tuple(parse.(Int,point)...)

function parserow(row)
    points = split(row, " -> ") .|> x->split(x,",")
    from, to = convertpoint.(points)
    return from, to
end

function getpath(from, to, get_diag=false)
    x1 = from[1]
    x2 = to[1]
    y1 = from[2]
    y2 = to[2]
    x_points = x2 > x1 ? (x1:x2) : (x1:-1:x2)
    y_points = y2 > y1 ? (y1:y2) : (y1:-1:y2)
    path_length = max(length(x_points),length(y_points))
    path = Vector{Tuple{Int,Int}}()
    for i ∈ 1:path_length
        if length(x_points) == 1
            push!(path,(x_points[1],y_points[i]))
        elseif length(y_points) == 1
            push!(path,(x_points[i],y_points[1]))
        elseif get_diag # diagonal
            push!(path,(x_points[i],y_points[i]))
        end
    end
    return path
end

function part1()
    input = getinput() .|> parserow
    points = Dict{Tuple{Int,Int},Int}()
    for row ∈ input
        path = getpath(row[1],row[2])
        for point ∈ path
            if haskey(points, point)
                points[point] += 1
            else
                points[point] = 1
            end
        end
    end
    return sum(values(points) .> 1)
end

function part2()
    input = getinput() .|> parserow
    points = Dict{Tuple{Int,Int},Int}()
    for row ∈ input
        path = getpath(row[1],row[2], true)
        for point ∈ path
            if haskey(points, point)
                points[point] += 1
            else
                points[point] = 1
            end
        end
    end
    return sum(values(points) .> 1)
end

println("part 1: ", part1())
println("part 2: ", part2())
