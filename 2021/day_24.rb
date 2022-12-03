#!/usr/bin/env ruby

def value(regs, val)
  val.is_a?(Integer) ? val : regs[val]
end

def step(regs, instruction, input)
  op, reg, val = instruction.values_at(:op, :reg, :val)

  case op
  when :inp
    regs[reg] = input
  when :mul
    regs[reg] *= value(regs, val)
  when :div
    regs[reg] /= value(regs, val)
  when :mod
    regs[reg] %= value(regs, val)
  when :add
    regs[reg] += value(regs, val)
  when :eql
    regs[reg] = regs[reg] == value(regs, val) ? 1 : 0
  end
end

def part1(program)
  alus = [
    [{ x: 0, y: 0, z: 0, w: 0 }, [0, 0]]
  ]

end

program = IO.readlines(ARGV[0], chomp: true).map do |l|
  op, reg, reg_or_val = l.split(" ")

  reg_or_val = if %w[x y z].include?(reg_or_val)
                 reg_or_val.to_sym
               else
                 reg_or_val.to_i
               end

  {
    op: op.to_sym,
    reg: reg.to_sym,
    val: reg_or_val,
  }
end


puts "Part1: #{part1(program)}"
