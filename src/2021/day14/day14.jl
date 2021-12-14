using AdventOfCode

getinput() = readlines(getinputpath(2021,14))

function answer(steps)
    input = getinput()
    template = input[1]
    instructions = input[3:end]
    mapper = Dict{String,String}()
    for i ∈ instructions
        left,right = split(i," -> ")
        mapper[left] = right
    end
    counter = Dict{String,Int}()
    for i ∈ 1:length(template)-1
        x = template[i:i+1]
        if haskey(counter,x) 
            counter[x] += 1
        else
            counter[x] = 1
        end
    end
    for _ ∈ 1:steps
        newcounter = copy(counter)
        for (k,v) ∈ counter
            insertion = mapper[k]
            left = k[1] * insertion
            right = insertion * k[2]
            num_insertions = v
            newcounter[k] -= num_insertions
            newcounter[left] = get!(newcounter,left,0) + num_insertions
            newcounter[right] = get!(newcounter,right,0) + num_insertions
        end
        counter = newcounter
    end
    elementcounts = Dict{Char,Int}()
    for (k,v) ∈ counter
        element = k[2]
        elementcounts[element] = get!(elementcounts,element,0) + v
    end
    first_element = template[1]
    elementcounts[first_element] = get!(elementcounts,first_element,0) + 1
    return maximum(values(elementcounts)) - minimum(values(elementcounts))
end

println("part 1: ", answer(10))
println("part 2: ", answer(40))
