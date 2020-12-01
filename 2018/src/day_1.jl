input = readlines("data/2018/day_1.txt")

function part_1(input)
    processed = parse.(Int64, input)
    return sum(processed)
end

function part_2(input)
    processed = parse.(Int64, input)
    encountered_frequencies = Set(0)
    current_frequency = 0
    for x in Iterators.Cycle(processed)
        current_frequency += x
        if current_frequency ∈ encountered_frequencies
            return current_frequency
        end
        push!(encountered_frequencies, current_frequency)
    end
end

@info "Day 1, part 1: $(part_1(input))"
@info "Day 1, part 2: $(part_2(input))"
