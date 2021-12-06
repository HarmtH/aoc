using Test
CI = CartesianIndex
T = Tuple

readInput(inputFile = "input.txt") = readlines(joinpath(@__DIR__, inputFile))

function parseInput(inputData = readInput())
    map(inputData) do line
        map(split(line, " -> ")) do coords
           CI((parse.(Int, split(coords, ",")) .+ 1)...)
        end
    end
end

function part1(parsedData = parseInput())
    cloud = zeros(Int, 1000, 1000)
    for (c1, c2) in parsedData
        dc = CI(sign.(T(c2 - c1)))
        if !any(==(0), T(dc)); continue; end # diagonals
        while c1 != c2 + dc
            cloud[c1] += 1
            c1 += dc
        end
    end
    sum(cloud .> 1)
end

@testset "part 1" begin
    @test part1(parseInput(readInput("test1.txt"))) == 5
end

println(string("part 1: ", part1()))

function part2(parsedData = parseInput())
    cloud = zeros(Int, 1000, 1000)
    for (c1, c2) in parsedData
        dc = CI(sign.(T(c2 - c1)))
        while c1 != c2 + dc
            cloud[c1] += 1
            c1 += dc
        end
    end
    sum(cloud .> 1)
end

@testset "part 2" begin
    @test part2(parseInput(readInput("test1.txt"))) == 12
end

println(string("part 2: ", part2()))
