using Test
using DataStructures
using IterTools

readInput(inputFile = "input.txt") = readlines(joinpath(@__DIR__, inputFile))

function parseInput(lines = readInput())
    template = collect(lines[1])
    rules = Dict()
    for line in lines[3:end]
        rules[(line[1], line[2])] = line[7]
    end
    template, rules
end

function part1(parsedData = parseInput())
    (template, rules) = parsedData
    charcnts = DefaultDict(0, counter(template))
    paircnts = DefaultDict(0, counter(partition(template, 2, 1)))
    for _ in 1:10
        newpaircnts = DefaultDict(0)
        for (pair, paircnt) in paircnts
            newchar = rules[pair]
            charcnts[newchar] += paircnt
            newpaircnts[(pair[1], newchar)] += paircnt
            newpaircnts[(newchar, pair[2])] += paircnt
        end
        paircnts = newpaircnts
    end
    (min, max) = extrema(x->x[2], charcnts)
    max - min
end

@testset "part 1" begin
    @test part1(parseInput(readInput("test1.txt"))) == 1588
end

println(string("part 1: ", part1()))

function part2(parsedData = parseInput())
    (template, rules) = parsedData
    charcnts = DefaultDict(0, counter(template))
    paircnts = DefaultDict(0, counter(partition(template, 2, 1)))
    for _ in 1:40
        newpaircnts = DefaultDict(0)
        for (pair, paircnt) in paircnts
            newchar = rules[pair]
            charcnts[newchar] += paircnt
            newpaircnts[(pair[1], newchar)] += paircnt
            newpaircnts[(newchar, pair[2])] += paircnt
        end
        paircnts = newpaircnts
    end
    (min, max) = extrema(x->x[2], charcnts)
    max - min
end

@testset "part 2" begin
    @test part2(parseInput(readInput("test1.txt"))) == 2188189693529
end

println(string("part 2: ", part2()))
