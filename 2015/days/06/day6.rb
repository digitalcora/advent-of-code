class Day6
  def initialize(instructions)
    @instructions = instructions.each_line.map do |instruction|
      instruction.match(/
        (?<action>turn\ on|turn\ off|toggle)\s
        (?<x1>\d+),(?<y1>\d+)\s
        through\s
        (?<x2>\d+),(?<y2>\d+)
      /x)
    end
  end

  def lit_count
    lights = create_lights(initial_state: false) do |action, current_state|
      case action
      when 'turn on' then true
      when 'turn off' then false
      when 'toggle' then !current_state
      end
    end

    lights.flatten.count(true)
  end

  def brightness
    lights = create_lights(initial_state: 0) do |action, current_state|
      case action
      when 'turn on' then current_state + 1
      when 'turn off' then [0, current_state - 1].max
      when 'toggle' then current_state + 2
      end
    end

    lights.flatten.reduce(:+)
  end

  private

  def create_lights(initial_state:)
    lights = Array.new(1000){ Array.new(1000, initial_state) }

    @instructions.each do |instruction|
      instruction[:x1].to_i.upto(instruction[:x2].to_i) do |x|
        instruction[:y1].to_i.upto(instruction[:y2].to_i) do |y|
          lights[x][y] = yield(instruction[:action], lights[x][y])
        end
      end
    end

    lights
  end
end
