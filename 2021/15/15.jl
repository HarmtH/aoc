using Test
using DataStructures
CI=CartesianIndex

readInput(inputFile = "input.txt") = readlines(joinpath(@__DIR__, inputFile))

function parseInput(lines = readInput())
    M = zeros(Int8, length(lines), length(lines[1]))
    for (i, line) in enumerate(lines)
        M[i, :] = parse.(Int8, collect(line))
    end
    M
end

function part1(parsedData = parseInput())
    M = parsedData
    M[M .>= 10] .-= 9
    Y, X = size(M)
    R = fill(-1, Y, X)
    pq = PriorityQueue{CI, Int}()
    pq[CI(1, 1)] = 0
    dirs = map(CI, ((1, 0), (-1, 0), (0, 1), (0, -1)))
    while R[Y, X] == -1
        (c, r) = dequeue_pair!(pq)
        R[c] != -1 && continue
        R[c] = r
        for C in filter(in -> checkbounds(Bool, M, in), Ref(c) .+ dirs)
            p = R[c] + M[C]
            if C ∉ keys(pq) || pq[C] > p
                pq[C] = p
            end
        end
    end
    R[Y, X]
end

@testset "part 1" begin
    @test part1(parseInput(readInput("test1.txt"))) == 40
end

println(string("part 1: ", part1()))

function part2(parsedData = parseInput())
    M = parsedData
    M = [M M.+1 M.+2 M.+3 M.+4]
    M = [M; M.+1; M.+2; M.+3; M.+4]
    M[M .>= 10] .-= 9
    Y, X = size(M)
    R = fill(-1, Y, X)
    pq = PriorityQueue{CI, Int}()
    pq[CI(1, 1)] = 0
    dirs = map(CI, ((1, 0), (-1, 0), (0, 1), (0, -1)))
    while R[Y, X] == -1
        (c, r) = dequeue_pair!(pq)
        R[c] != -1 && continue
        R[c] = r
        for C in filter(in -> checkbounds(Bool, M, in), Ref(c) .+ dirs)
            p = R[c] + M[C]
            if C ∉ keys(pq) || pq[C] > p
                pq[C] = p
            end
        end
    end
    R[Y, X]
end

@testset "part 2" begin
    @test part2(parseInput(readInput("test1.txt"))) == 315
end

println(string("part 2: ", part2()))
