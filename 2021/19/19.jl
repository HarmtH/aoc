using Test
using Combinatorics

readInput(inputFile = "input.txt") = readlines(joinpath(@__DIR__, inputFile))

function parseInput(lines = readInput())
    res = [[]]
    for line in lines
        if line == ""
            push!(res, [])
            continue
        end
        if line[1:3] == "---"
            continue
        end
        push!(res[end], parse.(Int, split(line, ",")))
    end
    res
end

function rotations((x, y, z))
    (
    (x, y, z),
    (x, -y, -z),
    (x, z, -y),
    (x, -z, y),

    (-x, y, -z),
    (-x, -y, z),
    (-x, z, y),
    (-x, -z, -y),

    (y, x, -z),
    (y, -x, z),
    (y, z, x),
    (y, -z, -x),

    (-y, x, z),
    (-y, -x, -z),
    (-y, z, -x),
    (-y, -z, x),

    (z, y, -x),
    (z, -y, x),
    (z, x, y),
    (z, -x, -y),

    (-z, y, x),
    (-z, -y, -x),
    (-z, x, -y),
    (-z, -x, y),
    )
end

# returns [(scanner, rotation, (offset))]
function getscanners(scanlist)
    beaconpairs = map(beaconlist -> (permutations(beaconlist, 2)), scanlist)
    scanrotdiff = []
    scanrotpos = []
    for beaconpair in beaconpairs
        push!(scanrotdiff, [[] for i=1:24])
        push!(scanrotpos, [Dict() for i=1:24])
        for (rotbeacondiff, rotbeaconpos) in map(((diff, pos),) -> (rotations(diff), rotations(pos)), map(((a, b), )->(a - b, a), beaconpair))
            push!.(scanrotdiff[end], rotbeacondiff)
            setindex!.(scanrotpos[end], rotbeaconpos, rotbeacondiff)
        end
        scanrotdiff[end] = Set.(scanrotdiff[end])
    end
    done = Set()
    todo = Set([(1, 1, (0, 0, 0))]) # scanner, rotation, (offset)
    while length(todo) != 0
        doing = pop!(todo)
        if doing ∈ done; continue; end
        (scanner, rotation, (offset)) = doing
        for otherscanner in filter(!=(scanner), eachindex(scanlist))
            for otherrotation in 1:24
                isect = intersect(scanrotdiff[scanner][rotation], scanrotdiff[otherscanner][otherrotation])
                if length(isect) == 132
                    diff = pop!(isect)
                    pos = scanrotpos[scanner][rotation][diff]
                    otherpos = scanrotpos[otherscanner][otherrotation][diff]
                    push!(todo, (otherscanner, otherrotation, offset .+ (pos .- otherpos)))
                end
            end
        end
        push!(done, doing)
    end
    collect(done)
end

function part1(parsedData = parseInput())
    scanlist = parsedData
    allbeacons = Set()
    for (scanner, rotation, offset) in getscanners(scanlist)
        push!(allbeacons, [offset .+ rotations(in)[rotation] for in in scanlist[scanner]]...)
    end
    length(allbeacons)
end

@testset "part 1" begin
    @test part1(parseInput(readInput("test1.txt"))) == 79
end

println(string("part 1: ", part1()))

function part2(parsedData = parseInput())
    scanlist = parsedData
    themax = 0
    for ((_, _, pos1), (_, _, pos2)) in permutations(getscanners(scanlist), 2)
        themax = max(themax, sum(abs.(pos1 .- pos2)))
    end
    themax
end

@testset "part 2" begin
    @test part2(parseInput(readInput("test1.txt"))) == 3621
end

println(string("part 2: ", part2()))
