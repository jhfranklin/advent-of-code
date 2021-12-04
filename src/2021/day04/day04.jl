using AdventOfCode

getinput() = readlines(getinputpath(2021, 4))

mutable struct Board
    board::Matrix{Int}
    marks::BitMatrix
    win::Bool
end

function parseinput(input)
    board_size = 5
    draws = parse.(Int,split(input[1],","))
    num_boards = (length(input)-1) ÷ (board_size+1)
    boards = Vector{Board}()
    for i ∈ 1:num_boards
        start_row = 3 + 6*(i-1)
        end_row = start_row + (board_size-1)
        rows = input[start_row:end_row] .|> split .|> x->parse.(Int,x)
        grid = hcat(rows...) |> permutedims
        board = Board(grid, zeros(Bool, board_size, board_size), false)
        push!(boards, board)
    end
    return draws, boards
end

function checkboard(board::Board)
    board_size = size(board.board)[1]
    check_cols = any(sum(board.marks, dims=1) .== board_size)
    check_rows = any(sum(board.marks, dims=2) .== board_size)
    return (check_cols || check_rows)
end

function part1()
    draws, boards = getinput() |> parseinput
    for draw ∈ draws
        for board ∈ boards
            board.marks = board.marks .| (board.board .== draw)
            if checkboard(board)
                board.win = true
                return draw * sum(board.board .* .!board.marks)
                break
            end
        end
    end
end

function part2()
    draws, boards = getinput() |> parseinput
    num_boards = length(boards)
    num_boards_won = 0
    for draw ∈ draws
        for board ∈ boards
            board.marks = board.marks .| (board.board .== draw)
            if checkboard(board)
                board.win = true
                num_boards_won += 1
                if num_boards == num_boards_won
                    return draw * sum(board.board .* .!board.marks)
                end
            end
        end
        boards = [b for b ∈ boards if !b.win]
    end
end

println("part 1: ", part1())
println("part 2: ", part2())
