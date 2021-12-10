using AdventOfCode

getinput() = readlines(getinputpath(2021, 10))

const corrupt_scorer = Dict{Char,Int}(
    ')' => 3,
    ']' => 57,
    '}' => 1197,
    '>' => 25137
)

const correct_scorer = Dict{Char,Int}(
    '(' => 1,
    '[' => 2,
    '{' => 3,
    '<' => 4
)

const matcher = Dict{Char,Char}(
    '(' => ')',
    '[' => ']',
    '{' => '}',
    '<' => '>'
)

const closers = values(matcher)

function part1()
    input = getinput()
    total_score = 0
    for line ∈ input
        stack = Vector{Char}()
        for c ∈ line
            if c ∉ closers
                push!(stack, c)
            else
                open_to_test = pop!(stack)
                if matcher[open_to_test] != c
                    total_score += corrupt_scorer[c]
                    break
                end
            end
        end
    end
    return total_score
end

function part2()
    input = getinput()
    scores = Vector{Int}()
    for line ∈ input
        stack = Vector{Char}()
        score = 0
        corrupted = false
        for c ∈ line
            if c ∉ closers
                push!(stack, c)
            else
                open_to_test = pop!(stack)
                if matcher[open_to_test] != c
                    corrupted = true
                    break
                end
            end
        end
        if !corrupted
            while !isempty(stack)
                next = pop!(stack)
                score *= 5
                score += correct_scorer[next]
            end
            push!(scores, score)
        end
    end
    sort!(scores)
    len = length(scores)
    return scores[(1+len÷2)]
end

println("part 1: ", part1())
println("part 2: ", part2())
