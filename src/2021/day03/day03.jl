using AdventOfCode

getinput(sample=false) = readlines(getinputpath(2021, 3, sample))

function part1()
    binary_nums = getinput()
    num_nums = length(binary_nums)
    num_length = length(binary_nums[1])
    num_ones = Vector{Int}(undef,num_length)
    for bit ∈ 1:num_length
        num_ones[bit] = sum(['1'==b[bit] for b ∈ binary_nums])
    end
    most_common_bit = num_ones .> (num_nums ÷ 2)
    gamma_string = ""
    epsilon_string = ""
    for bit in most_common_bit
        if bit
            gamma_string *= "1"
            epsilon_string *= "0"
        else
            gamma_string *= "0"
            epsilon_string *= "1"
        end
    end
    gamma_rate = parse(Int,gamma_string;base=2)
    epsilon_rate = parse(Int,epsilon_string;base=2)
    power_consumption = gamma_rate * epsilon_rate
    return power_consumption
end

function getoxygenrating(binary_nums)
    eligible_nums = copy(binary_nums)
    num_length = length(binary_nums[1])
    for col ∈ 1:num_length
        num_zeroes = sum(['0'==b[col] for b ∈ eligible_nums])
        most_common_bit = !(num_zeroes > length(eligible_nums) ÷ 2)
        new_eligible_nums = Vector{String}()
        for num ∈ eligible_nums
            bool = num[col] == '1'
            if bool == most_common_bit
                push!(new_eligible_nums, num)
            end
        end
        eligible_nums = new_eligible_nums
    end
    return parse(Int,eligible_nums[1];base=2)
end

function getCO2rating(binary_nums)
    eligible_nums = copy(binary_nums)
    num_length = length(binary_nums[1])
    for col ∈ 1:num_length
        num_zeroes = sum(['0'==b[col] for b ∈ eligible_nums])
        least_common_bit = num_zeroes > length(eligible_nums) ÷ 2
        new_eligible_nums = Vector{String}()
        for num ∈ eligible_nums
            bool = num[col] == '1'
            if bool == least_common_bit
                push!(new_eligible_nums, num)
            end
        end
        eligible_nums = new_eligible_nums
        length(eligible_nums) == 1 && break
    end
    return parse(Int,eligible_nums[1];base=2)
end

function part2()
    nums = getinput()
    return getCO2rating(nums) * getoxygenrating(nums)
end

println("part 1: ", part1())
println("part 2: ", part2())
