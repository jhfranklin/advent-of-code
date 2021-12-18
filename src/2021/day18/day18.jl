using AdventOfCode

getinput() = readlines(getinputpath(2021,18))

mutable struct Snailfish
    left::Union{Int,Snailfish}
    right::Union{Int,Snailfish}
end

import Base.+
+(left::Snailfish, right::Snailfish) = Snailfish(left, right)

function parsenumber(number)
    depth = 0
    if length(number) == 1
        return parse(Int,number)
    else
        for (i,c) ∈ enumerate(number)
            if c == '['
                depth += 1
            elseif c == ']'
                depth -= 1
            elseif c == ',' && depth == 1
                left = number[2:i-1]
                right = number[i+1:end-1]
                return Snailfish(parsenumber(left),parsenumber(right))
            end
        end
    end
end

function exploder(snailfish::Snailfish, path::Vector{Symbol}=Symbol[])
    if length(path) == 4
        return path
    end
    result = nothing
    if !(snailfish.left isa Int)
        result = exploder(snailfish.left, push!(copy(path),:left))
    end
    !isnothing(result) && return result
    if !(snailfish.right isa Int)
        result = exploder(snailfish.right, push!(copy(path),:right))
    end
    return result
end

function getsnailfish(snailfish::Snailfish, path::Vector{Symbol})
    if isempty(path)
        return snailfish
    else
        if popfirst!(path) == :left
            return getsnailfish(snailfish.left, path)
        else
            return getsnailfish(snailfish.right, path)
        end
    end
end

function setsnailfish!(snailfish::Snailfish, path::Vector{Symbol}, set_to::Int)
    current_dir = popfirst!(path)
    if current_dir == :left
        if isempty(path)
            snailfish.left = set_to
        else
            setsnailfish!(snailfish.left, path, set_to)
        end
    else
        if isempty(path)
            snailfish.right = set_to
        else
            setsnailfish!(snailfish.right, path, set_to)
        end
    end
end

function setnearestleftnum!(snailfish::Snailfish, set_to::Int)
    if snailfish.left isa Int
        snailfish.left += set_to
    else
        setfarthestrightnum!(snailfish.left,set_to)
        return true
    end
end

function setfarthestrightnum!(snailfish::Snailfish,set_to::Int)
    if snailfish.right isa Int
        snailfish.right += set_to
    else
        setfarthestrightnum!(snailfish.right, set_to)
        return true
    end
end

function setnearestrightnum!(snailfish::Snailfish, set_to::Int)
    if snailfish.right isa Int
        snailfish.right += set_to
    else
        setfarthestleftnum!(snailfish.right,set_to)
        return true
    end
end

function setfarthestleftnum!(snailfish::Snailfish,set_to::Int)
    if snailfish.left isa Int
        snailfish.left += set_to
    else
        setfarthestleftnum!(snailfish.left, set_to)
        return true
    end
end

function parentfish(snailfish::Snailfish, path::Vector{Symbol}, direction::Symbol)
    if direction == :left
        parent_path = path[1:findlast(isequal(:right), path[1:end])-1]
    else
        parent_path = path[1:findlast(isequal(:left), path[1:end])-1]
    end
    return getsnailfish(snailfish, parent_path)
end

function explode!(snailfish::Snailfish)
    exploding_fish_path = exploder(snailfish)
    if isnothing(exploding_fish_path)
        return false
    else
        exploding_fish = getsnailfish(snailfish,copy(exploding_fish_path))
        left_value = exploding_fish.left
        right_value = exploding_fish.right
        # do left side
        if !all(exploding_fish_path .== :left)
            setnearestleftnum!(parentfish(snailfish, copy(exploding_fish_path),:left), left_value)
        end
        # do right side
        if !all(exploding_fish_path .== :right)
            setnearestrightnum!(parentfish(snailfish, copy(exploding_fish_path),:right), right_value)
        end
        # change exploding_fish
        setsnailfish!(snailfish,copy(exploding_fish_path),0)
        return true
    end
end

function createsplit(x)
    left = x ÷ 2
    right = x - left
    return Snailfish(left,right)
end

function split!(snailfish::Snailfish)
    if snailfish.left isa Snailfish
        split!(snailfish.left) && return true
    elseif snailfish.left >= 10
        snailfish.left = createsplit(snailfish.left)
        return true
    end
    if snailfish.right isa Snailfish
        split!(snailfish.right) && return true
    elseif snailfish.right >= 10
        snailfish.right = createsplit(snailfish.right)
        return true
    end
    return false
end

function reduce!(snailfish::Snailfish)
    reduced = false
    while !reduced
        reduced = !(explode!(snailfish) || split!(snailfish))
    end
    return reduced
end

magnitude(x::Int) = x
magnitude(snailfish::Snailfish) = 3*magnitude(snailfish.left) + 2*magnitude(snailfish.right)

function part1()
    rows = getinput()
    result = parsenumber(rows[1])
    for row ∈ rows[2:end]
        result += parsenumber(row)
        reduce!(result)
    end
    return magnitude(result)
end

function part2()
    rows = getinput()
    n = length(rows)
    max_magnitude = 0
    for i ∈ 1:n
        for j ∈ 1:n
            if i != j
                left = parsenumber(rows[i])
                right = parsenumber(rows[j])
                answer = left + right
                reduce!(answer)
                max_magnitude = max(max_magnitude, magnitude(answer))
            end
        end
    end
    return max_magnitude
end

println("part 1: ", part1())
println("part 2: ", part2())
