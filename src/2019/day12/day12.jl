using AdventOfCode

getinput(sample=false) = readlines(getinputpath(2019, 12, sample))

mutable struct Moon
    position::Tuple{Int,Int,Int}
    velocity::Tuple{Int,Int,Int}
    Moon(pos) = new(pos, (0,0,0))
    Moon(x,y,z) = new((x,y,z),(0,0,0))
end

function parserow(row)
    data = [parse(Int,x.match) for x ∈ eachmatch(r"[\+-]?(?:\d*\.)?\d+",row)]
    return Moon(Tuple(data))
end

parseinput(input) = parserow.(input)

getvelocityadjustment(moon1::Moon, moon2::Moon) = sign.(moon1.position .- moon2.position)

function adjustmoon!(moon::Moon,adjustment::Tuple{Int,Int,Int})
    moon.velocity = moon.velocity .+ adjustment
    moon.position = moon.position .+ moon.velocity
    return moon
end

function updateallmoons!(moon_vector::Vector{Moon})
    velocity_adjustments = [(0,0,0) for i ∈ 1:length(moon_vector)]
    for i ∈ 1:length(moon_vector)-1
        for j ∈ (i+1):length(moon_vector)
            adj = getvelocityadjustment(moon_vector[i], moon_vector[j])
            velocity_adjustments[i] = velocity_adjustments[i] .- adj
            velocity_adjustments[j] = velocity_adjustments[j] .+ adj
        end
    end
    for i ∈ 1:length(moon_vector)
        adjustmoon!(moon_vector[i], velocity_adjustments[i])
    end
    return moon_vector
end

function energy(moon::Moon)
    pot = sum(abs.(moon.position))
    kin = sum(abs.(moon.velocity))
    return pot * kin
end

energy(moon_vector::Vector{Moon}) = sum(energy.(moon_vector))

function runsystem!(moon_vector::Vector{Moon}, steps::Int=10)
    for t ∈ 1:steps
        updateallmoons!(moon_vector)
    end
    return energy(moon_vector)
end

function part1()
    return runsystem!(parseinput(getinput()),1000)
end

function findmatch(moon_vector::Vector{Moon}, dim::Int)
    num_steps = 1
    original_system = [(moon.position[dim],moon.velocity[dim]) for moon ∈ moon_vector]
    updateallmoons!(moon_vector)
    current_system = [(moon.position[dim],moon.velocity[dim]) for moon ∈ moon_vector]
    while original_system != current_system
        updateallmoons!(moon_vector)
        current_system = [(moon.position[dim],moon.velocity[dim]) for moon ∈ moon_vector]
        num_steps += 1
    end
    return num_steps
end

function part2()
    input = getinput()
    dim_loops = [findmatch(parseinput(input), dim) for dim ∈ 1:3]
    return lcm(dim_loops)
end

println("part 1: ", part1())
println("part 2: ", part2())