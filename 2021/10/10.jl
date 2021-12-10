using Test

readInput(inputFile = "input.txt") = readlines(joinpath(@__DIR__, inputFile))

function parseInput(inputData = readInput())
    inputData
end

function part1(parsedData = parseInput())
    lines = parsedData
    c2p = Dict(
        ')' => 3,
        ']' => 57,
        '}' => 1197,
        '>' => 25137,
    )
    closechars = [')', ']', '}', '>']
    openchars = ['(', '[', '{', '<']
    res = 0
    for line in lines
        hist = []
        for c in line
            if c in openchars
                push!(hist, c)
            else
                comp = pop!(hist)
                if c != closechars[only(findall(==(comp), openchars))]
                    res += c2p[c]
                    break
                end
            end
        end
    end
    res
end

@testset "part 1" begin
    @test part1(parseInput(readInput("test1.txt"))) == 26397
end

println(string("part 1: ", part1()))

function part2(parsedData = parseInput())
    lines = parsedData
    c2p = Dict(
        '(' => 1,
        '[' => 2,
        '{' => 3,
        '<' => 4,
    )
    closechars = [')', ']', '}', '>']
    openchars = ['(', '[', '{', '<']
    hists = []
    for line in lines
        hist = []
        breaked = false
        for c in line
            if c in openchars
                push!(hist, c)
            else
                comp = pop!(hist)
                if c != closechars[findfirst(==(comp), openchars)]
                    breaked = true
                    break
                end
            end
        end
        if (!breaked)
            push!(hists, hist)
        end
    end
    sums = []
    for hist in hists
        sub = 0
        for lastopen in reverse(hist)
            sub *= 5
            sub += c2p[lastopen]
        end
        push!(sums, sub)
    end
    sort(sums)[Int((length(sums) + 1) // 2)]
end

@testset "part 2" begin
    @test part2(parseInput(readInput("test1.txt"))) == 288957
end

println(string("part 2: ", part2()))
