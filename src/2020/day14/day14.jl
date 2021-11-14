using AdventOfCode

getinput() = readlines(getinputpath(2020,14))

function applymask(value, mask)
    originalBinary = string(parse(Int,value), base=2, pad=36)
    newBinary = ""
    for i ∈ 1:36
        if mask[i] == 'X'
            newBinary *= originalBinary[i]
        else
            newBinary *= mask[i]
        end
    end
    return parse(Int, newBinary, base=2)
end

function applymaskv2(value, mask)
    originalBinary = string(parse(Int,value), base=2, pad=36)
    numberOfXs = count(isequal('X'), mask)
    numberOfAddresses = 2^numberOfXs
    addressArray = Array{Int}(undef, numberOfAddresses)
    for addressIndex ∈ 1:numberOfAddresses
        perm = string(addressIndex-1, base=2, pad=numberOfXs)
        currentX = 1
        newBinary = ""
        for i ∈ 1:36
            if mask[i] == '0'
                newBinary *= originalBinary[i]
            elseif mask[i] == '1'
                newBinary *= '1'
            else
                newBinary *= perm[currentX]
                currentX += 1
            end
        end
        addressArray[addressIndex] = parse(Int, newBinary, base=2)
    end
    return addressArray
end

function part1(rawinput)
    rx = r"(\w+)\[?(\d*)\]? = (.+)"
    input = [match(rx, row) for row ∈ rawinput]
    memory = Dict{Int,Int}()
    mask = (value) -> 1
    for row ∈ input
        (type, address, value) = row.captures
        if type == "mask"
            mask(x) = applymask(x, value)
        else
            memory[parse(Int,address)] = mask(value)
        end
    end
    return sum(values(memory))
end

function part2(rawinput)
    rx = r"(\w+)\[?(\d*)\]? = (.+)"
    input = [match(rx, row) for row ∈ rawinput]
    memory = Dict{Int,Int}()
    mask = (value) -> 1
    for row ∈ input
        (type, address, value) = row.captures
        if type == "mask"
            mask(x) = applymaskv2(x, value)
        else
            addresses = mask(address)
            for a ∈ addresses
                memory[a] = parse(Int, value)
            end
        end
    end
    return sum(values(memory))
end

println("part 1: ",part1(getinput()))
println("part 2: ",part2(getinput()))