using AdventOfCode

getInput() = split(read(getinputpath(2020,4), String), "\n\n")

function hasFields(passport::Dict{String,String})
    requiredFields = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
    return all(haskey(passport, field) for field ∈ requiredFields)
end

function hasFields(passport::AbstractString)
    return hasFields(convertPassport(passport))
end

function convertPassport(passport)
    data = Dict{String,String}()
    for match ∈ eachmatch(r"(.{3}):([#\w]+)", passport)
        data[match.captures[1]] = match.captures[2]
    end
    return data
end

function check_byr(byr)
    year = tryparse(Int, byr)
    return !(isnothing(year) || !(1920 <= year <= 2002))
end

function check_iyr(iyr)
    year = tryparse(Int, iyr)
    return !(isnothing(year) || !(2010 <= year <= 2020))
end

function check_eyr(eyr)
    year = tryparse(Int, eyr)
    return !(isnothing(year) || !(2020 <= year <= 2030))
end

function check_hgt(hgt)
    height = tryparse(Int, hgt[1:end-2])
    system = hgt[end-1:end]
    isnothing(height) && return false
    if system == "cm"
        return (150 <= height <= 193)
    elseif system == "in"
        return (59 <= height <= 76)
    end
    return false
end

function check_hcl(hcl)
    return occursin(r"^#[\da-f]{6}$", hcl)
end

function check_ecl(ecl)
    return occursin(r"^amb|blu|brn|gry|grn|hzl|oth$", ecl)
end

function check_pid(pid)
    return occursin(r"^\d{9}$", pid)
end

function checkPassportIsValid(data::Dict{String,String})
    return hasFields(data) &&
        check_byr(data["byr"]) &&
        check_iyr(data["iyr"]) &&
        check_eyr(data["eyr"]) &&
        check_hgt(data["hgt"]) &&
        check_hcl(data["hcl"]) &&
        check_ecl(data["ecl"]) &&
        check_pid(data["pid"])
end

function checkPassportIsValid(passport::AbstractString)
    return checkPassportIsValid(convertPassport(passport))
end

part1() = getInput() .|> hasFields |> sum
part2() = getInput() .|> checkPassportIsValid |> sum

println("part 1: ", part1())
println("part 2: ", part2())