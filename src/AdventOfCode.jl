module AdventOfCode

export getinputpath
export getdata

function getinputpath(year,day,sample=false)
    return joinpath(@__DIR__, string(year), "day" * lpad(day,2,"0"), "day" * lpad(day,2,"0") * (sample ? ".sample" : ".in"))
end

using HTTP

function getdata(year,day)
    path = joinpath(@__DIR__, string(year), "day" * lpad(day,2,"0"), "day" * lpad(day,2,"0") * ".in")
    session = joinpath(@__DIR__, "session_id.txt") |> readline
    data = HTTP.get("https://adventofcode.com/" * string(year) * "/day/" * string(day) * "/input"; cookies = Dict("session" => session)).body |> String
    f = open(path, "w")
    write(f, data)
    close(f)
end

end # module
