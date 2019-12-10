# https://adventofcode.com/2019/day/10
using AdventOfCode

input = readlines("data/2019/day_10.txt")

process_input(input) = permutedims(reduce(hcat, split.(input, "")), (2,1))

function seen_asteroids(map, loc)
    seen = Dict()
    for j in CartesianIndices(map)
        if loc != j && map[j] == "#"
            θ = atan(j.I[2] - loc.I[2], j.I[1] - loc.I[1])
            r = √((j.I[2] - loc.I[2])^2 + (j.I[1] - loc.I[1])^2)
            if θ ∉ keys(seen)
                seen[θ] = (r = r, loc = j)
            else
                if r < seen[θ].r
                    seen[θ] = (r = r, loc = j)
                end
            end
        end
    end
    return seen
end

function part_1(input)
    map = process_input(input)
    counts = Dict()
    for i in CartesianIndices(map)
        if map[i] == "#"
            counts[i] = length(seen_asteroids(map, i))
        end
    end
    best_location = maximum((j,i) for (i,j) in counts)[2]
    return counts[best_location]
end
@info part_1(input)

function part_2(input)
    # don't have to actually remove any asteroids since we've seen more than 200
    map = process_input(input)
    best_location = CartesianIndex(30, 29) # from prob 1
    seen = sort(seen_asteroids(map, best_location), rev = true)
    k = collect(keys(seen))[200]
    loc = seen[k].loc
    return 100*(loc.I[2]-1) + (loc.I[1] - 1)
end
@info part_2(input)
