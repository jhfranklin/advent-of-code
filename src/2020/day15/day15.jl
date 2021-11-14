input = "6,19,0,5,7,13,1"

function parseinput(x)
    return parse.(Int, split(x,','))
end

function getnumber(input, N)
    startingNumbers = parseinput(input)
    numbers = zeros(Int,N)
    # init number array
    for (i, num) ∈ enumerate(startingNumbers)
        numbers[num+1] = i
    end
    currentNumber = 0
    nextNumber = 0
    currentTurn = length(startingNumbers) + 1
    for turn ∈ currentTurn:(N-1)
        if numbers[currentNumber+1] != 0
            nextNumber = turn - numbers[currentNumber+1]
        else
            nextNumber = 0
        end
        numbers[currentNumber+1] = turn
        currentNumber = nextNumber
    end
    return nextNumber
end

println("part 1: ", getnumber(input, 2020))
println("part 2: ", getnumber(input, 30_000_000))