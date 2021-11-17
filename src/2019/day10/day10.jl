using AdventOfCode
import Base.-

struct Asteroid
    x::Int
    y::Int
end

struct Angle
    direction::Rational
    above::Bool
end

-(a::Asteroid, b::Asteroid) = Asteroid(a.x - b.x, a.y - b.y)

getinput(sample=false) = readlines(getinputpath(2019, 10, sample))

function parseinput(input_data)
    num_rows = length(input_data)
    num_cols = length(first(input_data))
    map = BitArray(undef,num_rows,num_cols)
    for (i,line) ∈ enumerate(input_data)
        map[i,:] = collect(line) .== '#'
    end
    return map
end

getasteroidlocations(bit_map) = Set([Asteroid(idx[2]-1, idx[1]-1) for idx ∈ CartesianIndices(bit_map) if bit_map[idx]])

function converttoangle(base,asteroid_to_test)
    sight_vector = asteroid_to_test - base
    return Angle(sight_vector.x // sight_vector.y, sight_vector.y<0)
end

function part1()
    asteroids = getinput() |> parseinput |> getasteroidlocations
    num_detected = Dict{Asteroid,Int}()
    for base ∈ asteroids
        sight_angles = Set{Angle}()
        for tester ∈ setdiff(asteroids, [base])
            converttoangle(base, tester)
            push!(sight_angles, converttoangle(base, tester))
        end
        num_detected[base] = length(sight_angles)
    end
    return maximum(values(num_detected))
end

println("part 1: ", part1())
#println("part 2: ", part2())