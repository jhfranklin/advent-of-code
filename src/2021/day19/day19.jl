using AdventOfCode

getinput() = readlines(getinputpath(2021,19))

function parseinput(input)
    scanners = Dict{Int, Vector{Vector{Int}}}()
    num_rows = length(input)
    current_row = 2
    for scanner ∈ 0:36
        scanners[scanner] = Int[]
        while true
            if current_row > num_rows || input[current_row] == "" 
                break
            end
            point = split(input[current_row],",") .|> c->parse(Int,c)
            push!(scanners[scanner], point)
            current_row += 1
        end
        current_row += 2
    end
    return scanners
end

input = getinput()
parsed = parseinput(input)

manhattan(x,y) = sum(abs.(x - y))

const rotation_matrices = [
    [1 0 0; 0 1 0; 0 0 1],
    [1 0 0; 0 0 -1; 0 1 0],
    [1 0 0; 0 -1 0; 0 0 -1],
    [1 0 0; 0 0 1; 0 -1 0],
    [0 -1 0; 1 0 0; 0 0 1],
    [0 0 1; 1 0 0; 0 1 0],
    [0 1 0; 1 0 0; 0 0 -1],
    [0 0 -1; 1 0 0; 0 -1 0],
    [-1 0 0; 0 -1 0; 0 0 1],
    [-1 0 0; 0 0 -1; 0 -1 0],
    [-1 0 0; 0 1 0; 0 0 -1],
    [-1 0 0; 0 0 1; 0 1 0],
    [0 1 0; -1 0 0; 0 0 1],
    [0 0 1; -1 0 0; 0 -1 0],
    [0 -1 0; -1 0 0; 0 0 -1],
    [0 0 -1; -1 0 0; 0 1 0],
    [0 0 -1; 0 1 0; 1 0 0],
    [0 1 0; 0 0 1; 1 0 0],
    [0 0 1; 0 -1 0; 1 0 0],
    [0 -1 0; 0 0 -1; 1 0 0],
    [0 0 -1; 0 -1 0; -1 0 0],
    [0 -1 0; 0 0 1; -1 0 0],
    [0 0 1; 0 1 0; -1 0 0],
    [0 1 0; 0 0 -1; -1 0 0]
]

function part1()
    input = getinput()
    parsed = parseinput(input)
    known_beacons = [parsed[0]]
    unmapped_scanners = Set(collect(1:length(parsed)-1))
    beacons_match = false
    while !isempty(unmapped_scanners)
        for map ∈ unmapped_scanners
            for group ∈ known_beacons
                new_beacons = parsed[map]
                known_pairwise = Set([manhattan(i,j) for i ∈ group, j ∈ group])
                new_pairwise = Set([manhattan(i,j) for i ∈ new_beacons, j ∈ new_beacons])
                length(intersect(known_pairwise, new_pairwise)) < 66 && continue
                for rotation ∈ rotation_matrices
                    rotated_beacons = [rotation * b for b ∈ new_beacons]
                    for i ∈ group
                        for j ∈ rotated_beacons
                            translation = i - j
                            translated_beacons = [translation + b for b ∈ rotated_beacons]
                            if length(intersect(translated_beacons, group)) >= 12 # beacons match
                                push!(known_beacons, translated_beacons)
                                beacons_match = true
                                break
                            end
                        end
                        beacons_match && break
                    end
                    beacons_match && break
                end
                if beacons_match
                    setdiff!(unmapped_scanners,[map])
                    beacons_match = false
                    break
                end
            end
        end
    end
    return length(Set(vcat(known_beacons...)))
end

function part2()
    input = getinput()
    parsed = parseinput(input)
    known_beacons = [parsed[0]]
    unmapped_scanners = Set(collect(1:length(parsed)-1))
    scanner_positions = Dict{Int,Vector{Int}}(0 => [0,0,0])
    beacons_match = false
    while !isempty(unmapped_scanners)
        for map ∈ unmapped_scanners
            for group ∈ known_beacons
                new_beacons = parsed[map]
                known_pairwise = Set([manhattan(i,j) for i ∈ group, j ∈ group])
                new_pairwise = Set([manhattan(i,j) for i ∈ new_beacons, j ∈ new_beacons])
                length(intersect(known_pairwise, new_pairwise)) < 66 && continue
                for rotation ∈ rotation_matrices
                    rotated_beacons = [rotation * b for b ∈ new_beacons]
                    for i ∈ group
                        for j ∈ rotated_beacons
                            translation = i - j
                            translated_beacons = [translation + b for b ∈ rotated_beacons]
                            if length(intersect(translated_beacons, group)) >= 12 # beacons match
                                scanner_positions[map] = translation
                                push!(known_beacons, translated_beacons)
                                beacons_match = true
                                break
                            end
                        end
                        beacons_match && break
                    end
                    beacons_match && break
                end
                if beacons_match
                    setdiff!(unmapped_scanners,[map])
                    beacons_match = false
                    break
                end
            end
        end
    end
    return maximum([manhattan(a,b) for a ∈ values(scanner_positions), b ∈ values(scanner_positions)])
end

println("part 1: ", part1())
println("part 2: ", part2())
