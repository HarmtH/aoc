class Point
  attr_accessor :y, :x

  def initialize(y, x)
    @y = y
    @x = x
  end

  def +(p)
    Point.new(@y + p.y, @x + p.x)
  end

  def -(p)
    Point.new(@y - p.y, @x - p.x)
  end

  def *(t)
    if t == :right
      Point.new(@x, -@y)
    elsif t == :left
      Point.new(-@x, @y)
    else
      throw "Illegal direction"
    end
  end

  def to_s
    "(#{@y}, #{@x})"
  end

  def eql?(p)
    @y == p.y && @x == p.x
  end
  alias == eql?

  def hash
    [@y, @x].hash
  end

  N = Point.new(-1, 0).freeze
  E = Point.new( 0, 1).freeze
  S = Point.new( 1, 0).freeze
  W = Point.new( 0,-1).freeze

  NE = (N + E).freeze
  SE = (S + E).freeze
  SW = (S + W).freeze
  NW = (N + W).freeze

  STRAIGHT_DIRS = [N, E, S, W].freeze
  DIRS = [N, NE, E, SE, S, SW, W, NW].freeze

  def neighbours
    DIRS.map{|dp| self + dp}
  end

  def straight_neighbours
    STRAIGHT_DIRS.map{|dp| self + dp}
  end
end
