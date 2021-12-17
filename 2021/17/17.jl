using Test

readInput(inputFile = "input.txt") = readlines(joinpath(@__DIR__, inputFile))

function parseInput(lines = readInput())
    (xx, yy) = split(lines[1], ",")
    xx = split(xx, "=")[2]
    yy = split(yy, "=")[2]
    (x1, x2) = parse.(Int, split(xx, ".."))
    (y1, y2) = parse.(Int, split(yy, ".."))
    (x1, x2, y1, y2)
end

function part1(parsedData = parseInput())
    (x1, x2, y1, y2) = parsedData
    local maxy
    for dy in 0:-y1
        y = 0
        loopmaxy = 0
        while y >= y1
            if y1 <= y <= y2
                maxy = loopmaxy
            end
            y += dy
            dy -= 1
            loopmaxy = max(loopmaxy, y)
        end
    end
    return maxy
end

@testset "part 1" begin
    @test part1(parseInput(readInput("test1.txt"))) == 45
end

println(string("part 1: ", part1()))

function part2(parsedData = parseInput())
    (x1, x2, y1, y2) = parsedData
    sum = 0
    for DY in y1:-y1
        for dx in 1:x2
            dy = DY
            (x, y) = (0, 0)
            while y >= y1 && x <= x2
                if y1 <= y <= y2 && x1 <= x <= x2
                    sum += 1
                    break
                end
                y += dy
                dy -= 1
                x += dx
                dx -= sign(dx)
            end
        end
    end
    sum
end

@testset "part 2" begin
    @test part2(parseInput(readInput("test1.txt"))) == 112
end

println(string("part 2: ", part2()))
