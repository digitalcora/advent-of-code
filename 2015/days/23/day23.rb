class Day23
  attr_reader :registers

  def initialize(instructions, registers = {a: 0, b: 0})
    @registers = registers
    @instructions = instructions.each_line.map do |line|
      line.split(' ', 2).then do |(inst, rest)|
        [
          inst.strip.to_sym,
          rest.split(',').map(&:strip).map do |arg|
            case arg
            when /^[ab]$/ then arg.to_sym
            when /^(\+|-)\d+$/ then arg.to_i
            else raise "Unknown argument format: #{arg}"
            end
          end
        ]
      end
    end
  end

  def run!
    ip = 0

    while ip >= 0 && ip < @instructions.size
      ip += send(@instructions[ip][0], *@instructions[ip][1])
    end
  end

  private

  def hlf(register)
    @registers[register] /= 2
    1
  end

  def inc(register)
    @registers[register] += 1
    1
  end

  def jie(register, offset)
    @registers[register].even? ? offset : 1
  end

  def jio(register, offset)
    @registers[register] == 1 ? offset : 1
  end

  def jmp(offset)
    offset
  end

  def tpl(register)
    @registers[register] *= 3
    1
  end
end
