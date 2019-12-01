input = readline("data/2018/day_5.txt")

reaction(a, b) = lowercase(a) == lowercase(b) && a != b

function process_reduction(x)
    if reaction(x[1], x[2])
        return process_reduction(x[3:end])
    end
    for i in 3:(length(x)-1)
        if reaction(x[i-1], x[i])
            return process_reduction(x[1:i-2] * x[i+1:end])
        end
    end
    if reaction(x[end-1], x[end])
        return process_reduction(x[1:end-2])
    end
    return length(x)
end
@info "Day 5, part 1: $(process_reduction(input))"

function remove_unit(input, x)
    filter(input) do y
        y != x && y != uppercase(x)
    end
end

function part_2(input)
    unique_units = lowercase(input) |> unique
    mapreduce(min, unique_units) do unit
        process_reduction(remove_unit(input, unit))
    end
end

@info "Day 5, part 2: $(part_2(input))"
