# https://adventofcode.com/2019/day/6
using AdventOfCode

input = readlines("data/2019/day_6.txt")
input = [
"COM)B",
"B)C",
"C)D",
"D)E",
"E)F",
"B)G",
"G)H",
"D)I",
"E)J",
"J)K",
"K)L",
"K)YOU",
"I)SAN"]
mutable struct Orbiter
    name
    parent
end

num_orbits(::Nothing, o) = 0
num_orbits(p::Orbiter, o::Orbiter) = 1 + num_orbits(p)
num_orbits(o::Orbiter) = num_orbits(o.parent, o)

parse_orbit(s::String) = split(s, ")")

function generate_map(orbits)
    seen_orbiters = Dict{String, Orbiter}()
    for (parent, child) in parse_orbit.(input)
        if parent in keys(seen_orbiters) && child in keys(seen_orbiters)
            seen_orbiters[child].parent = seen_orbiters[parent]
        elseif parent in keys(seen_orbiters)
            seen_orbiters[child] = Orbiter(child, seen_orbiters[parent])
        elseif child in keys(seen_orbiters)
            seen_orbiters[parent] = Orbiter(parent, nothing)
            seen_orbiters[child].parent = seen_orbiters[parent]
        else
            seen_orbiters[parent] = Orbiter(parent, nothing)
            seen_orbiters[child] = Orbiter(child, seen_orbiters[parent])
        end
    end
    return seen_orbiters
end

function part_1(input)
    orbits = parse_orbit.(input)
    orbit_map = generate_map(orbits)
    return mapreduce(num_orbits, +, values(orbit_map))
end
@info part_1(input)

parents(p::Orbiter, o) = vcat(p.name, parents(p))
parents(p::Nothing, o) = nothing
parents(o) = parents(o.parent, o)

function part_2(input)
    orbits = parse_orbit.(input)
    orbit_map = generate_map(orbits)
    p_y, p_s = map(parents, [orbit_map["YOU"], orbit_map["SAN"]])
    common_parent = intersect(p_y, p_s)[1]
    mapreduce(o -> findfirst(==(common_parent), o), +, [p_y, p_s]) - 2
end
@info part_2(input)
