using Test
using Memoize
CI = CartesianIndex

readInput(inputFile = "input.txt") = readlines(joinpath(@__DIR__, inputFile))

function parseInput(inputData = readInput())
    M = zeros(Int8, length(inputData), length(inputData[1]))
    for (i, line) in enumerate(inputData)
        for (j, num) in enumerate(parse.(Int8, collect(line)))
            M[i, j] = num
        end
    end
    M
end

function adjacentCoords(M, c)
    Y, X = size(M)
    filter(map(dc -> c+dc, [CI(-1, 0), CI(1, 0), CI(0, 1), CI(0, -1)])) do cc
        cc[1] >= 1 && cc[1] <= Y && cc[2] >= 1 && cc[2] <= X
    end
end

@memoize function adjCoordsMatrix(M)
    map(in -> adjacentCoords(M, in), CartesianIndices(M))
end

function basinSize(M, lowcoord)
    size = 1
    todo = adjCoordsMatrix(M)[lowcoord]
    done = Set()
    push!(done, lowcoord)
    while length(todo) > 0
        c = pop!(todo)
        if c in done; continue; end
        push!(done, c)
        if M[c] != 9
            size += 1
            push!(todo, adjCoordsMatrix(M)[c]...)
        end
    end
    size
end

isSmallest = (c, nbs) -> all(nb -> c < nb, nbs)

lowCoordsMask = M -> isSmallest.(M, [M[c] for c in adjCoordsMatrix(M)])

function part1(parsedData = parseInput())
    M = parsedData
    lowvals = M[lowCoordsMask(M)]
    risklevels = lowvals .+ 1
    sum(risklevels)
end

@testset "part 1" begin
    @test part1(parseInput(readInput("test1.txt"))) == 15
end

println(string("part 1: ", part1()))

function part2(parsedData = parseInput())
    M = parsedData
    basinsizes = map(in -> basinSize(M, in), findall(lowCoordsMask(M)))
    threelargestbasins = sort(basinsizes)[end - 2:end]
    prod(threelargestbasins)
end

@testset "part 2" begin
    @test part2(parseInput(readInput("test1.txt"))) == 1134
end

println(string("part 2: ", part2()))
