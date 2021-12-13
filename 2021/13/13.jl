using Test

readInput(inputFile = "input.txt") = readlines(joinpath(@__DIR__, inputFile))

function parseInput(inputData = readInput())
    lines = Iterators.Stateful(inputData)
    coords = []; foldcoords = []
    for line in lines
        line == "" && break
        push!(coords, (parse.(Int, split(line, ",")) .+ 1))
    end
    for line in lines
        (axis, pos) = split(split(line)[3], "=")
        pos = parse(Int, pos) + 1
        push!(foldcoords, (axis == "x" ? pos : typemax(Int),
                           axis == "y" ? pos : typemax(Int)))
    end
    coords, foldcoords
end

dofold(coords, foldcoord) =
    [ @. ifelse(coord > foldcoord, 2*foldcoord - coord, coord) for coord in coords ]

function part1(parsedData = parseInput())
    (coords, foldcoords) = parsedData
    dofold(coords, foldcoords[1]) |> unique |> length
end

@testset "part 1" begin
    @test part1(parseInput(readInput("test1.txt"))) == 17
end

println(string("part 1: ", part1()))

function coords2ascii(coords)
    CIs = [ CartesianIndex(reverse(coord)...) for coord in coords ]
    M = fill(" ", Tuple(maximum(CIs)))
    M[CIs] .= "#"
    join(mapslices(join, M, dims = 2), "\n")
end

function part2(parsedData = parseInput())
    (coords, foldcoords) = parsedData
    foldl(dofold, foldcoords, init = coords) |> coords2ascii
end

println(string("part 2:\n", part2()))
