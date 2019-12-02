# https://adventofcode.com/2019/day/2
using AdventOfCode

input = readlines("data/2019/day_2.txt")

function process_input(input)
    parse.(Int, split(input[1], ","))
end

function part_1(input, noun, verb)
    input = process_input(input)
    input[2] = noun
    input[3] = verb
    for i in 1:4:length(input)
        if input[i] == 99
            return input[1]
        elseif input[i] == 1
            input[input[i+3]+1] = input[input[i+1]+1] + input[input[i+2]+1]
        elseif input[i] == 2
            input[input[i+3]+1] = input[input[i+1]+1] * input[input[i+2]+1]
        else
            error("Unexpected input")
        end
    end
    error("Reached end of input with no return")
end
@info part_1(input, 12, 2)

function part_2(input)
    for noun in 0:99, verb in 0:99
        input_copy = copy(input)
        if part_1(input_copy, noun, verb) == 19690720
            return 100 * noun + verb
        end
    end
end
@info part_2(input)
