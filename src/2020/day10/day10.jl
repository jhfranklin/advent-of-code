using AdventOfCode

getInput() = parse.(Int,readlines(getinputpath(2020,10)))

function part1()
    input = getInput()
    sortedinput = sort(input)
    firstadapter = 1
    prepend!(sortedinput, 0)
    finaladapter = maximum(sortedinput) + 3
    push!(sortedinput, finaladapter)
    diffedinput = diff(sortedinput)
    return count(isequal(1),diffedinput) * (count(isequal(3), diffedinput))
end

function getcontiguousones(input::Vector{Int})
    groups = Int[]
    currentgroupsize = 0
    for i ∈ eachindex(input)
        if input[i] == 1
            currentgroupsize += 1
        elseif input[i-1] == 1
            push!(groups, currentgroupsize)
            currentgroupsize = 0
        end
    end
    return groups
end

function waystoorder(x::Int)
    # assumes maximum is 4
    if x == 1
        return 1
    elseif x == 2
        return 2
    elseif x == 3
        return 4
    elseif x == 4
        return 7
    end
end

function part2()
    input = getInput()
    sortedinput = sort(input)
    firstadapter = 1
    prepend!(sortedinput, 0)
    finaladapter = maximum(sortedinput) + 3
    push!(sortedinput, finaladapter)
    diffedinput = diff(sortedinput)
    contigousgroupsofone = getcontiguousones(diffedinput)
    return contigousgroupsofone .|> waystoorder |> prod
end

println("part 1: ",part1())
println("part 2: ",part2())