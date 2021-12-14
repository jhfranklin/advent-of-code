using AdventOfCode

getinput() = readlines(getinputpath(2020,20))

mutable struct Tile
    id::Int
    tile::BitMatrix
end

const monster =
"                  # 
#    ##    ##    ###
 #  #  #  #  #  #   "

function getmonstermask(monster)
    rows = split(monster,"\n")
    bit_rows = Vector{BitVector}()
    for r ∈ rows
        mask = collect(r) .== '#'
        push!(bit_rows, mask)
    end
    return hcat(bit_rows...) |> permutedims
end

function getedges(tile)
    array = tile.tile
    edges = Dict{Symbol,UInt64}(
        :n => hash(array[1,:]),
        :e => hash(array[:,end]),
        :s => hash(reverse(array[end,:])),
        :w => hash(reverse(array[:,1])),
        :nf => hash(reverse(array[1,:])),
        :ef => hash(reverse(array[:,end])),
        :sf => hash(array[end,:]),
        :wf => hash(array[:,1])
    )
    return edges
end

rotate(t) = rotr90(t,1)
reflect(t) = rotate(permutedims(t)) # swaps east and west

function transform!(tile,new_up)
    if      new_up == :w
        tile.tile = tile.tile |> rotate
    elseif  new_up == :s
        tile.tile = tile.tile |> rotate |> rotate
    elseif  new_up == :e
        tile.tile = tile.tile |> rotate |> rotate |> rotate
    elseif  new_up == :nf
        tile.tile = tile.tile |> reflect
    elseif  new_up == :ef
        tile.tile = tile.tile |> reflect |> rotate
    elseif  new_up == :sf
        tile.tile = tile.tile |> reflect |> rotate |> rotate
    elseif  new_up == :wf
        tile.tile = tile.tile |> reflect |> rotate |> rotate |> rotate
    end
end

function checktilematch(x,y)
    for a ∈ values(getedges(x))
        for b ∈ values(getedges(y))
            a == b && return true
        end
    end
    return false
end

numberofedges(tiles, edge) = sum([edge ∈ values(getedges(t)) for t ∈ tiles])

function findtilewithedge(tiles,this_tile,edge)
    for t ∈ setdiff(tiles, [this_tile])
        for (k,v) ∈ getedges(t)
            if v == edge
                return (t, k)
            end
        end
    end
end

function parseinput(input)
    number_of_tiles = length(input) ÷ 12
    tile_vector = Vector{Tile}(undef, number_of_tiles)
    for t ∈ 1:number_of_tiles
        raw_tile = input[12*t - 11:12*t - 1]
        id = parse(Int,raw_tile[1][6:end-1])
        tile = hcat([collect(row).=='#' for row ∈ raw_tile[2:end]]...)
        tile_vector[t] = Tile(id,tile)
    end
    return tile_vector
end

function part1()
    tiles = getinput() |> parseinput
    answer = 1
    for t ∈ tiles
        if sum([checktilematch(t,x) for x ∈ tiles if x != t]) == 2
            answer *= t.id
        end
    end
    return answer
end

function part2()
    tiles = getinput() |> parseinput
    grid = Array{Tile}(undef, 12, 12)
    # find corner
    for t ∈ tiles
        if sum([checktilematch(t,x) for x ∈ tiles if x != t]) == 2 # corner found
            edges = getedges(t)
            if numberofedges(tiles, edges[:n]) == 1
                if numberofedges(tiles, edges[:e]) == 1
                    transform!(t, :e)
                end
            else # south is edge
                if numberofedges(tiles, edges[:e]) == 1
                    transform!(t, :s)
                else # west is edge
                    transform!(t, :w)
                end
            end
            grid[1,1] = t
            setdiff!(tiles, [t])
            break
        end
    end
    # build top row
    for c ∈ 2:12
        tile_to_match = grid[1,c-1]
        edge_to_match = getedges(tile_to_match)[:ef]
        (tile, edge_id) = findtilewithedge(tiles, tile_to_match, edge_to_match)
        if      edge_id == :n
            transform!(tile, :e)
        elseif  edge_id == :e
            transform!(tile, :s)
        elseif  edge_id == :s
            transform!(tile, :w)
        elseif  edge_id == :nf
            transform!(tile, :wf)
        elseif  edge_id == :ef
            transform!(tile, :nf)
        elseif  edge_id == :sf
            transform!(tile, :ef)
        elseif  edge_id == :wf
            transform!(tile, :sf)
        end
        grid[1,c] = tile
        setdiff!(tiles, [tile])
    end
    # build other rows
    for r ∈ 2:12
       for c ∈ 1:12
           tile_to_match = grid[r-1,c]
           edge_to_match = getedges(tile_to_match)[:sf]
           (tile, edge_id) = findtilewithedge(tiles, tile_to_match, edge_to_match)
           transform!(tile, edge_id)
           grid[r,c] = tile
           setdiff!(tiles, [tile])
       end
    end
    # Create image
    image = Array{Bool}(undef,8*12, 8*12)
    for r ∈ 1:12
        for c ∈ 1:12
            tile_image = grid[r,c].tile[2:end-1,2:end-1]
            image[8*r-7:8*r,8*c-7:8*c] = tile_image
        end
    end
    # Create possible rotations and reflections
    all_images = Vector{BitMatrix}()
    for rot ∈ 1:4
        rot_image = rotr90(image,rot)
        push!(all_images, rot_image)
        push!(all_images, transpose(rot_image))
    end
    # Find monsters
    monster_mask = getmonstermask(monster)
    for image ∈ all_images
        num_monsters = 0
        max_col = 77
        max_row = 94
        for row ∈ 1:max_row
            for col ∈ 1:max_col
                search_grid = view(image, row:row+2,col:col+19)
                if (search_grid .& monster_mask) == monster_mask
                    num_monsters += 1
                end
            end
        end
        if num_monsters > 0
            return sum(image) - num_monsters*sum(monster_mask)
        end
    end
end
#part1()
part2()

# for i ∈ part2()[1,:]
#     println(i.id)
#     println(reverse(i.tile[:,1]))
#     println(i.tile[:,end])
# end
