# https://adventofcode.com/2019/day/5
using AdventOfCode
using OffsetArrays

input = readlines("data/2019/day_5.txt")

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

function part_1(input)
    tape = process_input(input)
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
            tape[tape[ptr+1]] = parse(Int, readline(stdin))
            ptr += 2
        elseif op == 4
            @info read_tape(tape, ptr+1, modes[1])
            ptr += 2
        else
            error("Unexpected input")
        end
    end
    error("Reached end of input with no return")
end

@info part_1(input)

function part_2(input)
    tape = process_input(input)
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
            tape[tape[ptr+1]] = parse(Int, readline(stdin))
            ptr += 2
        elseif op == 4
            @info read_tape(tape, ptr+1, modes[1])
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
part_2(input)
