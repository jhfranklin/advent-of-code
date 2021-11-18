using AdventOfCode

struct Asteroid
    x::Int
    y::Int
end

import Base.-
-(a::Asteroid, b::Asteroid) = Asteroid(a.x - b.x, a.y - b.y)
struct Angle
    direction::Rational
    above::Bool
end

function angle2radians(angle::Angle)
    # aim is to have 0 to 2π clockwise from left
    # if angle.above, then angle is between 0 and π, otherwise π and 2π
    # angle.direction is a rational number, numerator is x, denominator is y
    # need to convert the x and y to have the appropriate sign depending on quadrant
    # quadrant is 1 to 4 from top right, anti-clockwise
    x = numerator(angle.direction)
    y = denominator(angle.direction)
    above = angle.above
    same_sign = sign(x) == sign(y)
    if sign(y) == 0
        if sign(x) > 0
            return π
        else # sign(x) < 0
            return 0.0
        end
    elseif same_sign
        if above
            # quadrant 2
            x = -abs(x)
            y = abs(y)
        else # below
            # quadrant 4
            x = abs(x)
            y = -abs(y)
        end
    else # different sign
        if above
            # quadrant 1
            x = abs(x)
            y = abs(y)
        else # below
            # quadrant 3
            x = -abs(x)
            y = -abs(y)
        end
    end
    angle_from_x = atan(y, x) # atan maps π to -π
    angle_from_station = π - angle_from_x # convert map to 0 to 2π
    return angle_from_station
end

function findnextangle(all_angles, current_angle)
    angles_to_test = setdiff(all_angles, [current_angle])
    angle_collection = collect(angles_to_test)
    rad_dict = Dict{Angle,AbstractFloat}()
    for angle ∈ angle_collection
        rad_dict[angle] = angle2radians(angle) - angle2radians(current_angle)
    end
    filtered_rads = filter(x->x.second>0, rad_dict)
    next_angle = isempty(filtered_rads) ? Angle(-1//0,false) : findmin(filtered_rads)[2]# need to find the min of the positive diffs!
    return next_angle
end

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

distance(asteroid) = sqrt(asteroid.x^2 + asteroid.y^2)

function convert2angle(base,asteroid_to_test)
    sight_vector = asteroid_to_test - base
    if sight_vector.y == 0
        return Angle(sign(sight_vector.x)//0, false)
    else
        return Angle(sight_vector.x // sight_vector.y, sight_vector.y<0)
    end
end

function part1()
    asteroids = getinput() |> parseinput |> getasteroidlocations
    num_detected = Dict{Asteroid,Int}()
    for base ∈ asteroids
        sight_angles = Set{Angle}()
        for tester ∈ setdiff(asteroids, [base])
            convert2angle(base, tester)
            push!(sight_angles, convert2angle(base, tester))
        end
        num_detected[base] = length(sight_angles)
    end
    return maximum(values(num_detected))
end

function part2()
    asteroid_map = getinput() |> parseinput
    asteroids = getasteroidlocations(asteroid_map)
    num_detected = Dict{Asteroid,Int}()
    for base ∈ asteroids
        sight_angles = Set{Angle}()
        for tester ∈ setdiff(asteroids, [base])
            convert2angle(base, tester)
            push!(sight_angles, convert2angle(base, tester))
        end
        num_detected[base] = length(sight_angles)
    end
    station = findmax(num_detected)[2]
    asteroids = setdiff(asteroids,[station])
    all_angles = Set([convert2angle(station, ast) for ast ∈ asteroids if ast != station])
    current_angle = Angle(0//1,true)
    num_asteroids_destroyed = 0
    nearest_asteroid = station
    while num_asteroids_destroyed < 200 && (length(asteroids) != 0)
        asteroids_on_angle = [ast for ast ∈ asteroids if convert2angle(station,ast) == current_angle]
        current_angle = findnextangle(all_angles, current_angle)
        if length(asteroids_on_angle) == 0
            continue
        end
        nearest_asteroid = asteroids_on_angle[findmin(distance.([a-station for a ∈ asteroids_on_angle]))[2]]
        asteroids = setdiff(asteroids, [nearest_asteroid])
        num_asteroids_destroyed += 1
    end
    return nearest_asteroid.x * 100 + nearest_asteroid.y
end

println("part 1: ", part1())
println("part 2: ", part2())