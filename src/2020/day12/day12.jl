using AdventOfCode

struct Instruction
    action::Char
    value::Int
end

function parseinput(row)
    action = row[1]
    value = parse(Int, row[2:end])
    return Instruction(action, value)
end

getinput() = getinputpath(2020,12) |> readlines .|> parseinput

function part1()
    input = getinput()
    dir = Dict{Char,Complex}(
        'N'=>0+1im,
        'E'=>1+0im,
        'S'=>0-1im,
        'W'=>-1+0im,
        'F'=>1+0im
    )
    currentLocation = 0+0im
    for row ∈ input
        if row.action == 'L' || row.action == 'R' # rotate boat
            numRotations = row.value ÷ 90
            turnDirection = row.action == 'L' ? 1im : -1im
            totalRotation = turnDirection^(numRotations)
            dir['F'] *= totalRotation
        else # move
            totalMovement = dir[row.action] * row.value
            currentLocation += totalMovement
        end
    end
    return abs(real(currentLocation)) + abs(imag(currentLocation))
end

function part2()
    input = getinput()
    dir = Dict{Char,Complex}(
        'N'=>0+1im,
        'E'=>1+0im,
        'S'=>0-1im,
        'W'=>-1+0im,
    )
    shipLocation = 0+0im
    waypointRelativeLocation = 10+1im
    for row ∈ input
        if row.action == 'F' # move to waypoint
            shipLocation += waypointRelativeLocation * row.value
        elseif row.action == 'L' || row.action == 'R' # rotate waypoint
            numRotations = row.value ÷ 90
            turnDirection = row.action == 'L' ? 1im : -1im
            totalRotation = turnDirection^(numRotations)
            waypointRelativeLocation *= totalRotation
        else # move waypoint
            totalMovement = dir[row.action] * row.value
            waypointRelativeLocation += totalMovement
        end
    end
    return abs(real(shipLocation)) + abs(imag(shipLocation))
end

println("part 1: ", part1())
println("part 2: ", part2())
