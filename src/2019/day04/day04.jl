input = "234208-765869"

function extra_adj(passwordDigits)
    diffedPassword = diff(passwordDigits)
    currentZeroCount = 0
    for i in 1:length(diffedPassword)
        if diffedPassword[i] == 0
            currentZeroCount += 1
        else
            if currentZeroCount == 1
                return true
            else
                currentZeroCount = 0
            end
        end
    end    
    return currentZeroCount == 1
end

extra_adj(password::Int) = extra_adj(digits(password))

function testpassword(password, part=1)
    passwordDigits = digits(password)
    neverDecreaseTest = all(diff(passwordDigits) .<= 0)
    adjacencyTest = any(diff(passwordDigits) .== 0)
    return neverDecreaseTest && adjacencyTest && (part==1 || extra_adj(passwordDigits))
end

function part1()
    numMatches = 0
    range = parse.(Int,split(input,"-"))
    for currentPassword ∈ range[1]:range[2]
        if testpassword(currentPassword)
            numMatches += 1
        end
    end
    return numMatches
end

function part2()
    numMatches = 0
    range = parse.(Int,split(input,"-"))
    for currentPassword ∈ range[1]:range[2]
        if testpassword(currentPassword, 2)
            numMatches += 1
        end
    end
    return numMatches
end

println("part 1: ", part1())
println("part 2: ", part2())
