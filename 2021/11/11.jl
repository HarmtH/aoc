using Test

readInput(inputFile = "input.txt") = readlines(joinpath(@__DIR__, inputFile))

function parseInput(inputData = readInput())
    Y, X = (length(inputData), length(inputData[1]))
    reshape(parse.(Int8, vcat((collect.(inputData))...)), X, Y)
end

function part1(parsedData = parseInput())
    M = parsedData
    (Y, X) = size(M)
    flashes = 0
    for _ in 1:100
        mask = ones(Bool, Y, X)
        flashed = zeros(Bool, Y, X)
        while any(mask)
            M[mask] .+= 1
            mask = (M .>= 10) .& .~flashed
            flashed .|= mask
            for c in findall(mask)
                M[max(1, c[1] - 1):min(Y, c[1] + 1),
                  max(1, c[2] - 1):min(X, c[2] + 1)] .+= 1
            end
        end
        flashes += sum(flashed)
        M[flashed] .= 0
    end
    flashes
end

@testset "part 1" begin
    @test part1(parseInput(readInput("test1.txt"))) == 1656
end

println(string("part 1: ", part1()))

function part2(parsedData = parseInput())
    M = parsedData
    (Y, X) = size(M)
    for round in 1:typemax(Int)
        mask = ones(Bool, Y, X)
        flashed = zeros(Bool, Y, X)
        while any(mask)
            M[mask] .+= 1
            mask = (M .>= 10) .& .~flashed
            flashed .|= mask
            for c in findall(mask)
                M[max(1, c[1] - 1):min(Y, c[1] + 1),
                  max(1, c[2] - 1):min(X, c[2] + 1)] .+= 1
            end
        end
        if all(flashed)
            return round
        end
        M[flashed] .= 0
    end
    @assert false
end

@testset "part 2" begin
    @test part2(parseInput(readInput("test1.txt"))) == 195
end

println(string("part 2: ", part2()))
