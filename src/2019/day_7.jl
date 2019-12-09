# https://adventofcode.com/2019/day/7
using AdventOfCode, Combinatorics, OffsetArrays
include("intcode_computer.jl")
using .IntcodeComputers: process_tape

input = readlines("data/2019/day_7.txt")

function process_input(input)
    OffsetArray(parse.(Int, split(input[1], ",")), -1)
end

function part_1(input)
    tape = process_input(input)
    ps = permutations(0:4)
    thruster_signal = []
    for seq in ps
        channels = [Channel{Int}(1) for _ in 1:6]
        for i in 1:5
            push!(channels[i], seq[i])
            @async process_tape(copy(tape), channels[i], channels[i+1])
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
            @async process_tape(copy(tape), channels[i], channels[1+mod(i, 5)])
            push!(channels[i], seq[i])
        end
        push!(channels[1], 0)
        sleep(0.0001) # so as not to steal the input
        push!(thruster_signal, take!(channels[1]))
    end
    return maximum(thruster_signal)
end
part_2(input)
