using Test

readInput(inputFile = "input.txt") = readlines(joinpath(@__DIR__, inputFile))

function parseInput(inputData = readInput())
    parse.(Int, inputData, base = 2), length(inputData[1])
end

function powerConsumption(data, maxBits, comp)
    res = 0
    for i in 0:maxBits-1
        mask = 1<<i
        nhigh = sum((data .& mask) .> 0)
        nlow = sum((data .& mask) .== 0)
        if comp(nhigh, nlow)
            res |= mask
        end
    end
    res
end

function part1(parsedData = parseInput())
    data, maxBits = parsedData
    gamma = powerConsumption(data, maxBits, >)
    epsilon = powerConsumption(data, maxBits, <)
    gamma * epsilon
end

@testset "part 1" begin
    @test part1(parseInput(readInput("test1.txt"))) == 198
end

println(string("part 1: ", part1()))

function lifeSupport(data, maxBits, comp)
    for i in maxBits-1:-1:0
        if length(data) == 1
            break
        end
        mask = 1<<i
        high = (data .& mask) .> 0
        low = (data .& mask) .== 0
        nhigh = sum(high)
        nlow = sum(low)
        if comp(nhigh, nlow)
            data = data[high]
        else
            data = data[low]
        end
    end
    only(data)
end

function part2(parsedData = parseInput())
    data, maxBits = parsedData
    o2 = lifeSupport(data, maxBits, >=)
    co2 = lifeSupport(data, maxBits, <)
    o2 * co2
end

@testset "part 2" begin
    @test part2(parseInput(readInput("test1.txt"))) == 230
end

println(string("part 2: ", part2()))
