require_relative 'point'

class Grid
  attr_accessor :data, :ys, :xs, :_v2p

  def initialize()
    @data = Hash.new
    @xs = 0
    @ys = 0
    @_v2p = nil
  end

  def initialize_copy(orig_grid)
    @data = orig_grid.data.clone
    @ys = orig_grid.ys
    @xs = orig_grid.xs
    @_v2p = orig_grid._v2p
  end

  def <<(line)
    line = line.strip
    line.chars.each_with_index do |c, i|
      c = c.to_i if c.match(/\d/)
      @data[Point[@ys, i]] = c
    end
    @xs = [@xs, line.length].max
    @ys += 1
    @_v2p = nil
  end

  def to_s()
    str = ""
    @ys.times do |y|
      @xs.times do |x|
        str += @data[Point[y, x]] || '?'
      end
      str += "\n"
    end
    str
  end

  def v2p()
    return @_v2p if @_v2p
    @_v2p = Hash.new{|h, k| h[k] = []}
    @data.each{|p, v|
      @_v2p[v] << p
    }
    @_v2p
  end

  def method_missing(name, *args, &block)
    if name != :[]
      @_v2p = nil
    end
    @data.send(name, *args, &block)
  end
end
