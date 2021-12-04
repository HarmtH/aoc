using Test

readInput(inputFile = "input.txt") = readlines(joinpath(@__DIR__, inputFile))

function parseInput(inputData = readInput())
    drawns = parse.(Int, split(inputData[1], ','))
    boards = []
    masks = []
    local i
    for line in inputData[2:end]
        if line == ""
            push!(boards, Matrix{Int}(undef, 5, 5))
            push!(masks, zeros(Bool, 5, 5))
            i = 1
        else
            boards[end][i,:] = parse.(Int, split(line))
            i += 1
        end
    end
    drawns, boards, masks
end

function part1(parsedData = parseInput())
    drawns, boards, masks = parsedData
    for drawn in drawns
        for i in eachindex(boards)
            masks[i] .|= boards[i] .== drawn
            if any(map(j -> (all(masks[i][j,:]) || all(masks[i][:,j])), 1:5))
                return sum(boards[i] .* (!).(masks[i])) * drawn
            end
        end
    end
    @assert false
end

@testset "part 1" begin
    @test part1(parseInput(readInput("test1.txt"))) == 4512
end

println(string("part 1: ", part1()))

function part2(parsedData = parseInput())
    drawns, boards, masks = parsedData
    done = Set()
    for drawn in drawns
        for i in eachindex(boards)
            masks[i] .|= boards[i] .== drawn
            if any(map(j -> (all(masks[i][j,:]) || all(masks[i][:,j])), 1:5))
                push!(done, i)
            end
            if length(done) == length(boards)
                return sum(boards[i] .* (!).(masks[i])) * drawn
            end
        end
    end
    @assert false
end

@testset "part 2" begin
    @test part2(parseInput(readInput("test1.txt"))) == 1924
end

println(string("part 2: ", part2()))
