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
    rawInput = readline(getinputpath(2019, 13, sample))
    data = parse.(Int,split(rawInput, ","))
    return Intcode(data)
end

function getprogram(input::Int,sample=false)
    rawInput = readline(getinputpath(2019, 13, sample))
    data = parse.(Int,split(rawInput, ","))
    return Intcode(data, input)
end

function getprogram(input_stream::Vector{Int},sample=false)
    rawInput = readline(getinputpath(2019, 13, sample))
    data = parse.(Int, split(rawInput, ","))
    return Intcode(data, input_stream)
end

function getmem(intcode::Intcode, parameter::Int, parameter_type::Int)
    if parameter_type == 0 # position mode
        return get!(intcode.program,parameter,0)
    elseif parameter_type == 1 # immediate mode
        return parameter
    elseif parameter_type == 2 # relative mode
        return get!(intcode.program,parameter+intcode.relative_base,0)
    else # unknown
        error("Unknown parameter type "+string(parameter_type))
    end
end

function setmem!(intcode::Intcode, input::Int, parameter::Int, parameter_type::Int)
    if parameter_type == 0 # position mode
        intcode.program[parameter] = input
    elseif parameter_type == 1 # immediate mode
        error("Can't set memory using immediate mode")
    elseif parameter_type == 2 # relative mode
        intcode.program[parameter+intcode.relative_base] = input
    else # unknown
        error("Unknown parameter type "+string(parameter_type))
    end
    return true
end

function nextstep!(intcode::Intcode)
    numParamsByOpcode = Dict(1 => 3, 2 => 3, 3 => 1, 4 => 1, 5 => 2, 6 => 2, 7 => 3, 8 => 3, 9 => 1, 99 => 0)
    instruction = lpad(getmem(intcode,intcode.pointer,0), 5, '0')
    opcode = parse(Int, instruction[4:5])
    numParams = numParamsByOpcode[opcode]
    parameterTypes = parse.(Int, collect(reverse(instruction[4-numParams:3])))
    parameters = [getmem(intcode, x, 0) for x ∈ collect(intcode.pointer+1:intcode.pointer+numParams)]
    intcode.pointer += numParams + 1
    if opcode == 1 # x+y
        result = getmem(intcode,parameters[1],parameterTypes[1]) + getmem(intcode,parameters[2],parameterTypes[2])
        setmem!(intcode,result,parameters[3],parameterTypes[3])
    elseif opcode == 2 # x*y
        result = getmem(intcode,parameters[1],parameterTypes[1]) * getmem(intcode,parameters[2],parameterTypes[2])
        setmem!(intcode,result,parameters[3],parameterTypes[3])
    elseif opcode == 3 # input
        if isempty(intcode.input_stream) # wait for input
            intcode.waiting = true
            intcode.pointer -= (numParams + 1) # need to reset the pointer so that input is sent in on restart
            return intcode.finished
        else
            result = pop!(intcode.input_stream)
            setmem!(intcode,result,parameters[1],parameterTypes[1])
        end
    elseif opcode == 4 # output
        pushfirst!(intcode.output_stream,getmem(intcode,parameters[1],parameterTypes[1]))
    elseif opcode == 5 # jump-if-true
        if getmem(intcode,parameters[1],parameterTypes[1]) != 0
            intcode.pointer = getmem(intcode,parameters[2],parameterTypes[2])
        end
    elseif opcode == 6 # jump-if-false
        if getmem(intcode,parameters[1],parameterTypes[1]) == 0
            intcode.pointer = getmem(intcode,parameters[2],parameterTypes[2])
        end
    elseif opcode == 7 # less than
        if getmem(intcode,parameters[1],parameterTypes[1]) < getmem(intcode,parameters[2],parameterTypes[2])
            setmem!(intcode,1,parameters[3],parameterTypes[3])
        else
            setmem!(intcode,0,parameters[3],parameterTypes[3])
        end
    elseif opcode == 8 # equals
        if getmem(intcode,parameters[1],parameterTypes[1]) == getmem(intcode,parameters[2],parameterTypes[2])
            setmem!(intcode,1,parameters[3],parameterTypes[3])
        else
            setmem!(intcode,0,parameters[3],parameterTypes[3])
        end
    elseif opcode == 9 # adjust relative base
        intcode.relative_base += getmem(intcode,parameters[1],parameterTypes[1])
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

function part1()
    game = getprogram()
    outputs = executeprogram!(game)
    num_blocks = 0
    for (i,v) ∈ enumerate(outputs)
        if mod1(i,3) == 1
            if v == 2
                num_blocks += 1
            end
        end
    end
    return num_blocks
end

function findtile(grid, tile)
    x_pos = -1
    for (i,v) ∈ enumerate(grid)
        if mod1(i,3) == 1 && v == tile
            x_pos = grid[i+2]
            break
        end
    end
    return x_pos
end

function part2()
    game = getprogram()
    game.program[0] = 2 # load quarters
    push!(game.input_stream,0)
    while !game.finished
        outputs = executeprogram!(game)
        ball_position = findtile(outputs, 4)
        paddle_position = findtile(outputs, 3)
        push!(game.input_stream, sign(ball_position-paddle_position))
        if !game.finished
            empty!(outputs)
        end
    end
    return game.output_stream[1]
end

println("part 1: ", part1())
println("part 1: ", part2())