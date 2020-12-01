# https://adventofcode.com/2019/day/13
using AdventOfCode, OffsetArrays, REPL, REPL.TerminalMenus
include("intcode_computer.jl")
using .IntcodeComputers: IntcodeComputer, run_program!

input = readlines("data/2019/day_13.txt")
process_input(input) = parse.(Int, split(input[1], ","))

function part_1(input)
    tape = process_input(input)
    inp, out = Channel{Int}(Inf), Channel{Int}(Inf)
    c = IntcodeComputer(tape, inp, out)
    run_program!(c)
    close(out)
    sum(==(2), collect(out)[3:3:end])
end
@info part_1(input)

function draw(board)
    io = IOBuffer()
    for col in eachcol(board)
        for el in col
            if el == 0
                write(io, " ")
            elseif el == 1
                write(io, "|")
            elseif el == 2
                write(io, "#")
            elseif el == 3
                printstyled(IOContext(io, :color => true), "-", color=:green)
            elseif el == 4
                printstyled(IOContext(io, :color => true), "o", color=:red)
            else
                write(io, string(el))
            end
        end
        write(io, "\n")
    end
    println(String(take!(io)))
end

function update_board!(board, c)
    while isready(c)
        pos_x, pos_y, block = take!(c), take!(c), take!(c)
        board[pos_x, pos_y] = block
    end
    draw(board)
end

function part_2(input, play_local = false)
    tape = process_input(input)
    inp, out = Channel{Int}(Inf), Channel{Int}(Inf)
    tape[1] = 2
    c = IntcodeComputer(tape, inp, out)
    board = OffsetArray(zeros(Int, 44, 26), (-2, -1))
    @async run_program!(c)
    REPL.TerminalMenus.enableRawMode(REPL.TerminalMenus.terminal)
    update_board!(board, out)
    while !c.is_halted
        if play_local
            @async update_board!(board, out)
            key = REPL.TerminalMenus.readKey()
            if key == 1000
                push!(inp, -1)
            elseif key == 1002
                push!(inp, 0)
            elseif key == 1001
                push!(inp, 1)
            else
                @warn "Unrecognized key $key"
            end
        else
            update_board!(board, out)
            (paddle, ball) = (findfirst(==(3), board), findfirst(==(4), board))
            if paddle.I[1] > ball.I[1]
                push!(inp, -1)
            elseif paddle.I[1] < ball.I[1]
                push!(inp, 1)
            else
                push!(inp, 0)
            end
            update_board!(board, out)
        end
    end
    update_board!(board, out)
    return board[-1, 0]
end
@info part_2(input)
