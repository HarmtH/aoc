using Test

readInput(inputFile = "input.txt") = readlines(joinpath(@__DIR__, inputFile))

function parseInput(lines = readInput())
    lines[1] |> hex2bytes .|> bitstring |> join |> collect
end

bitparse = in -> parse(Int, in |> join, base = 2)

function parse1(bs)
    vsum = splice!(bs, 1:3) |> bitparse
    id = splice!(bs, 1:3) |> bitparse
    if id == 4
        while splice!(bs, 1:5)[1] == '1'
            # keep getting nibbles and increase parsed bytes
        end
    else
        lid = splice!(bs, 1:1) |> bitparse
        if lid == 0
            sublength = splice!(bs, 1:15) |> bitparse
            loldbs = length(bs)
            while loldbs - length(bs) < sublength
                (bs, dvsum) = parse1(bs)
                vsum += dvsum
            end
        elseif lid == 1
            subpackets = splice!(bs, 1:11) |> bitparse
            for _ in 1:subpackets
                (bs, dvsum) = parse1(bs)
                vsum += dvsum
            end
        end
    end
    bs, vsum
end

function part1(parsedData = parseInput())
    bs = parsedData # bitstring
    parse1(bs)[2]
end

@testset "part 1" begin
    @test part1(parseInput(["8A004A801A8002F478"])) == 16
    @test part1(parseInput(["620080001611562C8802118E34"])) == 12
end

println(string("part 1: ", part1()))

function parse2(bs)
    ver = splice!(bs, 1:3) |> bitparse
    id = splice!(bs, 1:3) |> bitparse
    if id == 4
        litval = ""
        group = "1"
        while group[1] == '1'
            group = splice!(bs, 1:5)
            litval *= group[2:5] |> join
        end
        res = litval |> bitparse
    else
        lid = splice!(bs, 1:1) |> bitparse
        packets = []
        if lid == 0
            sublength = splice!(bs, 1:15) |> bitparse
            loldbs = length(bs)
            while loldbs - length(bs) < sublength
                (bs, val) = parse2(bs)
                push!(packets, val)
            end
        elseif lid == 1
            subpackets = splice!(bs, 1:11) |> bitparse
            for _ in 1:subpackets
                (bs, val) = parse2(bs)
                push!(packets, val)
            end
        end
        op = Dict(0 => sum, 1 => prod, 2 => minimum, 3 => maximum,
                  5 => x -> >(x...), 6 => x -> <(x...), 7 => x -> ==(x...))
        res = op[id](packets)
    end
    bs, res
end

function part2(parsedData = parseInput())
    bs = parsedData # bitstring
    parse2(bs)[2]
end

@testset "part 2" begin
    @test part2(parseInput(["C200B40A82"])) == 3
    @test part2(parseInput(["04005AC33890"])) == 54
    @test part2(parseInput(["880086C3E88112"])) == 7
    @test part2(parseInput(["CE00C43D881120"])) == 9
    @test part2(parseInput(["D8005AC2A8F0"])) == 1
    @test part2(parseInput(["F600BC2D8F"])) == 0
    @test part2(parseInput(["9C005AC2F8F0"])) == 0
    @test part2(parseInput(["9C0141080250320F1802104A08"])) == 1
end

println(string("part 2: ", part2()))
