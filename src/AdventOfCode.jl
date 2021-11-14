module AdventOfCode

export getinputpath

function getinputpath(year,day,sample=false)
    return joinpath(@__DIR__, string(year), "day" * lpad(day,2,"0"), "day" * lpad(day,2,"0") * (sample ? ".sample" : ".in"))
end

end # module