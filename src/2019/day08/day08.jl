using AdventOfCode

getinput(sample=false) = first(readlines(getinputpath(2019, 8, sample)))

parseinput(input_string) = input_string |> collect .|> (x->parse(Int,x))

function formimage(pixel_vector)
    wide = 25
    tall = 6
    return permutedims(reshape(pixel_vector, (wide, tall, :)), [2, 1, 3])
end

function part1()
    image = getinput() |> parseinput |> formimage
    num_zeroes = sum(image .== 0, dims=[1,2])[1,1,:]
    min_layer_index = findmin(num_zeroes)[end]
    min_layer = image[:,:,min_layer_index]
    return sum(min_layer .== 1) * sum(min_layer .== 2)
end

function part2()
    image = getinput() |> parseinput |> formimage
    layer_size = size(image[:,:,1])
    single_layer = Array{Char}(undef,layer_size)
    for index ∈ CartesianIndices(single_layer)
        stack = image[index,:]
        pixel_index = findfirst(x->x<2, stack)
        pixel_colour = stack[pixel_index] == 0 ? ' ' : '□'
        single_layer[index] = pixel_colour
    end
    return single_layer
end

println("part 1: ", part1())
print("part 2: ")
display(part2())
