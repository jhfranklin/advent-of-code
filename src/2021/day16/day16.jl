using AdventOfCode

getinput() = readlines(getinputpath(2021,16))[1]

hex2bin(hex) = reduce(*,lpad.(string.(hex2bytes(hex), base=2),8,'0'))
bin2dec(bin) = parse(Int,bin,base=2)

struct Packet
    version::Int
    type_id::Int
    literal_value::Int
    subpackets::Vector{Packet}
end

function evaluatepacket(packet::Packet)
    type_id = packet.type_id
    subpackets = packet.subpackets
    if type_id == 0 # sum
        return sum([evaluatepacket(s) for s ∈ subpackets])
    elseif type_id == 1 # product
        return prod([evaluatepacket(s) for s ∈ subpackets])
    elseif type_id == 2 # min
        return minimum([evaluatepacket(s) for s ∈ subpackets])
    elseif type_id == 3 # max
        return maximum([evaluatepacket(s) for s ∈ subpackets])
    elseif type_id == 4 # literal
        return packet.literal_value
    elseif type_id == 5 # greater than
        return evaluatepacket(subpackets[1]) > evaluatepacket(subpackets[2]) ? 1 : 0
    elseif type_id == 6 # less than
        return evaluatepacket(subpackets[1]) < evaluatepacket(subpackets[2]) ? 1 : 0
    elseif type_id == 7 # equal to
        return evaluatepacket(subpackets[1]) == evaluatepacket(subpackets[2]) ? 1 : 0
    end
end

function parsetransmission(transmission)
    version = transmission[1:3] |> bin2dec
    type_id = transmission[4:6] |> bin2dec
    transmission = transmission[7:end]
    if type_id == 4
        group_prefix = 1
        literal = ""
        while group_prefix == 1
            group_prefix = transmission[1] |> bin2dec
            group = transmission[2:5]
            transmission = transmission[6:end]
            literal *= group
        end
        literal_value = literal |> bin2dec
        return Packet(version, type_id, literal_value, []), transmission
    else
        length_type_id = transmission[1] |> bin2dec
        subpackets = Vector{Packet}()
        if length_type_id == 0
            num_bits = transmission[2:16] |> bin2dec
            transmission = transmission[17:end]
            transmission_length = length(transmission)
            while transmission_length - length(transmission) < num_bits
                subpacket, transmission = parsetransmission(transmission)
                push!(subpackets, subpacket)
            end
        elseif length_type_id == 1
            num_subpackets = transmission[2:12] |> bin2dec
            transmission = transmission[13:end]
            for s ∈ 1:num_subpackets
                subpacket, transmission = parsetransmission(transmission)
                push!(subpackets, subpacket)
            end
        else
            error("unknown length_type_id")
        end
        return Packet(version, type_id, 0, subpackets), transmission
    end
end

function getversionnumbers(packet::Packet)
    total_version = packet.version
    if length(packet.subpackets) > 0
        total_version += sum([getversionnumbers(p) for p ∈ packet.subpackets])
    end
    return total_version
end

function part1()
    transmission = getinput() |> hex2bin
    packets = parsetransmission(transmission)[1]
    return getversionnumbers(packets)
end

function part2()
    transmission = getinput() |> hex2bin
    packets = parsetransmission(transmission)[1]
    return evaluatepacket(packets)
end

println("part 1: ", part1())
println("part 2: ", part2())
