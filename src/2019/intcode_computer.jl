module IntcodeComputers

using OffsetArrays: OffsetArray

export process_tape

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
num_parameters(::END) = 0

@enum Mode Position Immediate Relative

function read_instruction(x)
    ds = digits(x, pad = 5)
    op = ds[2]*10+ds[1]
    modes = Mode.(ds[3:5])
    (OP_CODE_LOOKUP[op], modes)
end

function access_tape(tape, pos)
    if (pos+1) > length(tape)
        append!(tape, zeros(Int, pos-length(tape)+1))
    end
    tape[pos]
end

function write_tape(tape, pos, val)
    if (pos+1) > length(tape)
        append!(tape, zeros(Int, pos-length(tape)+1))
    end
    tape[pos] = val
end

function read_tape(tape, val, mode, base)
    if mode == Position
        return access_tape(tape, access_tape(tape, val))
    elseif mode == Immediate
        return access_tape(tape, val)
    elseif mode == Relative
        return access_tape(tape, base[] + access_tape(tape, val))
    else
        error("unexpected mode")
    end
end

function store_on_tape(tape, store_val, mode, base, read_val)
    if mode == Position
        write_tape(tape, access_tape(tape, store_val), read_val)
    elseif mode == Immediate
        error("Cannot store in immediate mode!")
    elseif mode == Relative
        write_tape(tape, base[] + access_tape(tape, store_val), read_val)
    else
        error("unexpected mode")
    end
end

reduce_and_store(op, tape, ptr, base, modes) = store_on_tape(tape, ptr[]+3, modes[3], base, op(read_tape(tape, ptr[]+1, modes[1], base), read_tape(tape, ptr[]+2, modes[2], base)))
jump_or_increment(op, tape, ptr, base, modes) = op(read_tape(tape, ptr[]+1, modes[1], base)) ? ptr[] = read_tape(tape, ptr[]+2, modes[2], base) : ptr[] += 3

operation(::ADD, tape, ptr, base, inp, out, modes) = reduce_and_store(+, tape, ptr, base, modes)
operation(::MUL, tape, ptr, base, inp, out, modes) = reduce_and_store(*, tape, ptr, base, modes)
operation(::INP, tape, ptr, base, inp, out, modes) = store_on_tape(tape, ptr[]+1, modes[1], base, take!(inp))
operation(::OUT, tape, ptr, base, inp, out, modes) = push!(out, read_tape(tape, ptr[]+1, modes[1], base))
operation(::JNZ, tape, ptr, base, inp, out, modes) = jump_or_increment(!=(0), tape, ptr, base, modes)
operation(::JEZ, tape, ptr, base, inp, out, modes) = jump_or_increment(==(0), tape, ptr, base, modes)
operation(::LES, tape, ptr, base, inp, out, modes) = reduce_and_store(<, tape, ptr, base, modes)
operation(::EQU, tape, ptr, base, inp, out, modes) = reduce_and_store(==, tape, ptr, base, modes)
operation(::REL, tape, ptr, base, inp, out, modes) = base[] += read_tape(tape, ptr[]+1, modes[1], base)
operation(::END, tape, ptr, base, inp, out, modes) = tape[0]

increment_ptr(op::OpCode) = 1 + num_parameters(op)
increment_ptr(op::JNZ) = 0
increment_ptr(op::JEZ) = 0

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

function process_tape(tape, inp, out)
    ptr = Ref(0)
    base = Ref(0)
    while true
        op, modes = read_instruction(tape[ptr[]])
        n = num_parameters(op)
        if op isa END
            break
        end
        operation(op, tape, ptr, base, inp, out, modes)
        ptr[] += increment_ptr(op)
    end
end

end
