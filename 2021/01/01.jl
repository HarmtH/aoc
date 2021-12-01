using Test
using IterTools

readInput(inputFile = "input.txt") = read(joinpath(@__DIR__, inputFile), String)

parseInput(inputData = readInput()) = parse.(Int, split(inputData))

function part1(parsedData = parseInput())
    sum(diff(parsedData) .> 0)
end

@testset "part 1" begin
    @test part1(parseInput(readInput("test1.txt"))) == 7
end

println(string("part 1: ", part1()))

function part2(parsedData = parseInput())
    win = sum.(partition(parsedData, 3, 1))
    sum(diff(win) .> 0)
end

@testset "part 2" begin
    @test part2(parseInput(readInput("test1.txt"))) == 5
end

println(string("part 2: ", part2()))
