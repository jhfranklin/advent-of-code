using AdventOfCode

getinput() = readlines(getinputpath(2020, 25)) .|> x->parse(Int,x)

function transform(subject_number, loop_size)
    value = 1
    for _ ∈ 1:loop_size
        value *= subject_number
        value %= 20201227
    end
    return value
end

function decrypt(public_key)
    subject_number = 7
    value = 1
    loop_size = 0
    while value != public_key
        loop_size += 1
        value *= subject_number
        value %= 20201227
    end
    return loop_size
end

function part1()
    card_public, door_public = getinput()
    card_loop = decrypt(card_public)
    door_loop = decrypt(door_public)
    return transform(card_public, door_loop)
end

println("part 1: ", part1())
