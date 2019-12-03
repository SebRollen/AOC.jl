# https://adventofcode.com/2019/day/2
using AdventOfCode
using OffsetArrays

input = readlines("data/2019/day_2.txt")
#input = ["1,9,10,3,2,3,11,0,99,30,40,50"]

function process_input(input)
    OffsetArray(parse.(Int, split(input[1], ",")), -1)
end

abstract type OpCode end
struct ADD <: OpCode end
struct MUL <: OpCode end
struct END <: OpCode end

num_parameters(::ADD) = 3
num_parameters(::MUL) = 3
num_parameters(::END) = 0

reduce_and_store(op, tape, x...) = tape[tape[x[3]]] = op(tape[tape[x[1]]], tape[tape[x[2]]])

operation(::ADD, tape, params...) = reduce_and_store(+, tape, params...)
operation(::MUL, tape, params...) = reduce_and_store(*, tape, params...)
operation(::END, tape, params...) = tape[0]

const OP_CODE_LOOKUP = Dict(
    1  => ADD(),
    2  => MUL(),
    99 => END()
)

function process_tape(tape)
    ptr = 0
    while true
        op = OP_CODE_LOOKUP[tape[ptr]]
        n = num_parameters(op)
        if op isa END
            return operation(op, tape)
        end
        operation(op, tape, (ptr+1):(ptr+n)...)
        ptr += n+1
    end
end

function part_1(input, noun, verb)
    tape = process_input(input)
    tape[1] = noun
    tape[2] = verb
    process_tape(tape)
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
