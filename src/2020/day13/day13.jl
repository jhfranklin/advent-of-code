earliestTimestamp = 1003055
rawBusSchedule = "37,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,41,x,x,x,x,x,x,x,x,x,433,x,x,x,x,x,x,x,23,x,x,x,x,x,x,x,x,17,x,19,x,x,x,x,x,x,x,x,x,29,x,593,x,x,x,x,x,x,x,x,x,x,x,x,13"

function parseschedule(x)
    rx = r"(\d+)"
    matches = collect(eachmatch(rx,x))
    return [parse(Int,i.captures[1]) for i in matches]
end

function getnexttimes(timestamp, schedule)
    return schedule - (timestamp .% schedule)
end

function part1(timestamp,rawSchedule)
    schedule = parseschedule(rawSchedule)
    nextTimes = getnexttimes(timestamp, schedule)
    minInfo = findmin(nextTimes)
    return minInfo[1] * schedule[minInfo[2]]
end

function getbusdata(rawSchedule)
    splitSchedule = split(rawSchedule, ',')
    schedule = Tuple{Int,Int}[]
    for (i, s) in enumerate(splitSchedule)
        v = tryparse(Int, s)
        v !== nothing && push!(schedule, (i, v))
    end
    return schedule
end

function part2(rawSchedule)
    busData = getbusdata(rawSchedule)
    N = prod([b for (a,b) in busData])
    runningTotal = 0
    for (i, n) in busData
        a = mod(n - (i - 1), n)
        s = invmod(N ÷ n, n)
        runningTotal += (a * s * (N ÷ n))
    end
    return runningTotal % N
end

println("part 1: ",part1(earliestTimestamp, rawBusSchedule))
println("part 2: ", part2(rawBusSchedule))
