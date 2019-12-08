# https://adventofcode.com/2019/day/7
using AdventOfCode, OffsetArrays, Combinatorics

input = readlines("data/2019/day_7.txt")

function process_input(input)
    OffsetArray(parse.(Int, split(input[1], ",")), -1)
end

function read_tape(tape, val, mode)
    if mode == 0
        return tape[tape[val]]
    elseif mode == 1
        return tape[val]
    else
        error("unexpected mode")
    end
end

function read_instruction(x)
    ds = digits(x, pad = 5)
    op = ds[2]*10+ds[1]
    modes = ds[3:5]
    (op, modes)
end

function intcode_computer(tape, inp, out)
    ptr = 0
    while true
        op, modes = read_instruction(tape[ptr])
        if op == 99
            return nothing
        elseif op == 1
            tape[tape[ptr+3]] = read_tape(tape, ptr+1, modes[1]) + read_tape(tape, ptr+2, modes[2])
            ptr += 4
        elseif op == 2
            tape[tape[ptr+3]] = read_tape(tape, ptr+1, modes[1]) * read_tape(tape, ptr+2, modes[2])
            ptr += 4
        elseif op == 3
            tape[tape[ptr+1]] = take!(inp)
            ptr += 2
        elseif op == 4
            push!(out, read_tape(tape, ptr+1, modes[1]))
            ptr += 2
        elseif op == 5
            if read_tape(tape, ptr+1, modes[1]) != 0
                ptr = read_tape(tape, ptr+2, modes[2])
            else
                ptr += 3
            end
        elseif op == 6
            if read_tape(tape, ptr+1, modes[1]) == 0
                ptr = read_tape(tape, ptr+2, modes[2])
            else
                ptr += 3
            end
        elseif op == 7
            tape[tape[ptr+3]] = read_tape(tape, ptr+1, modes[1]) < read_tape(tape, ptr+2, modes[2]) ? 1 : 0
            ptr += 4
        elseif op == 8
            tape[tape[ptr+3]] = read_tape(tape, ptr+1, modes[1]) == read_tape(tape, ptr+2, modes[2]) ? 1 : 0
            ptr += 4
        else
            error("Unexpected input")
        end
    end
end
function part_1(input)
    ps = permutations(0:4)
    thruster_signal = []
    for seq in ps
        tape = process_input(input)
        channels = [Channel{Int}(1) for _ in 1:6]
        for i in 1:5
            @async intcode_computer(copy(tape), channels[i], channels[i+1])
            push!(channels[i], seq[i])
        end
        push!(channels[1], 0)
        push!(thruster_signal, take!(channels[6]))
    end
    return maximum(thruster_signal)
end
@info part_1(input)

function part_2(input)
    ps = permutations(5:9)
    thruster_signal = []
    tape = process_input(input)
    for seq in ps
        channels = [Channel{Int}(1) for _ in 1:5]
        for i in 1:5
            @async intcode_computer(copy(tape), channels[i], channels[1+mod(i, 5)])
            push!(channels[i], seq[i])
        end
        push!(channels[1], 0)
        sleep(0.0001) # so as not to steal the input
        push!(thruster_signal, take!(channels[1]))
    end
    return maximum(thruster_signal)
end
part_2(input)
