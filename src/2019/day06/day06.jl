using AdventOfCode

getinput(sample=false) = readlines(getinputpath(2019, 6, sample))

function orbitmap(input_vector)
    orbits = Dict{String,Set{String}}()
    for row ∈ input_vector
        left,right = split(row,")") .|> string
        if !haskey(orbits, left)
            orbits[left] = Set([right])
        else
            push!(orbits[left], right)
        end
    end
    return orbits
end

getinput(true) |> orbitmap

function allobjects(orbitmap) # doesn't currently work - needs fixing
    all_keys = orbitmap |> keys |> collect |> (x->union(x...))
    all_values = orbitmap |> values |> collect |> (x->union(x...))
    return union(all_keys, all_values)
end