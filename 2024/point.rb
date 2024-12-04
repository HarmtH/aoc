class Point
  attr_accessor :y, :x

  def initialize(y, x)
    @y = y
    @x = x
  end

  def +(p)
    Point.new(@y + p.y, @x + p.x)
  end

  def <<(p)
    @y += p.y
    @x += p.x
  end

  def to_s
    "(#{@y}, #{@x})"
  end

  N = Point.new(-1, 0).freeze
  E = Point.new( 0, 1).freeze
  S = Point.new( 1, 0).freeze
  W = Point.new( 0,-1).freeze

  NE = (N + E).freeze
  SE = (S + E).freeze
  SW = (S + W).freeze
  NW = (N + W).freeze

  STRAIGHT_NEIGHBOURS = [N, E, S, W].freeze
  NEIGHBOURS = [N, NE, E, SE, S, SW, W, NW].freeze

  def valid_on?(grid)
     @y >= 0 && @y < grid.length &&
       @x >= 0 && @x < grid.length
  end

  def on!(grid)
    grid[@y][@x]
  end

  def on(grid)
    valid_on?(grid) && grid[@y][@x]
  end

  def self.each_on(grid)
    for y in 0...grid.length
      for x in 0..grid[0].length
        yield Point.new(y, x)
      end
    end
  end
end
