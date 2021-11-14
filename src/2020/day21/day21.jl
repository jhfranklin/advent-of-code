using AdventOfCode

getinput() = readlines(getinputpath(2020,21))

function getlists(input)
    rx = r"(.*) \(contains (.*)\)"
    matches = match.(rx, input)

    ingredients = [Set{String}(split(row.captures[1]," ")) for row ∈ matches]
    allergens = [Set{String}(split(row.captures[2],", ")) for row ∈ matches]

    return (ingredients, allergens)
end

function getall(list)
    allDict = Set{String}()
    for row ∈ list
        union!(allDict, row)
    end
    return allDict
end

function getcandidateingredients(ingredients, allergens)
    candidateIngredients = Dict{String,Set{String}}()
    numRows = length(ingredients)
    for allergen in getall(allergens)
        a = [ingredients[i] for i ∈ 1:numRows if allergen ∈ allergens[i]]
        candidateIngredients[allergen] = intersect(a...)
    end
    return candidateIngredients
end

function part1()
    input = getinput()
    (ingredients, allergens) = getlists(input)
    candidateIngredients = getcandidateingredients(ingredients,allergens)
    allCandidateIngredients = union(values(candidateIngredients)...)
    nonAllergenicIngredients = setdiff(getall(ingredients), allCandidateIngredients)
    appearences = 0
    for ing in nonAllergenicIngredients
        for row in ingredients
            ing ∈ row && (appearences += 1)
        end
    end
    return appearences
end

function part2()
    input = getinput()
    (ingredients, allergens) = getlists(input)
    candidateIngredients = getcandidateingredients(ingredients,allergens)
    ingredientMap = Dict{String,String}()
    for _ ∈ getall(allergens)
        mapped = values(ingredientMap)
        for (k,v) ∈ candidateIngredients
            unmapped = setdiff(v, mapped)
            if length(unmapped) == 1
                ing = pop!(unmapped)
                ingredientMap[k] = ing
                break
            end
        end
    end
    sorted = ingredientMap |> keys |> collect |> sort
    return join([ingredientMap[x] for x in sorted],',')
end

println("part 1: ", part1())
println("part 2: ", part2())