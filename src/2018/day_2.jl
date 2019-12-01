input = readlines("data/2018/day_2.txt")

function has_sequence(x, n = 2)
    char_dict = Dict()
    for char in split(x, "")
        if char in keys(char_dict)
            char_dict[char] += 1
        else
            char_dict[char] = 1
        end
    end
    for char in keys(char_dict)
        if char_dict[char] == n
            return true
        end
    end
    return false
end

function part_1(input)
    sum(has_sequence.(input, 2)) * sum(has_sequence.(input, 3))
end

@info "Day 2, part 1: $(part_1(input))"

function distance(a, b)
    count = 0
    for i in 1:length(a)
        if a[i] != b[i]
            count += 1
        end
    end
    return count
end

function common_letters(a, b)
    reduce(*, [x for (x, y) in zip(a, b) if x == y])
end

function part_2(input)
    for i in 2:length(input), j in 1:i
        if distance(input[i], input[j]) == 1
            return common_letters(input[i], input[j])
        end
    end
end

@info "Day 2, part 2: $(part_2(input))"
