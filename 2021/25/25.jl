using Test

readInput(inputFile = "input.txt") = readlines(joinpath(@__DIR__, inputFile))

function parseInput(lines = readInput())
    M = fill(' ', length(lines), length(lines[1]))
    for (i, line) in enumerate(lines)
        M[i, :] = collect(line)
    end
    M
end

function part1(parsedData = parseInput())
    M = parsedData
    for i in 1:typemax(Int)
        oldM = M
        # move sea cucumbers right
        rM = [M[:, end:end] M[:, 1:end-1]]
        lM = [M[:, 2:end] M[:, 1:1]]
        newM = copy(M)
        @. newM[(M == '>') & (lM == '.')] = '.'
        @. newM[(M == '.') & (rM == '>')] = '>'
        M = newM
        # move sea cucumbers down
        dM = [M[end:end, :]; M[1:end-1, :]]
        uM = [M[2:end, :]; M[1:1, :]]
        newM = copy(M)
        @. newM[(M == 'v') & (uM == '.')] = '.'
        @. newM[(M == '.') & (dM == 'v')] = 'v'
        M = newM
        if M == oldM
            return i
        end
    end
    @assert false
end

@testset "part 1" begin
    @test part1(parseInput(readInput("test1.txt"))) == 58
end

println(string("part 1: ", part1()))
