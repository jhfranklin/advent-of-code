using AdventOfCode

function getinput(sample=false,part=1) 
    rawInput = readlines(getinputpath(2020,17,sample))
    charInput = collect.(rawInput)
    charSlice = permutedims(hcat(charInput...))
    bitSlice = [x == '#' for x in charSlice]
    return BitArray(part==1 ? bitSlice[:,:,:] : bitSlice[:,:,:,:])
end

function addbuffer(A)
    originalSize = size(A)
    bufferedSize = originalSize .+ 2
    out = falses(bufferedSize) # initialised array
    R = CartesianIndices(A)
    unit = oneunit(first(R))
    window = R .+ unit
    out[window] = A
    return out
end

function nextstep(A)
    A = addbuffer(A)
    out = similar(A)
    R = CartesianIndices(A)
    lbound, ubound = first(R), last(R)
    unit = oneunit(lbound)
    for cell in R
        numNeighbours = 0
        for neighbourCell in max(lbound, cell-unit):min(ubound, cell+unit)
            if neighbourCell != cell
                numNeighbours += A[neighbourCell]
            end
        end
        if A[cell]# active
            if numNeighbours ∈ 2:3
                out[cell] = true
            else
                out[cell] = false
            end
        else # inactive
            if numNeighbours == 3
                out[cell] = true
            else
                out[cell] = false
            end
        end
    end
    return out
end

function part1()
    initialState = getinput()
    N = 6
    currentState = initialState
    for i in 1:N
        currentState = nextstep(currentState)
    end
    return sum(currentState)
end

function part2()
    initialState = getinput(false,2)
    N = 6
    currentState = initialState
    for i in 1:N
        currentState = nextstep(currentState)
    end
    return sum(currentState)
end

println("part 1: ", part1())
println("part 2: ", part2())
