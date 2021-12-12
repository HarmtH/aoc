using Test

readInput(inputFile = "input.txt") = readlines(joinpath(@__DIR__, inputFile))

function parseInput(inputData = readInput())
    edges = Dict()
    for line in inputData
        (l, r) = split(line, "-")
        l != "end" && r != "start" && push!(get!(edges, l, []), r)
        r != "end" && l != "start" && push!(get!(edges, r, []), l)
    end
    edges["end"] = []
    edges
end

function part1(parsedData = parseInput())
    edges = parsedData
    todo = [["start"]]
    res = 0
    while !isempty(todo)
        doing = pop!(todo)
        for vertex = edges[doing[end]]
            if !islowercase(vertex[1]) || vertex ∉ doing
                push!(todo, [doing; vertex])
            end
        end
        doing[end] == "end" && (res += 1)
    end
    res
end

@testset "part 1" begin
    @test part1(parseInput(readInput("test1.txt"))) == 10
end

println(string("part 1: ", part1()))

function part2(parsedData = parseInput())
    edges = parsedData
    todo = [["joker", "start"]]
    res = 0
    while !isempty(todo)
        doing = pop!(todo)
        for vertex = edges[doing[end]]
            if !islowercase(vertex[1]) || vertex ∉ doing
                push!(todo, [doing; vertex])
            elseif doing[1] == "joker"
                push!(todo, [""; doing[2:end]; vertex])
            end
        end
        doing[end] == "end" && (res += 1)
    end
    res
end

@testset "part 2" begin
    @test part2(parseInput(readInput("test1.txt"))) == 36
end

println(string("part 2: ", part2()))
