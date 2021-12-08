using AdventOfCode

getinput() = readlines(getinputpath(2021, 8))

function part1()
    unique_signals = [2, 3, 4, 7]
    entries = getinput()
    counter = 0
    for entry ∈ entries
        renders = split(split(entry, " | ")[end]," ") .|> length
        num_uniques = sum([x ∈ unique_signals for x ∈ renders])
        counter += num_uniques
    end
    return counter
end

function part2()
    total = 0
    for row ∈ getinput()
        left, right = split(row, " | ")
        patterns = split(left, " ") .|> Set
        outputs = split(right, " ") .|> Set
        numbers = Dict{Int, Set{Char}}() # contains known numbers
        signals = Dict{Char, Char}() # contains known signals
        # Add known numbers
        numbers[1] = popat!(patterns, findfirst(length.(patterns).==2))
        numbers[7] = popat!(patterns, findfirst(length.(patterns).==3))
        numbers[4] = popat!(patterns, findfirst(length.(patterns).==4))
        numbers[8] = popat!(patterns, findfirst(length.(patterns).==7))
        # signal a is 7 less 1
        s = pop!(setdiff(numbers[7],numbers[1]))
        signals[s] = 'a'
        # 2, 5 and 6 don't contain both c and f.
        # First, find pattern of length 6 with only one of c and f - this is 6, match is f, non-match is c
        for p ∈ patterns
            if length(p) == 6
                matches = intersect(numbers[1],p)
                non_matches = setdiff(numbers[1], p)
                if length(matches) == 1
                    numbers[6] = p
                    signals[pop!(matches)] = 'f'
                    signals[pop!(non_matches)] = 'c'
                    break
                end
            end
        end
        deleteat!(patterns, [issetequal(x,numbers[6]) for x ∈ patterns])
        # Next, find patterns of length 5 with only one of c and f, 2 contains c, 5 contains f
        for p ∈ patterns
            if length(p) == 5
                matches = intersect(numbers[1],p)
                if length(matches) == 1
                    if signals[pop!(matches)] == 'c'
                        numbers[2] = p
                    else
                        numbers[5] = p
                    end
                end
            end
        end
        deleteat!(patterns, [issetequal(x,numbers[2]) for x ∈ patterns])
        deleteat!(patterns, [issetequal(x,numbers[5]) for x ∈ patterns])
        # Remaining pattern of length 5 is number 3
        numbers[3] = popat!(patterns, findfirst(length.(patterns).==5))
        # For remaining patterns, one doesn't have d - this is 0. So we can find 0, 9 and d
        for p ∈ patterns
            diffs = setdiff(numbers[4], p)
            if length(diffs) == 1
                signals[pop!(diffs)] = 'd'
                numbers[0] = p
            else
                numbers[9] = p
            end
        end
        deleteat!(patterns, [issetequal(x,numbers[0]) for x ∈ patterns])
        deleteat!(patterns, [issetequal(x,numbers[9]) for x ∈ patterns])
        # 6 less 5 gives e
        s = pop!(setdiff(numbers[6],numbers[5]))
        signals[s] = 'e'
        # Missing segment from 4 is b
        s = pop!(setdiff(numbers[4],keys(signals)))
        signals[s] = 'b'
        # Missing segment from 8 is g
        s = pop!(setdiff(numbers[8],keys(signals)))
        signals[s] = 'g'
        # translate outputs
        mapper = Dict([(v,k) for (k,v) ∈ numbers])
        value = ""
        for digit ∈ outputs
            value *= string(mapper[digit])
        end
        total += parse(Int,value)
    end
    return total
end

println("part 1: ", part1())
println("part 2: ", part2())
