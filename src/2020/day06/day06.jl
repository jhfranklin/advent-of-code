using AdventOfCode

getInput() = split(read(getinputpath(2020,6), String), "\n\n")

function getUniqueQuestions(row)
    questionSet = setdiff(row, '\n')
    return questionSet
end

function getAnsweredByAll(row)
    passengers = split(row, '\n', keepempty=false)
    Qs = intersect(passengers...)
    return Qs
end

part1() = getInput() .|> getUniqueQuestions .|> length |> sum
part2() = getInput() .|> getAnsweredByAll .|> length |> sum

println("part 1: ", part1())
println("part 2: ", part2())
