# https://adventofcode.com/2019/day/9
using AdventOfCode, OffsetArrays
include("intcode_computer.jl")
using .IntcodeComputers: process_tape

input = readlines("data/2019/day_9.txt")

function process_input(input)
    OffsetArray(parse.(Int, split(input[1], ",")), -1)
end

function part_1(input)
    tape = process_input(input)
    inp, out = Channel{Int}(1), Channel{Int}(1)
    push!(inp, 1)
    process_tape(tape, inp, out)
    take!(out)
end
@info part_1(input)

function part_2(input)
    tape = process_input(input)
    inp, out = Channel{Int}(1), Channel{Int}(1)
    push!(inp, 2)
    process_tape(tape, inp, out)
    take!(out)
end
@info part_2(input)
