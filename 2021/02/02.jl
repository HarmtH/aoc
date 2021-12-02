using Test

readInput(inputFile = "input.txt") = split(strip(read(joinpath(@__DIR__, inputFile), String), '\n'), '\n')

function parseInput(inputData = readInput())
    data = split.(inputData, ' ')
    (((cmd, amt), ) -> (cmd, parse(Int, amt))).(data)
end

function part1(parsedData = parseInput())
    (y, x) = (0, 0)
    for (dir, amt) in parsedData
        if dir == "forward"
            x += amt
        elseif dir == "up"
            y -= amt
        elseif dir == "down"
            y += amt
        end
    end
    y * x
end

@testset "part 1" begin
    @test part1(parseInput(readInput("test1.txt"))) == 150
end

println(string("part 1: ", part1()))

function part2(parsedData = parseInput())
    aim = 0
    (y, x) = (0, 0)
    for (dir, amt) in parsedData
        if dir == "forward"
            x += amt
            y += aim * amt
        elseif dir == "up"
            aim -= amt
        elseif dir == "down"
            aim += amt
        end
    end
    y * x
end

@testset "part 2" begin
    @test part2(parseInput(readInput("test1.txt"))) == 900
end

println(string("part 2: ", part2()))
