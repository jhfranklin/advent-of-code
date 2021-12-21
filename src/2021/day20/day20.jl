using AdventOfCode

getinput() = readlines(getinputpath(2021, 20))

const di = CartesianIndex(1,0)
const dj = CartesianIndex(0,1)

function parseinput(input)
    algorithm = input[1] |> collect .== '#'
    raw_image = input[3:end] .|> collect
    num_rows = length(raw_image)
    num_cols = length(raw_image[1])
    image = BitMatrix(undef,num_rows,num_cols)
    for i ∈ 1:num_rows
        for j ∈ 1:num_cols
            image[i,j] = raw_image[i][j] == '#'
        end
    end
    return algorithm, image
end

function padimage(image, pad)
    padded_image = BitMatrix(undef,(size(image).+2)...)
    # padding
    padded_image[1,:] .= pad
    padded_image[:,1] .= pad
    padded_image[end,:] .= pad
    padded_image[:,end] .= pad
    # fill with rest
    for ci ∈ CartesianIndices(image)
        padded_image[ci+CartesianIndex(1,1)] = image[ci]
    end
    return padded_image
end 

function getnext(algorithm,neighbourhood)
    bin = parse(Int,reduce(*, [string(x ? 1 : 0) for x ∈ neighbourhood]),base=2)
    return algorithm[bin+1]
end

function neighbourhood(matrix, ci)
    indices = [ci-di-dj, ci-di, ci-di+dj, ci-dj, ci, ci+dj, ci+di-dj, ci+di, ci+di+dj]
    return [get(matrix, x, matrix[ci]) for x ∈ indices]
end

function enhance(image, algorithm)
    next(x) = getnext(algorithm, x)
    new_image = BitMatrix(undef, size(image)...)
    for ci ∈ CartesianIndices(new_image)
        new_image[ci] = neighbourhood(image, ci) |> next
    end
    return new_image
end

function part1()
    algorithm, image = getinput() |> parseinput
    for step ∈ 1:2
        pad = mod(step, 2) == 0
        image = padimage(image, pad)
        image = enhance(image, algorithm)
    end
    return sum(image)
end

function part2()
    algorithm, image = getinput() |> parseinput
    for step ∈ 1:50
        pad = mod(step, 2) == 0
        image = padimage(image, pad)
        image = enhance(image, algorithm)
    end
    return sum(image)
end

println("part 1: ", part1())
println("part 2: ", part2())
