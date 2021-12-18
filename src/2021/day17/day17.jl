using AdventOfCode

getinput() = readlines(getinputpath(2021,17))[1]

function parseinput(input)
    x_min, x_max, y_min, y_max = parse.(Int,[a.match for a ∈ eachmatch(r"-?\d+", input)])
    return x_min, x_max, y_min, y_max
end

function part1()
    y_min = parseinput(getinput())[3]
    return y_min*(y_min+1)÷2
end

function part2()
    x_min, x_max, y_min, y_max = parseinput(getinput())
    successes = 0
    for x ∈ 1:x_max
        for y ∈ y_min:-y_min
            x_vol = x
            y_vol = y
            x_pos = 0
            y_pos = 0
            while y_pos >= y_min
                x_pos += x_vol
                y_pos += y_vol
                if x_vol > 0
                    x_vol -= 1
                end
                y_vol -= 1
                if x_pos ∈ x_min:x_max && y_pos ∈ y_min:y_max
                    successes += 1
                    break
                end
            end
        end
    end
    return successes
end

println("part 1: ", part1())
println("part 2: ", part2())
