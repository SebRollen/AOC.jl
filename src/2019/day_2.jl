# https://adventofcode.com/2019/day/2
using AdventOfCode, OffsetArrays

input = readlines("data/2019/day_2.txt")

include("intcode_computer.jl")
using .IntcodeComputers: process_tape

function process_input(input)
    OffsetArray(parse.(Int, split(input[1], ",")), -1)
end

function part_1(input, noun, verb)
    tape = process_input(input)
    tape[1] = noun
    tape[2] = verb
    process_tape(tape, nothing, nothing)
    return tape[0]
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
