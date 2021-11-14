using AdventOfCode

getinput() = readlines(getinputpath(2020,18))

⊕(a, b) = a * b # redefine * to have + precedence
⊗(a, b) = a + b # redefine + to have * precedence

function part1()
    input = getinput()
    total = mapreduce(row->replace(row, "*" => "⊕") |> Meta.parse |> eval,+,input)
    return total
end

function part2()
    input = getinput()
    total = mapreduce(row->replace(replace(row, "*" => "⊕"), "+" => "⊗") |> Meta.parse |> eval,+,input)
    return total
end

println("part 1: ", part1())
println("part 2: ", part2())
