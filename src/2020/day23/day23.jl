rawInput = "853192647"

input = [parse(Int, x) for x in rawInput]

mutable struct Cup
    label::Int
    next::Cup
    prev::Cup

    function Cup(label)
        x = new()
        x.label = label
        x.prev = x
        x.next = x
        return x
    end

    Cup(label,next,prev) = new(label,next,prev)
end

next(cup::Cup) = cup.next
prev(cup::Cup) = cup.prev

function createcuplist(input)
    cups = [Cup(i) for i in 1:length(input)]
    for (i,cupLabel) in enumerate(input)
        if i == 1
            cups[cupLabel].next = cups[input[2]]
            cups[cupLabel].prev = cups[input[end]]
        elseif i == length(cups)
            cups[cupLabel].next = cups[input[1]]
            cups[cupLabel].prev = cups[input[end-1]]
        else
            cups[cupLabel].next = cups[input[i+1]]
            cups[cupLabel].prev = cups[input[i-1]]
        end
    end
    return cups
end

function createcuplist(input,maxCupLabel)
    cups = createcuplist(input)
    firstCup = cups[input[1]]
    previousCup = cups[input[end]]
    nextCupLabel = maximum(input) + 1
    for i = nextCupLabel:maxCupLabel
        newCup = Cup(i, firstCup, previousCup)
        previousCup.next = newCup
        previousCup = newCup
        push!(cups, newCup)
    end
    firstCup.prev = cups[end]
    return cups
end

function getnextcups(currentCup)
    # gets next three cups
    nextCups = Vector{Cup}(undef,3)
    nextCups[1] = currentCup.next
    nextCups[2] = nextCups[1].next
    nextCups[3] = nextCups[2].next
    return nextCups
end

function move!(currentCup, cups)
    # pick up three cups and relink main list
    nextCups = getnextcups(currentCup)
    currentCup.next = nextCups[end].next
    nextCups[end].next.prev = currentCup
    # find destination cup
    currentCupLabel = currentCup.label
    destinationCupLabel = mod1(currentCupLabel - 1, length(cups))
    found = false
    destinationCup = cups[destinationCupLabel]
    while !found
        destinationCup = cups[destinationCupLabel]
        if destinationCup ∉ nextCups
            found = true
        else
            destinationCupLabel = mod1(destinationCupLabel - 1, length(cups))
        end
    end
    # place cups
    destinationCup.next.prev = nextCups[end]
    nextCups[end].next = destinationCup.next
    destinationCup.next = nextCups[1]
    nextCups[1].prev = destinationCup
    currentCup = currentCup.next
    return currentCup
end

function part1(input)
    cups = createcuplist(input)
    currentCup = cups[input[1]]
    for i = 1:100
        currentCup = move!(currentCup, cups)
    end
    output = ""
    while true
        labelToSearch = 1
        if currentCup.label == labelToSearch
            for i = 1:8
                currentCup = currentCup.next
                output *= string(currentCup.label)
            end
            return output
        end
        currentCup = currentCup.next
    end
end

function part2(input)
    cups = createcuplist(input,1_000_000)
    currentCup = cups[input[1]]
    for i = 1:10_000_000
        currentCup = move!(currentCup, cups)
    end
    while true
        labelToSearch = 1
        if currentCup.label == labelToSearch
            return (currentCup.next.label * currentCup.next.next.label)
        end
        currentCup = currentCup.next
    end
end

println("part 1: ", part1(input))
println("part 2: ", part2(input))
