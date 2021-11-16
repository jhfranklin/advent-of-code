using AdventOfCode

getinput(sample=false) = readlines(getinputpath(2019, 6, sample))

function orbitmap(input_vector)
    children = Dict{String,Set{String}}()
    parents = Dict{String,String}()
    for row ∈ input_vector
        left,right = split(row,")") .|> string
        if !haskey(children, left)
            children[left] = Set([right])
        else
            push!(children[left], right)
        end
        parents[right] = left
    end
    return children, parents
end

function part1()
    children, parents = getinput() |> orbitmap
    objects_to_check = collect(setdiff(keys(children),keys(parents))) # all objects that don't orbit something else
    num_orbits = Dict{String,Int}()
    while !isempty(objects_to_check)
        current_object = popfirst!(objects_to_check)
        haskey(children, current_object) && append!(objects_to_check, children[current_object])
        if !haskey(parents,current_object)
            num_orbits[current_object] = 0
        else
            num_orbits[current_object] = 1+num_orbits[parents[current_object]]
        end
    end
    return num_orbits |> values |> sum
end

println("part 1: ", part1())
# println("part 2: ", part2())