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
struct END <: OpCode end

num_parameters(::ADD) = 3
num_parameters(::MUL) = 3
num_parameters(::INP) = 1
num_parameters(::OUT) = 1
num_parameters(::JNZ) = 2
num_parameters(::JEZ) = 2
num_parameters(::LES) = 3
num_parameters(::EQU) = 3
num_parameters(::END) = 0

function read_instruction(x)
    ds = digits(x, pad = 5)
    op = ds[2]*10+ds[1]
    modes = ds[3:5]
    (OP_CODE_LOOKUP[op], modes)
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

reduce_and_store(op, tape, ptr, modes) = tape[tape[ptr[]+3]] = op(read_tape(tape, ptr[]+1, modes[1]), read_tape(tape, ptr[]+2, modes[2]))
jump_or_increment(op, tape, ptr, modes) = op(read_tape(tape, ptr[]+1, modes[1])) ? ptr[] = read_tape(tape, ptr[]+2, modes[2]) : ptr[] += 3

operation(::ADD, tape, ptr, inp, out, modes) = reduce_and_store(+, tape, ptr, modes)
operation(::MUL, tape, ptr, inp, out, modes) = reduce_and_store(*, tape, ptr, modes)
operation(::INP, tape, ptr, inp, out, modes) = tape[tape[ptr[]+1]] = take!(inp)
operation(::OUT, tape, ptr, inp, out, modes) = push!(out, read_tape(tape, ptr[]+1, modes[1]))
operation(::JNZ, tape, ptr, inp, out, modes) = jump_or_increment(!=(0), tape, ptr, modes)
operation(::JEZ, tape, ptr, inp, out, modes) = jump_or_increment(==(0), tape, ptr, modes)
operation(::LES, tape, ptr, inp, out, modes) = reduce_and_store(<, tape, ptr, modes)
operation(::EQU, tape, ptr, inp, out, modes) = reduce_and_store(==, tape, ptr, modes)
operation(::END, tape, ptr, inp, out, modes) = tape[0]

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
    99 => END()
)

function process_tape(tape, inp, out)
    ptr = Ref(0)
    while true
        op, modes = read_instruction(tape[ptr[]])
        n = num_parameters(op)
        if op isa END
            break
        end
        operation(op, tape, ptr, inp, out, modes)
        ptr[] += increment_ptr(op)
    end
end

end
