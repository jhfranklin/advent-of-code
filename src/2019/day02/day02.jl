using AdventOfCode

numParamsByOpcode = Dict(1 => 3, 2 => 3, 99 => 0)

mutable struct Intcode
    program::Vector{Int}
    pointer::Int
    finished::Bool
    Intcode(program::Vector{Int}) = new(program, 0, false)
end

function getprogram(sample=false)
    rawInput = readline(getinputpath(2019, 2, sample))
    input = parse.(Int,split(rawInput, ","))
    return Intcode(input)
end

function nextstep!(intcode::Intcode)
    opcode = intcode.program[intcode.pointer+1]
    numParams = numParamsByOpcode[opcode]
    positions = intcode.program[intcode.pointer+2:intcode.pointer+1+numParams]
    parameters = [intcode.program[x+1] for x in positions]
    if opcode == 1 # x+y
        result = parameters[1] + parameters[2]
        intcode.program[positions[3]+1] = result
    elseif opcode == 2 # x*y
        result = parameters[1] * parameters[2]
        intcode.program[positions[3]+1] = result
    elseif opcode == 99 # finish
        intcode.finished = true
    end
    intcode.pointer += numParams + 1
    return intcode.finished
end

function executeprogram!(intcode, noun, verb)
    intcode.program[2] = noun
    intcode.program[3] = verb
    while !intcode.finished
        nextstep!(intcode)
    end
    return intcode.program[1]
end

function part1()
    ic = getprogram()
    return executeprogram!(ic,12,2)
end
part1()

function part2()
    target = 19690720
    for noun ∈ 0:99, verb ∈ 0:99
        ic = getprogram()
        executeprogram!(ic, noun, verb)
        if ic.program[1] == target
            return 100 * noun + verb
        end
    end
end


println("part 1: ", part1())
println("part 2: ", part2())
