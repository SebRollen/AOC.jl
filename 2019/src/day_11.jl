# https://adventofcode.com/2019/day/11
using AdventOfCode, Colors
include("intcode_computer.jl")
using .IntcodeComputers: IntcodeComputer, run_program!

input = readlines("data/2019/day_11.txt")

process_input(input) = parse.(Int, split(input[1], ","))

mutable struct PaintingRobot
    computer :: IntcodeComputer
    map :: Dict{Complex{Int},Int64}
    loc :: Complex{Int}
    direction :: Complex{Int}
end

function PaintingRobot(computer, map)
    PaintingRobot(computer, map, 0 + 0im, im)
end

scan_paint(r::PaintingRobot) = get!(r.map, r.loc, 0)
change_paint!(r::PaintingRobot, color) = r.map[r.loc] = color
function turn!(r::PaintingRobot, direction)
    direction == 0 ? r.direction *= im : r.direction *= -im
    r.loc += r.direction
end
function part_1(input)
    tape = process_input(input)
    inp, out = Channel{Int}(Inf), Channel{Int}(Inf)
    c = IntcodeComputer(tape, inp, out)
    @async run_program!(c)
    map = Dict{Complex{Int}, Int}()
    r = PaintingRobot(c, map)
    while !r.computer.is_halted
        push!(inp, scan_paint(r))
        change_paint!(r, take!(out))
        turn!(r, take!(out))
    end
    return length(map)
end
@info part_1(input)

function part_2(input)
    tape = process_input(input)
    inp, out = Channel{Int}(Inf), Channel{Int}(Inf)
    c = IntcodeComputer(tape, inp, out)
    @async run_program!(c)
    map = Dict{Complex{Int},Int64}()
    map[0+0im] = 1
    r = PaintingRobot(c, map)
    while !r.computer.is_halted
        push!(inp, scan_paint(r))
        change_paint!(r, take!(out))
        turn!(r, take!(out))
    end
    xs, ys = real.(keys(map)), imag.(keys(map))
    max_x, min_x, max_y, min_y = maximum(xs), minimum(xs), maximum(ys), minimum(ys)
    img = zeros(Gray, (max_y - min_y+1, max_x - min_x+1))
    for coord in keys(map)
        img[max_y - imag(coord) + 1, real(coord) - min_x + 1] = Gray(map[coord])
    end
    img
end
part_2(input)
