class Point
  attr_accessor :y, :x

  def self.[](y, x)
    return new(y, x)
  end

  def self.dir(d)
    case d
    when 'N', '^'
      self::N
    when 'E', '>'
      self::E
    when 'S', 'v'
      self::S
    when 'W', '<'
      self::W
    when 'NE'
      self::NE
    when 'SE'
      self::SE
    when 'SW'
      self::SW
    when 'NW'
      self::NW
    else
      throw "Illegal direction"
    end
  end

  def initialize(y, x)
    @y = y
    @x = x
  end

  def +(p)
    Point[@y + p.y, @x + p.x]
  end

  def -(p)
    Point[@y - p.y, @x - p.x]
  end

  def %(grid)
    Point[@y % grid.ys, @x % grid.xs]
  end

  def *(t)
    if t.is_a?(Symbol)
      if t == :right
        Point[@x, -@y]
      elsif t == :left
        Point[-@x, @y]
      else
        throw "Illegal direction"
      end
    else
      Point[t * @y, t * @x]
    end
  end

  def coerce(other)
    case other
    when Numeric
      return [self, other]
    else
      raise TypeError, "#{self.class} can't be coerced into #{other.class}"
    end
  end

  def to_s
    "(#{@y}, #{@x})"
  end
  alias inspect to_s

  def to_a
    [@y, @x]
  end

  def eql?(p)
    @y == p.y && @x == p.x
  end
  alias == eql?

  def hash
    [@y, @x].hash
  end

  N = self[-1, 0].freeze
  E = self[ 0, 1].freeze
  S = self[ 1, 0].freeze
  W = self[ 0,-1].freeze

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
