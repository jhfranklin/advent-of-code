using AdventOfCode
mutable struct Intcode
    program::Vector{Int}
    pointer::Int
    finished::Bool
    input_stream::Vector{Int}
    output_stream::Vector{Int}
    Intcode(program::Vector{Int}) = new(program, 0, false, [], [])
    Intcode(program::Vector{Int},input::Int) = new(program, 0, false, [input], [])
end

function getprogram(sample=false, input=1)
    rawInput = readline(getinputpath(2019, 5, sample))
    data = parse.(Int,split(rawInput, ","))
    return Intcode(data, input)
end

function nextstep!(intcode::Intcode)
    numParamsByOpcode = Dict(1 => 3, 2 => 3, 3 => 1, 4 => 1, 99 => 0)
    instruction = lpad(intcode.program[intcode.pointer+1], 5, '0')
    opcode = parse(Int, instruction[4:5])
    numParams = numParamsByOpcode[opcode]
    parameterTypes = parse.(Int, collect(reverse(instruction[4-numParams:3])))
    paramInstructions = intcode.program[intcode.pointer+2:intcode.pointer+1+numParams]
    parameters = copy(paramInstructions)
    for i ∈ 1:numParams
        if parameterTypes[i] == 0 # position mode
            parameters[i] = intcode.program[parameters[i]+1]
        elseif parameterTypes[i] == 1 # immediate mode
            continue
        end
    end
    if opcode == 1 # x+y
        result = parameters[1] + parameters[2]
        intcode.program[paramInstructions[3]+1] = result
    elseif opcode == 2 # x*y
        result = parameters[1] * parameters[2]
        intcode.program[paramInstructions[3]+1] = result
    elseif opcode == 3 # input
        result = pop!(intcode.input_stream)
        intcode.program[paramInstructions[1]+1] = result
    elseif opcode == 4 # output
        push!(intcode.output_stream,parameters[1])
    elseif opcode == 99 # finish
        intcode.finished = true
    end
    intcode.pointer += numParams + 1
    return intcode.finished
end

function executeprogram!(intcode)
    while !intcode.finished
        nextstep!(intcode)
    end
    return intcode.output_stream
end

function part1()
    ic = getprogram()
    outputs = executeprogram!(ic)
    return pop!(outputs)
end

println("part 1: ", part1())
# println("part 2: ", part2())
