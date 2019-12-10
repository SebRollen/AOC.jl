# https://adventofcode.com/2019/day/9
using AdventOfCode
include("intcode_computer.jl")
using .IntcodeComputers: IntcodeComputer, run_program!

input = readlines("data/2019/day_9.txt")

process_input(input) = parse.(Int, split(input[1], ","))
function part_1(input)
    tape = process_input(input)
    inp, out = Channel{Int}(1), Channel{Int}(1)
    c = IntcodeComputer(tape, inp, out)
    push!(inp, 1)
    run_program!(c)
    take!(out)
end
@info part_1(input)

function part_2(input)
    tape = process_input(input)
    inp, out = Channel{Int}(1), Channel{Int}(1)
    c = IntcodeComputer(tape, inp, out)
    push!(inp, 2)
    run_program!(c)
    take!(out)
end
@info part_2(input)
