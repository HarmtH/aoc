using Test

readInput(inputFile = "input.txt") = readlines(joinpath(@__DIR__, inputFile))

function parseInput(lines = readInput())
    enhancer = replace(lines[1], '#'=>'1')
    enhancer = replace(enhancer, '.'=>'0')
    image = Dict()
    for (y, line) in enumerate(lines[3:end])
        for (x, c) in enumerate(line)
            if c == '#'
                image[(y, x)] = '1'
            elseif c == '.'
                image[(y, x)] = '0'
            else
                @assert false
            end
        end
    end
    enhancer, image
end

function part1(parsedData = parseInput())
    enhancer, image = parsedData
    default = '0'
    for _ in 1:50
        miny, maxy = extrema([c[1] for c in keys(image)])
        minx, maxx = extrema([c[2] for c in keys(image)])
        newimage = Dict()
        for y in miny-1:maxy+1
            for x in minx-1:maxx+1
                key = [ get(image, (y,x).+in, default) for in in ((-1,-1),(-1,0),(-1,1),(0,-1),(0,0),(0,1),(1,-1),(1,0),(1,1)) ] |> join
                key = parse(Int, key, base=2)
                newimage[(y,x)] = enhancer[key+1]
            end
        end
        default = enhancer[default == '0' ? 1 : 512]
        image = newimage
    end
    sum([ c == '1' for c in values(image) ])
end

@testset "part 1" begin
    @test part1(parseInput(readInput("test1.txt"))) == 3351
end

println(string("part 1: ", part1()))
