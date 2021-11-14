using AdventOfCode

getinput() = readlines(getinputpath(2020,16))

function part1()
    input = getinput()
    # create valid set
    fieldRules = input[1:findfirst(isequal(""),input)-1]
    rx = r"(.*): (\d*)-(\d*) or (\d*)-(\d*)"
    validSet = BitSet()
    for row in fieldRules
        m = match(rx, row)
        group1 = parse(Int, m.captures[2]):parse(Int, m.captures[3])
        group2 = parse(Int, m.captures[4]):parse(Int, m.captures[5])
        union!(validSet, group1)
        union!(validSet, group2)
    end
    # find invalid fields
    otherTickets = input[findfirst(isequal("nearby tickets:"),input)+1:end]
    ticketScanningErrorRate = 0
    for ticket in otherTickets
        values = parse.(Int,split(ticket, ","))
        ticketScanningErrorRate += sum([v for v ∈ values if v ∉ validSet])
    end
    return ticketScanningErrorRate
end

function part2()
    # create valid set
    input = getinput()
    fieldRules = input[1:findfirst(isequal(""),input)-1]
    rx = r"(.*): (\d*)-(\d*) or (\d*)-(\d*)"
    validSet = BitSet()
    fields = Dict{String,BitSet}()
    for row in fieldRules
        m = match(rx, row)
        group1 = parse(Int, m.captures[2]):parse(Int, m.captures[3])
        group2 = parse(Int, m.captures[4]):parse(Int, m.captures[5])
        fieldName = m.captures[1]
        validForField = BitSet(group1)
        union!(validForField, group2)
        fields[fieldName] = validForField
        union!(validSet, validForField)
    end
    # find invalid tickets
    otherTickets = input[findfirst(isequal("nearby tickets:"),input)+1:end]
    ticketValues = [parse.(Int,split(ticket, ",")) for ticket ∈ otherTickets]
    validTickets = Array{Int,1}[]
    for ticket in ticketValues
        if !any([x ∉ validSet for x in ticket])
            push!(validTickets, ticket)
        end
    end
    # determine field order
    allValues = hcat(validTickets...)
    numberOfFields = length(fields)
    ticketData = [BitSet(allValues[i, :]) for i ∈ 1:numberOfFields]
    # determine eligible fields
    eligibleFields = Array{Set{String}}(undef, numberOfFields)
    for (i, ticket) ∈ enumerate(ticketData)
        eligibleFieldsForRow = Set{String}()
        for (k,v) ∈ fields
            length(setdiff(ticket, v)) == 0 && union!(eligibleFieldsForRow, [k])
        end
        eligibleFields[i] = eligibleFieldsForRow
    end
    fieldMapping = Dict{String,Int}()
    fieldsRemaining = [k for k in keys(fields)]
    allFieldsMapped = false
    for iter = 1:numberOfFields
        for field in fieldsRemaining
            total = 0
            location = Int[]
            for (i, ef) in enumerate(eligibleFields)
                if field ∈ ef
                    total += 1
                    push!(location, i)
                end
            end
            if total == 1
                setdiff!(fieldsRemaining, [field])
                eligibleFields[location[1]] = Set()
                fieldMapping[field] = location[1]
                break
            end
        end
        allFieldsMapped = length(fieldMapping) == numberOfFields
    end
    answer = 1
    myTicket = parse.(Int,split(input[findfirst(isequal("your ticket:"),input)+1],','))
    for (k,v) in fieldMapping
        if startswith(k, "departure")
            answer *= myTicket[v]
        end
    end
    return answer
end

println("part 1: ", part1())
println("part 2: ", part2())
