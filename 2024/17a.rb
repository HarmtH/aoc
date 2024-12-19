#!/usr/bin/ruby

class Computer
  attr_accessor :program, :regs, :ip, :out
  A = 4; B = 5; C = 6

  def initialize()
    @regs = [0, 1, 2, 3]
    @out = []
    @ip = 0
    section = 0
    ARGF.each_line do |line|
      if line == "\n"
        section += 1
      elsif section == 0
        @regs << line[/\d+/].to_i
      else
        @program = line.scan(/\d+/).map(&:to_i)
      end
    end
  end

  def step()
    operand = program[@ip + 1]
    case program[@ip]
    when 0 # adv
      @regs[A] = @regs[A] / (2 ** @regs[operand])
    when 1 # bxl
      @regs[B] = @regs[B] ^ operand
    when 2 # bst
      @regs[B] = @regs[operand] % 8
    when 3 # jnz
      @ip = operand - 2 if @regs[A] != 0
    when 4 # bxc
      @regs[B] = @regs[B] ^ @regs[C]
    when 5 # out
      @out += [@regs[operand] % 8]
    when 6 # bdv
      @regs[B] = @regs[A] / 2 ** @regs[operand]
    when 7 # cdv
      @regs[C] = @regs[A] / 2 ** @regs[operand]
    end
    @ip += 2
  end

  def run()
    while @ip < @program.size - 1
      step
    end
  end

  def print()
    puts @out.join(',')
  end
end

computer = Computer.new
computer.run
computer.print
