using AdventOfCode

getInput() = readlines(getinputpath(2020,8))

mutable struct Instruction
    type::String
    parameter::Int
    executed::Bool
end

function parseInput(row::String)
    m = match(r"(\w+) (.+)", row)
    type = m.captures[1]
    parameter = parse(Int,m.captures[2])
    return Instruction(type, parameter, false)
end

function findLoop(input)
    pointer = 1
    accumulator = 0
    foundLoop = false
    terminated = false
    while !foundLoop
        if pointer > length(input)
            terminated = true
            break
        end
        ins = input[pointer]
        if ins.executed
            foundLoop = true
            break
        else
            ins.executed = true
        end
        if ins.type == "acc"
            accumulator += ins.parameter
            pointer += 1
        elseif ins.type == "jmp"
            pointer += ins.parameter
        else # nop
            pointer += 1
        end
    end
    return (accumulator,terminated)
end

function part1()
    input = getInput() .|> parseInput
    return findLoop(input)[1]
end

function part2()
    corruptedInput = getInput() .|> parseInput
    finalAcc = 0
    for (i, row) in enumerate(corruptedInput)
        if row.type == "jmp"
            newInput = deepcopy(corruptedInput)
            newInput[i].type = "nop"
            run = findLoop(newInput)
            if run[2]
                finalAcc = run[1]
                break
            end
        elseif row.type == "nop"
            newInput = deepcopy(corruptedInput)
            newInput[i].type = "jmp"
            run = findLoop(newInput)
            if run[2]
                finalAcc = run[1]
                break
            end
        end
    end
    return finalAcc
end

println("part 1: ", part1())
println("part 2: ", part2())
