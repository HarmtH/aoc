using Test
using Combinatorics

readInput(inputFile = "input.txt") = readlines(joinpath(@__DIR__, inputFile))

function parseInput(inputData = readInput())
    map(inputData) do line
        map(split(line, " | ")) do part
            split(part)
        end
    end
end

function part1(parsedData = parseInput())
    lines = parsedData
    sum(map(lines) do line
        sum([length(digit) in [2,4,3,7] for digit in line[2]])
    end)
end

@testset "part 1" begin
    @test part1(parseInput(readInput("test1.txt"))) == 26
end

println(string("part 1: ", part1()))

function part2(parsedData = parseInput())
    lines = parsedData
    num2seg = [
        [1,2,3,5,6,7],
        [3,6],
        [1,3,4,5,7],
        [1,3,4,6,7],
        [2,3,4,6],
        [1,2,4,6,7],
        [1,2,4,5,6,7],
        [1,3,6],
        [1,2,3,4,5,6,7],
        [1,2,3,4,6,7]
    ]
    res = 0
    origarrarr = map(line -> (sort(map(line[1]) do segstring
                                      sort(collect(segstring))
                                  end), line[2]), lines)
    for perm in permutations('a':'g')
        cmparr = sort(map(num2seg) do num
            sort(map(num) do seg
                perm[seg]
            end)
        end)
        for (origarr, segstrings) in origarrarr
            if cmparr == origarr
                ans = 0
                for segstring in segstrings
                    segs = sort(map(collect(segstring)) do c
                        only(findall(==(c), perm))
                    end)
                    num = only(findall(==(segs), num2seg)) - 1
                    ans = ans * 10 + num
                end
                res += ans
            end
        end
    end
    res
end

@testset "part 2" begin
    @test part2(parseInput(readInput("test1.txt"))) == 61229
end

println(string("part 2: ", part2()))
