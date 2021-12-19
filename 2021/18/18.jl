using Test
using Combinatorics

readInput(inputFile = "input.txt") = readlines(joinpath(@__DIR__, inputFile))

# parse input into an array of "[]," or an integer
function parseInput(lines = readInput())
    [[isdigit(c) ? parse(Int, c) : c for c in line] for line in lines]
end

function add(num1, num2)
    ['[', num1..., ',', num2..., ']']
end

function explode!(s)
    depth = 0
    for (pos, c) in enumerate(s)
        if c == '['
            depth += 1
            if depth == 5
                (_, l, _, r, _) = splice!(s, pos:pos+4, 0)
                lpos = findlast(in -> isa(in, Number), s[1:pos-1])
                if lpos != nothing
                    s[lpos] += l
                end
                rposrel = findfirst(in -> isa(in, Number), s[pos+1:end])
                if rposrel != nothing
                    rpos = pos + rposrel
                    s[rpos] += r
                end
                return true
            end
        elseif c == ']'
            depth -= 1
        end
    end
    false
end

function split!(s)
    pos = findfirst(in -> isa(in, Number) && in >= 10, s)
    if pos != nothing
        num = s[pos]
        splice!(s, pos, ['[', num÷2, ',', num÷2 + isodd(num), ']'])
        return true
    end
    false
end

function magn(s)
    # loop until we have an array with a single number
    while length(s) != 1
        for i in 1:length(s) - 4
            # search for a pair consisting of two numbers
            if typeof(s[i+1]) <: Number && typeof(s[i+3]) <: Number
                splice!(s, i:i+4, 3s[i+1] + 2s[i+3])
                # we have to break, because we shortened s
                break
            end
        end
    end
    only(s)
end

function part1(parsedData = parseInput())
    snailnums = parsedData
    snailnum = snailnums[1]
    for newnum in snailnums[2:end]
        snailnum = add(snailnum, newnum)
        while explode!(snailnum) || split!(snailnum)
        end
    end
    magn(snailnum)
end

@testset "part 1" begin
    @test part1(parseInput(readInput("test1.txt"))) == 4140
end

println(string("part 1: ", part1()))

function part2(parsedData = parseInput())
    snailnums = parsedData
    maxy = 0
    for (num1, num2) in permutations(snailnums, 2)
        snailnum = add(num1, num2)
        while explode!(snailnum) || split!(snailnum)
        end
        maxy = max(maxy, magn(snailnum))
    end
    maxy
end

@testset "part 2" begin
    @test part2(parseInput(readInput("test1.txt"))) == 3993
end

println(string("part 2: ", part2()))
