# https://adventofcode.com/2019/day/7
using AdventOfCode, Combinatorics
include("intcode_computer.jl")
using .IntcodeComputers: IntcodeComputer, run_program!

input = readlines("data/2019/day_7.txt")

process_input(input) = parse.(Int, split(input[1], ","))

function part_1(input)
    tape = process_input(input)
    ps = permutations(0:4)
    thruster_signal = []
    for seq in ps
        channels = [Channel{Int}(1) for _ in 1:6]
        for i in 1:5
            push!(channels[i], seq[i])
            c = IntcodeComputer(copy(tape), channels[i], channels[i+1])
            @async run_program!(c)
        end
        push!(channels[1], 0)
        push!(thruster_signal, take!(channels[6]))
    end
    return maximum(thruster_signal)
end
@info part_1(input)

function part_2(input)
    tape = process_input(input)
    ps = permutations(5:9)
    thruster_signal = []
    for seq in ps
        channels = [Channel{Int}(1) for _ in 1:5]
        for i in 1:5
            c = IntcodeComputer(copy(tape), channels[i], channels[1+mod(i, 5)])
            @async run_program!(c)
            push!(channels[i], seq[i])
        end
        push!(channels[1], 0)
        sleep(0.0001) # so as not to steal the input
        push!(thruster_signal, take!(channels[1]))
    end
    return maximum(thruster_signal)
end
@info part_2(input)
