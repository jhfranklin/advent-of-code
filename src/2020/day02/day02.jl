using AdventOfCode

getInput() = readlines(getinputpath(2020,2))

function parseRow(row)
    m = match(r"(\d+)-(\d+) (\w): (\w+)", row)
    return tuple(m.captures...)
end

function checkPasswordPart1(input::String)
    parsed = parseRow(input)
    minNum, maxNum = parse.(Int,parsed[1:2])
    (letter,) = parsed[3]
    password = parsed[4]
    numInPassword = count(isequal(letter),collect(password))
    return (numInPassword >= minNum) && (numInPassword <= maxNum)
end 


function checkPasswordPart2(input::String)
    parsed = parseRow(input)
    minNum, maxNum = parse.(Int,parsed[1:2])
    (letter,) = parsed[3]
    password = parsed[4]
    return (password[minNum] == letter) ⊻ (password[maxNum] == letter)
end 

part1() = getInput() .|> checkPasswordPart1 |> sum 
part2() = getInput() .|> checkPasswordPart2 |> sum 

println("part 1: ", part1())
println("part 2: ", part2())
