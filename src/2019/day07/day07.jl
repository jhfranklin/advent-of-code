using AdventOfCode
mutable struct Intcode
    program::Vector{Int}
    pointer::Int
    finished::Bool
    input_stream::Vector{Int}
    output_stream::Vector{Int}
    waiting::Bool

    Intcode(program::Vector{Int}) = new(program, 0, false, [], [], false)
    Intcode(program::Vector{Int},input::Int) = new(program, 0, false, [input], [], false)
    Intcode(program::Vector{Int},input_stream::Vector{Int}) = new(program, 0, false, input_stream, [], false)
end

finished(ic::Intcode) = ic.finished

function getprogram(input::Int=1,sample=false)
    rawInput = readline(getinputpath(2019, 7, sample))
    data = parse.(Int,split(rawInput, ","))
    return Intcode(data, input)
end

function getprogram(input_stream::Vector{Int},sample=false)
    rawInput = readline(getinputpath(2019, 7, sample))
    data = parse.(Int, split(rawInput, ","))
    return Intcode(data, input_stream)
end

function nextstep!(intcode::Intcode)
    numParamsByOpcode = Dict(1 => 3, 2 => 3, 3 => 1, 4 => 1, 5 => 2, 6 => 2, 7 => 3, 8 => 3, 99 => 0)
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
    intcode.pointer += numParams + 1
    if opcode == 1 # x+y
        result = parameters[1] + parameters[2]
        intcode.program[paramInstructions[3]+1] = result
    elseif opcode == 2 # x*y
        result = parameters[1] * parameters[2]
        intcode.program[paramInstructions[3]+1] = result
    elseif opcode == 3 # input
        if isempty(intcode.input_stream) # wait for input
            intcode.waiting = true
            intcode.pointer -= (numParams + 1) # need to reset the pointer so that input is sent in on restart
            return intcode.finished
        else
            result = pop!(intcode.input_stream)
            intcode.program[paramInstructions[1]+1] = result
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
            intcode.program[paramInstructions[3]+1] = 1
        else
            intcode.program[paramInstructions[3]+1] = 0
        end
    elseif opcode == 8 # equals
        if parameters[1] == parameters[2]
            intcode.program[paramInstructions[3]+1] = 1
        else
            intcode.program[paramInstructions[3]+1] = 0
        end
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

function runamplifier(signal, phase)
    input_stream = [signal, phase]
    ic = getprogram(input_stream)
    return executeprogram!(ic)
end

function testsequence(phase_sequence)
    # Initialise amplifiers
    amplifiers = Vector{Intcode}(undef,5)
    for i ∈ 1:5
        amplifiers[i] = getprogram(phase_sequence[i])
    end
    pushfirst!(amplifiers[1].input_stream, 0) # start signal
    # Run amplifiers until all finished
    current_execution = 1
    while !all(finished.(amplifiers))
        amp = amplifiers[mod1(current_execution, 5)]
        executeprogram!(amp)
        signal = pop!(amp.output_stream)
        next_amp = amplifiers[mod1(1+current_execution, 5)]
        pushfirst!(next_amp.input_stream, signal)
        current_execution += 1
    end
    return pop!(amplifiers[1].input_stream) # signal has already been sent to A's input stream
end

function part1()
    # would prefer an approach with no for loops
    possible_phases = 0:4
    max_signal = 0
    for a ∈ possible_phases
        for b ∈ setdiff(possible_phases, [a])
            for c ∈ setdiff(possible_phases, [a,b])
                for d ∈ setdiff(possible_phases, [a,b,c])
                    e = setdiff(possible_phases, [a,b,c,d])[1]
                    max_signal = max(max_signal,testsequence([a,b,c,d,e]))
                end
            end
        end
    end
    return max_signal
end

function test() # think the problem is the ordering in the input and output streams
    phase_sequence = [9,8,7,6,5]
    amplifiers = Vector{Intcode}(undef,5)
    for i ∈ 1:5
        amplifiers[i] = getprogram(phase_sequence[i], true)
    end
    pushfirst!(amplifiers[1].input_stream, 0) # start signal
    current_execution = 1
    while !all(finished.(amplifiers))
        amp = amplifiers[mod1(current_execution, 5)]
        executeprogram!(amp)
        signal = pop!(amp.output_stream)
        next_amp = amplifiers[mod1(1+current_execution, 5)]
        pushfirst!(next_amp.input_stream, signal)
        current_execution += 1
    end
end

function part2()
    # would prefer an approach with no for loops
    possible_phases = 5:9
    max_signal = 0
    amplifiers = Vector{Intcode}(undef,5)
    for i ∈ 1:5
        amplifiers[i] = getprogram(phase_sequence[i], true)
    end
    pushfirst!(amplifiers[1].input_stream, 0) # start signal
    for a ∈ possible_phases
        for b ∈ setdiff(possible_phases, [a])
            for c ∈ setdiff(possible_phases, [a,b])
                for d ∈ setdiff(possible_phases, [a,b,c])
                    e = setdiff(possible_phases, [a,b,c,d])[1]
                    max_signal = max(max_signal,testsequence([a,b,c,d,e]))
                end
            end
        end
    end
    return max_signal
end

test()

println("part 1: ", part1())
# println("part 2: ", part2())