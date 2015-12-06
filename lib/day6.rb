class Day6
  def initialize(instructions)
    @instructions = instructions.lines
  end

  def lit_count
    lights = Array.new(1000){ Array.new(1000, false) }

    @instructions.each do |instruction|
      instruction_parts = instruction.match(/
        (?<action>turn\ on|turn\ off|toggle)\s
        (?<x1>\d+),(?<y1>\d+)\s
        through\s
        (?<x2>\d+),(?<y2>\d+)
      /x)

      instruction_parts[:x1].to_i.upto(instruction_parts[:x2].to_i) do |x|
        instruction_parts[:y1].to_i.upto(instruction_parts[:y2].to_i) do |y|
          lights[x][y] = case instruction_parts[:action]
            when 'turn on' then true
            when 'turn off' then false
            when 'toggle' then !lights[x][y]
          end
        end
      end
    end

    lights.flatten.count(true)
  end
end
