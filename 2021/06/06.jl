using Test

readInput(inputFile = "input.txt") = readlines(joinpath(@__DIR__, inputFile))

function parseInput(inputData = readInput())
    parse.(Int, split(inputData[1], ","))
end

function part1(parsedData = parseInput())
    fishes = parsedData
    M = zeros(Int, 9)
    for fish in fishes
        M[fish + 1] += 1
    end
    for _round in 1:80
        M = vcat(M[2:7], M[8] + M[1], M[9], M[1])
    end
    sum(M)
end

@testset "part 1" begin
    @test part1(parseInput(readInput("test1.txt"))) == 5934
end

println(string("part 1: ", part1()))

function part2(parsedData = parseInput())
    fishes = parsedData
    M = zeros(Int, 9)
    for fish in fishes
        M[fish + 1] += 1
    end
    for _round in 1:256
        M = vcat(M[2:7], M[8] + M[1], M[9], M[1])
    end
    sum(M)
end

@testset "part 2" begin
    @test part2(parseInput(readInput("test1.txt"))) == 26984457539
end

println(string("part 2: ", part2()))
