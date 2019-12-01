# https://adventofcode.com/2019/day/1
using AdventOfCode

input = readlines("data/2019/day_1.txt")

fuel_needed(mass) = floor(Int64, mass / 3) - 2

function part_1(input)
    sum(fuel_needed.(parse.(Int64, input)))
end
@info part_1(input)

function total_fuel_needed(mass)
    initial = fuel_needed(mass)
    if initial < 0
        return 0
    else
        return initial + total_fuel_needed(initial)
    end
end

function part_2(input)
    sum(total_fuel_needed.(parse.(Int64, input)))
end
@info part_2(input)
