# https://adventofcode.com/2019/day/4
using AdventOfCode

input = readlines("data/2019/day_4.txt")

get_range(input) = reduce(:, parse.(Int64, split(input[1], "-")))
number_to_array(n) = reverse(digits(n))
function is_match(A)
    all(diff(A) .>= 0) && any(diff(A) .== 0)
end

function part_1(input)
    search_range = get_range(input)
    out = Int64[]
    for i in search_range
        is_match(number_to_array(i)) && push!(out, i)
    end
    length(out)
end
@info part_1(input)

function has_double(A)
    d = Dict{Int, Int}()
    for a in A
        if a ∉ keys(d)
            d[a] = 1
        else
            d[a] += 1
        end
    end
    any(values(d) .== 2)
end

is_match_part_2(A) = is_match(A) && has_double(A)

function part_2(input)
    search_range = get_range(input)
    out = Int64[]
    for i in search_range
        is_match_part_2(number_to_array(i)) && push!(out, i)
    end
    length(out)
end
@info part_2(input)
