using AdventOfCode

struct Instruction
    direction::String
    magnitude::Int
    function Instruction(str::String)
        direction, string_magnitude = split(str, " ")
        magnitude = parse(Int, string_magnitude)
        return new(direction, magnitude)
    end
end

getinput() = readlines(getinputpath(2021, 2)) .|> Instruction

function part1()
    instructions = getinput()
    position = 0
    depth = 0
    for ins ∈ instructions
        if ins.direction == "forward"
            position += ins.magnitude
        elseif ins.direction == "up"
            depth -= ins.magnitude
        else # ins.direction == "down"
            depth += ins.magnitude
        end
    end
    return position * depth
end

function part2()
    instructions = getinput()
    position = 0
    depth = 0
    aim = 0
    for ins ∈ instructions
        if ins.direction == "forward"
            position += ins.magnitude
            depth += aim * ins.magnitude
        elseif ins.direction == "up"
            aim -= ins.magnitude
        else # ins.direction == "down"
            aim += ins.magnitude
        end
    end
    return position * depth
end

println("part 1: ", part1())
println("part 2: ", part2())
