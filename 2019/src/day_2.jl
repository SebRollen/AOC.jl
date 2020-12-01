# https://adventofcode.com/2019/day/2
using AdventOfCode

input = readlines("data/2019/day_2.txt")

include("intcode_computer.jl")
using .IntcodeComputers: IntcodeComputer, run_program!

process_input(input) = parse.(Int, split(input[1], ","))

function part_1(input, noun, verb)
    tape = process_input(input)
    tape[2] = noun
    tape[3] = verb
    c = IntcodeComputer(tape, Channel{Int}(), Channel{Int}())
    run_program!(c)
    return tape[1]
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
