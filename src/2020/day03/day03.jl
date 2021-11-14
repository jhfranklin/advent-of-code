using AdventOfCode

getInput() = readlines(getinputpath(2020,3))

function getNumTrees(right,down,input)
    mapWidth=length(input[1])
    numTrees = 0
    currentPos = 1-right
    for iter in enumerate(input)
        if (iter[1] - 1) % down == 0 
            currentPos += right
            circularPos = mod1(currentPos,mapWidth)
            iter[2][circularPos] == '#' && (numTrees += 1)
        end
    end
    return numTrees
end

function getNumTrees(x,input)
    return getNumTrees(x[1],x[2],input)
end

function part1()
    right=3
    down=1
    input=getInput()
    mapWidth=length(input[1])
    numTrees = 0
    for iter in enumerate(input)
        pos = (iter[1] - 1) * right + 1
        circularPos = mod1(pos,mapWidth)
        iter[2][circularPos] == '#' && (numTrees += 1) 
    end
    return numTrees
end

function part2()
    input=getInput()
    tests = [[1,1],[3,1],[5,1],[7,1],[1,2]]
    numTrees = [getNumTrees(x,input) for x in tests]
    return prod(numTrees)
end

println("part 1: ", part1())
println("part 2: ", part2())
