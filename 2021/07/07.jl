using Test

readInput(inputFile = "input.txt") = readlines(joinpath(@__DIR__, inputFile))

function parseInput(inputData = readInput())
    parse.(Int, split(inputData[1], ","))
end

function part1(parsedData = parseInput())
    crabs = parsedData
    mapreduce(min, 1:maximum(crabs)) do i
        sum(abs.(crabs .- i))
    end
end

@testset "part 1" begin
    @test part1(parseInput(readInput("test1.txt"))) == 37
end

println(string("part 1: ", part1()))

function part2(parsedData = parseInput())
    crabs = parsedData
    mapreduce(min, 1:maximum(crabs)) do i
        sum(map(crab -> sum(0:abs(crab - i)), crabs))
    end
end

@testset "part 2" begin
    @test part2(parseInput(readInput("test1.txt"))) == 168
end

println(string("part 2: ", part2()))
