# https://adventofcode.com/2019/day/12
using AdventOfCode, StaticArrays

input = readlines("data/2019/day_12.txt")

mutable struct Moon
    position :: SVector{3, Int}
    velocity :: SVector{3, Int}
end

Moon(position) = Moon(position, SVector((0, 0, 0)))

pos_pattern = r"x=(-?\d*), y=(-?\d*), z=(-?\d*)"
parse_input(input_line) = parse.(Int, match(pos_pattern, input_line).captures)

function apply_gravity!(m1::Moon, m2::Moon)
    δv = sign.(m1.position .- m2.position)
    m1.velocity = m1.velocity .- δv
    m2.velocity = m2.velocity .+ δv
end

function apply_gravity!(moons::Vector{Moon})
    n = length(moons)
    for i in 1:n, j in 1:i
        if i != j
            apply_gravity!(moons[i], moons[j])
        end
    end
end

apply_velocity!(m::Moon) = m.position += m.velocity

calculate_energy(m::Moon) = sum(abs.(m.position)) * sum(abs.(m.velocity))

function part_1(input)
    moons = Moon.(SVector{3}.(parse_input.(input)))
    for i in 1:1000
        apply_gravity!(moons)
        apply_velocity!.(moons)
    end
    sum(calculate_energy.(moons))
end
@info part_1(input)

get_positions(moons, axis) = getindex.(getfield.(moons, :position), axis)
get_velocities(moons, axis) = getindex.(getfield.(moons, :velocity), axis)

function part_2(input)
    moons = Moon.(SVector{3}.(parse_input.(input)))
    cycles = zeros(Int, 3)
    for axis in 1:3
        start_pos = (get_positions(moons, axis), get_velocities(moons, axis))
        apply_gravity!(moons)
        apply_velocity!.(moons)
        it = 1
        while (get_positions(moons, axis), get_velocities(moons, axis)) != start_pos
            apply_gravity!(moons)
            apply_velocity!.(moons)
            it += 1
        end
        cycles[axis] = it
    end
    lcm(cycles)
end
@info part_2(input)
