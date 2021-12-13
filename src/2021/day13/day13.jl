using AdventOfCode

getinput() = readlines(getinputpath(2021, 13))

struct Fold
    axis::Symbol
    line::Int
end

function parseinput(input)
    folds = Vector{Fold}()
    coords = Vector{Tuple{Int,Int}}()
    for row ∈ input
        if row == ""
            continue
        elseif startswith(row,"fold")
            a,l = replace(row,"fold along "=>"") |> x->split(x,"=")
            push!(folds,Fold(Symbol(a),parse(Int,l)))
        else
            xcoord,ycoord = split(row,",") .|> x->parse(Int,x)
            push!(coords, (xcoord,ycoord))
        end
    end
    x_size = 1+2*maximum([fold.line for fold ∈ folds if fold.axis==:x])
    y_size = 1+2*maximum([fold.line for fold ∈ folds if fold.axis==:y])
    paper = zeros(Bool,x_size,y_size)
    for (x,y) ∈ coords
        paper[x+1,y+1] = true
    end
    return folds,paper
end

function part1()
    folds,paper = getinput() |> parseinput
    fold1 = folds[1]
    if fold1.axis == :y
        left = paper[:,1:fold1.line]
        right = reverse(paper[:,2+fold1.line:end],dims=2)
        folded = left .| right
    else
        up = paper[1:fold1.line,:]
        down = reverse(paper[2+fold1.line:end,:],dims=1)
        folded = up .| down
    end
    return sum(folded)
end

function part2()
    folds,paper = getinput() |> parseinput
    for fold ∈ folds
        if fold.axis == :y
            left = paper[:,1:fold.line]
            right = reverse(paper[:,2+fold.line:end],dims=2)
            paper = left .| right
        else
            up = paper[1:fold.line,:]
            down = reverse(paper[2+fold.line:end,:],dims=1)
            paper = up .| down
        end
    end
    paper_size = size(paper)
    for x ∈ 1:paper_size[2]
        for y ∈ 1:paper_size[1]
            paper[y,x] ? print('x') : print(' ')
        end
        print('\n')
    end
end

println("part 1: ", part1())
part2()
