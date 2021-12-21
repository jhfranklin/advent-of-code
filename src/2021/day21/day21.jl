using AdventOfCode

getinput() = readlines(getinputpath(2021, 21)) .|> last .|> x->parse(Int,x)

function part1(starting_positions)
    current_position = copy(starting_positions)
    track_size = 10
    winning_score = 1000
    die_max = 100
    scores = [0,0]
    num_rolls = 0
    finished = false
    current_player = 1
    current_die = 0
    while !finished
        rolls = mod1.(current_die .+ [1,2,3], die_max)
        num_rolls += 3
        current_die = rolls[end]
        move = sum(rolls)
        current_position[current_player] = mod1(current_position[current_player]+move,track_size)
        scores[current_player] += current_position[current_player]
        if scores[current_player] >= winning_score
            finished = true
        end
        current_player = mod1(current_player+1,2)
    end
    return num_rolls * scores[current_player]
end

struct GameState
    player1_pos::Int
    player1_score::Int
    player2_pos::Int
    player2_score::Int
    player1_next::Bool
end

function dirac()
    dirac_moves = Dict{Int,Int}()
    for i ∈ 1:3
        for j ∈ 1:3
            for k ∈ 1:3
                move = i+j+k
                dirac_moves[move] = get!(dirac_moves,move,0) + 1
            end
        end
    end
    return dirac_moves
end

const dirac_moves = dirac()

function wins(gs::GameState)
    if gs.player1_score >= 21
        return (1,0)
    elseif gs.player2_score >= 21
        return (0,1)
    end
    num_wins = (0,0)
    for (move,num_universes) ∈ dirac_moves
        if gs.player1_next
            next_pos = mod1(gs.player1_pos + move,10)
            next_score = gs.player1_score + next_pos
            next_gs = GameState(next_pos, next_score, gs.player2_pos, gs.player2_score, false)
        else
            next_pos = mod1(gs.player2_pos + move,10)
            next_score = gs.player2_score + next_pos
            next_gs = GameState(gs.player1_pos, gs.player1_score, next_pos, next_score, true)
        end
        new_wins = wins(next_gs)
        move_wins = num_universes .* new_wins
        num_wins = num_wins .+ move_wins
    end
    return num_wins
end

function part2(starting_positions)
    starting_game_state = GameState(starting_positions[1],0,starting_positions[2],0,true)
    return max(wins(starting_game_state)[1]...)
end

starting_positions = getinput()

println("part 1: ", part1(starting_positions))
println("part 2: ", part2(starting_positions))
