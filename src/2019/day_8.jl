# https://adventofcode.com/2019/day/8
using AdventOfCode, Colors

input = readlines("data/2019/day_8.txt")

function parse_input(input, rows=6, cols=25)
    input = input[1]
    permutedims(reshape(parse.(Int, split(input, "")), (cols, rows, length(input) ÷ rows ÷ cols)), [2, 1, 3])
end

function part_1(input)
    layers = parse_input(input)
    num_zeros = vec(mapslices(x -> count(==(0), x), layers, dims = (1, 2)))
    fewest_zeros = argmin(num_zeros)
    mapreduce(i -> count(==(i), layers[:, :, fewest_zeros]), *, [1, 2])
end
@info part_1(input)

function part_2(input)
    layers = parse_input(input)
    opaque_layers = mapslices(x -> findfirst(!=(2), x), layers, dims = 3)
    img = zeros(Gray, size(opaque_layers))
    for j in 1:size(img, 2), i in 1:size(img, 1)
        img[i, j] = Gray(layers[i, j, :][opaque_layers[i, j]])
    end
    return reshape(img, size(img, 1), size(img, 2))
end
part_2(input)
