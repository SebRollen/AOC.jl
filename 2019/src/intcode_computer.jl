module IntcodeComputers

using OffsetArrays: OffsetArray

export IntcodeComputer, run_program!

mutable struct IntcodeComputer
    tape      :: OffsetArray{Int64,1,Array{Int64,1}}
    ptr       :: Int
    base      :: Int
    inp       :: Channel{Int}
    out       :: Channel{Int}
    is_halted :: Bool
end

function IntcodeComputer(tape::Vector{Int}, inp, out)
    IntcodeComputer(OffsetArray(tape, -1), 0, 0, inp, out, false)
end

abstract type OpCode end
struct ADD <: OpCode end
struct MUL <: OpCode end
struct INP <: OpCode end
struct OUT <: OpCode end
struct JNZ <: OpCode end
struct JEZ <: OpCode end
struct LES <: OpCode end
struct EQU <: OpCode end
struct REL <: OpCode end
struct END <: OpCode end

num_parameters(::ADD) = 3
num_parameters(::MUL) = 3
num_parameters(::INP) = 1
num_parameters(::OUT) = 1
num_parameters(::JNZ) = 2
num_parameters(::JEZ) = 2
num_parameters(::LES) = 3
num_parameters(::EQU) = 3
num_parameters(::REL) = 1

@enum Mode Position Immediate Relative

function read_instruction(c)
    instruction = c.tape[c.ptr]
    ds = digits(instruction, pad = 5)
    op = ds[2]*10+ds[1]
    modes = Mode.(ds[3:5])
    (OP_CODE_LOOKUP[op], modes)
end

function access_tape!(tape, pos)
    if (pos+1) > length(tape)
        append!(tape, zeros(Int, pos-length(tape)+1))
    end
    tape[pos]
end

function write_tape!(tape, pos, val)
    if (pos+1) > length(tape)
        append!(tape, zeros(Int, pos-length(tape)+1))
    end
    tape[pos] = val
end

function read_tape!(tape, val, mode, base)
    if mode == Position
        return access_tape!(tape, access_tape!(tape, val))
    elseif mode == Immediate
        return access_tape!(tape, val)
    elseif mode == Relative
        return access_tape!(tape, base + access_tape!(tape, val))
    else
        error("unexpected mode")
    end
end

function store_on_tape!(tape, store_val, mode, base, read_val)
    if mode == Position
        write_tape!(tape, access_tape!(tape, store_val), read_val)
    elseif mode == Immediate
        error("Cannot store in immediate mode!")
    elseif mode == Relative
        write_tape!(tape, base + access_tape!(tape, store_val), read_val)
    else
        error("unexpected mode")
    end
end

reduce_and_store!(op, c, modes) = store_on_tape!(c.tape, c.ptr+3, modes[3], c.base, op(read_tape!(c.tape, c.ptr+1, modes[1], c.base), read_tape!(c.tape, c.ptr+2, modes[2], c.base)))
jump_or_increment!(op, c, modes) = op(read_tape!(c.tape, c.ptr+1, modes[1], c.base)) ? c.ptr = read_tape!(c.tape, c.ptr+2, modes[2], c.base) : c.ptr += 3

operation!(::ADD, c, modes) = reduce_and_store!(+, c, modes)
operation!(::MUL, c, modes) = reduce_and_store!(*, c, modes)
operation!(::INP, c, modes) = store_on_tape!(c.tape, c.ptr+1, modes[1], c.base, take!(c.inp))
operation!(::OUT, c, modes) = push!(c.out, read_tape!(c.tape, c.ptr+1, modes[1], c.base))
operation!(::JNZ, c, modes) = jump_or_increment!(!=(0), c, modes)
operation!(::JEZ, c, modes) = jump_or_increment!(==(0), c, modes)
operation!(::LES, c, modes) = reduce_and_store!(<, c, modes)
operation!(::EQU, c, modes) = reduce_and_store!(==, c, modes)
operation!(::REL, c, modes) = c.base += read_tape!(c.tape, c.ptr+1, modes[1], c.base)
operation!(::END, c, modes) = c.is_halted = true

increment_ptr(op::OpCode) = 1 + num_parameters(op)
increment_ptr(op::Union{JNZ, JEZ, END}) = 0

const OP_CODE_LOOKUP = Dict(
    1  => ADD(),
    2  => MUL(),
    3  => INP(),
    4  => OUT(),
    5  => JNZ(),
    6  => JEZ(),
    7  => LES(),
    8  => EQU(),
    9  => REL(),
    99 => END()
)

function run_program!(c::IntcodeComputer)
    while !c.is_halted
        op, modes = read_instruction(c)
        operation!(op, c, modes)
        c.ptr += increment_ptr(op)
    end
end

end
