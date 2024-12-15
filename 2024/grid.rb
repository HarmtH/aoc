require_relative 'point'

class Grid
  attr_accessor :data, :ys, :xs, :_v2p

  def initialize(ys: 0, xs: 0, multi: false)
    @data = multi ? Hash.new{|h, k| h[k] = []} : {}
    @multi = multi
    @ys = ys
    @xs = xs
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
        to_print = @data.fetch(Point[y, x], '.')
        to_print = to_print.size if to_print != '.' && @multi
        str += to_print.to_s
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

  def size()
    return @ys * @xs
  end

  def each_multi()
    return to_enum(:each_multi) unless block_given?
    @data.each { |p, a| a.each { |v| yield [p, v] } }
  end

  def sparse?()
    size != @data.size
  end

  def method_missing(name, *args, &block)
    if name != :[]
      @_v2p = nil
    end
    if name == :[]= || (name == :[] && @multi)
      @ys = [@ys, args[0].y + 1].max
      @xs = [@xs, args[0].x + 1].max
    end
    @data.send(name, *args, &block)
  end
end
