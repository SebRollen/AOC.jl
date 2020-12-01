# https://adventofcode.com/2019/day/3
using AdventOfCode

input = readlines("data/2019/day_3.txt")

function parse_move(x)
    dir = x[1]
    amount = parse(Int, x[2:end])
    if dir == 'R'
        return (0, amount)
    elseif dir == 'L'
        return (0, -amount)
    elseif dir == 'U'
        return (amount, 0)
    elseif dir == 'D'
        return (-amount, 0)
    end
    error("UNREACHABLE")
end

function segment_path(a, b)
    xdir = b[1] >= 0 ? 1 : -1
    ydir = b[2] >= 0 ? 1 : -1
    if (xdir < 0) || (ydir < 0)
        CartesianIndices(((a[1]+b[1]):a[1], (a[2]+b[2]):a[2]))
    else
        CartesianIndices((a[1]:(a[1]+b[1]), a[2]:(a[2] + b[2])))
    end
end

parse_input(input) = split.(input, ",")

function generate_path(movements)
    current_coords = CartesianIndex((0, 0))
    visited_coords = CartesianIndex{2}[]
    for movement in movements
        segment = segment_path(current_coords, movement)
        if any(x -> x < 0, movement) # negative move
            current_coords = first(segment)
            append!(visited_coords, reverse(vec(segment)[2:end]))
        else
            current_coords = last(segment)
            append!(visited_coords, segment[1:end-1])
        end
    end
    visited_coords
end

function find_crossings(path_movements)
    crossings = mapreduce(generate_path, intersect, path_movements)
    setdiff(crossings, [CartesianIndex(0, 0)])
end

function part_1(input)
    path_movements = map(x -> parse_move.(x), parse_input(input))
    crossings = find_crossings(path_movements)
    return mapreduce(x -> sum(abs.([x[1], x[2]])), min, crossings)
end
@info part_1(input)

function steps_to_crossing(path, crossing)
    i = 0
    for coord in path
        if crossing == coord
            return i
        end
        i += 1
    end
end

function part_2(input)
    path_movements = map(x -> parse_move.(x), parse_input(input))
    crossings = find_crossings(path_movements)
    paths = generate_path.(path_movements)
    steps = mapreduce(min, crossings) do crossing
        mapreduce(path -> steps_to_crossing(path, crossing), +, paths)
    end
end
@info part_2(input)
