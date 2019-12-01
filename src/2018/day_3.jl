input = readlines("data/2018/day_3.txt")

struct Claim
    id
    hor
    ver
    width
    height
end

function Claim(x)
    pattern = r"#(\d*) @ (\d*),(\d*): (\d*)x(\d*)"
    Claim(map(x -> parse(Int64, x), match(pattern, x).captures)...)
end

extent(c::Claim) = CartesianIndices((c.hor:(c.hor + c.width-1), c.ver:(c.ver + c.height-1)))

function part_1(input)
    regions = extent.(Claim.(input))
    counter = Dict()
    for region in regions
        for cell in region
            if cell in keys(counter)
                counter[cell] += 1
            else
                counter[cell] = 1
            end
        end
    end
    count(x -> x > 1, values(counter))
end

@info "Day 3, part 1: $(part_1(input))"

no_overlap(x, y) = isempty(intersect(x, y))

function part_2(input)
    regions = extent.(Claim.(input))
    @progress for i in 1:length(regions)
        other_regions = regions[setdiff(1:length(regions), [i])]
        if all(no_overlap.(Ref(regions[i]), other_regions))
            return i
        end
    end
end

@info "Day 3, part 2: $(part_2(input))"
