using AdventOfCode
mutable struct Intcode
    program::Dict{Int, Int}
    pointer::Int
    finished::Bool
    input_stream::Vector{Int}
    output_stream::Vector{Int}
    waiting::Bool
    relative_base::Int

    function VectorToDict(program::Vector{Int})
        vector_dict = Dict{Int, Int}()
        for (i,v) ∈ enumerate(program)
            vector_dict[i-1] = v
        end
        return vector_dict
    end

    Intcode(program::Vector{Int}) = new(VectorToDict(program), 0, false, [], [], false, 0)
    Intcode(program::Vector{Int},input::Int) = new(VectorToDict(program), 0, false, [input], [], false, 0)
    Intcode(program::Vector{Int},input_stream::Vector{Int}) = new(VectorToDict(program), 0, false, input_stream, [], false, 0)
end

finished(ic::Intcode) = ic.finished

function getprogram(sample=false)
    rawInput = readline(getinputpath(2019, 9, sample))
    data = parse.(Int,split(rawInput, ","))
    return Intcode(data)
end

function getprogram(input::Int,sample=false)
    rawInput = readline(getinputpath(2019, 9, sample))
    data = parse.(Int,split(rawInput, ","))
    return Intcode(data, input)
end

function getprogram(input_stream::Vector{Int},sample=false)
    rawInput = readline(getinputpath(2019, 9, sample))
    data = parse.(Int, split(rawInput, ","))
    return Intcode(data, input_stream)
end

function nextstep!(intcode::Intcode)
    numParamsByOpcode = Dict(1 => 3, 2 => 3, 3 => 1, 4 => 1, 5 => 2, 6 => 2, 7 => 3, 8 => 3, 9 => 1, 99 => 0)
    instruction = lpad(get!(intcode.program,intcode.pointer,0), 5, '0')
    opcode = parse(Int, instruction[4:5])
    numParams = numParamsByOpcode[opcode]
    parameterTypes = parse.(Int, collect(reverse(instruction[4-numParams:3])))
    paramInstructions = [get!(intcode.program, x, 0) for x ∈ collect(intcode.pointer+1:intcode.pointer+numParams)]
    parameters = copy(paramInstructions)
    for i ∈ 1:numParams
        if parameterTypes[i] == 0 # position mode
            parameters[i] = get!(intcode.program,parameters[i],0)
        elseif parameterTypes[i] == 1 # immediate mode
            continue
        elseif parameterTypes[i] == 2 # relative mode
            parameters[i] = get!(intcode.program,intcode.relative_base+parameters[i],0)
        end
    end
    intcode.pointer += numParams + 1
    if opcode == 1 # x+y
        result = parameters[1] + parameters[2]
        intcode.program[paramInstructions[3]] = result
    elseif opcode == 2 # x*y
        result = parameters[1] * parameters[2]
        intcode.program[paramInstructions[3]] = result
    elseif opcode == 3 # input
        if isempty(intcode.input_stream) # wait for input
            intcode.waiting = true
            intcode.pointer -= (numParams + 1) # need to reset the pointer so that input is sent in on restart
            return intcode.finished
        else
            result = pop!(intcode.input_stream)
            intcode.program[paramInstructions[1]] = result
        end
    elseif opcode == 4 # output
        pushfirst!(intcode.output_stream,parameters[1])
    elseif opcode == 5 # jump-if-true
        if parameters[1] != 0
            intcode.pointer = parameters[2]
        end
    elseif opcode == 6 # jump-if-false
        if parameters[1] == 0
            intcode.pointer = parameters[2]
        end
    elseif opcode == 7 # less than
        if parameters[1] < parameters[2]
            intcode.program[paramInstructions[3]] = 1
        else
            intcode.program[paramInstructions[3]] = 0
        end
    elseif opcode == 8 # equals
        if parameters[1] == parameters[2]
            intcode.program[paramInstructions[3]] = 1
        else
            intcode.program[paramInstructions[3]] = 0
        end
    elseif opcode == 9 # adjust relative base
        intcode.relative_base += parameters[1]
    elseif opcode == 99 # finish
        intcode.finished = true
    end
    return intcode.finished
end

function executeprogram!(intcode)
    intcode.waiting = false
    while !intcode.finished && !intcode.waiting
        nextstep!(intcode)
    end
    return intcode.output_stream
end

getprogram(1,false) |> executeprogram!