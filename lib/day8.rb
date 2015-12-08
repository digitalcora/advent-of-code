# --- Day 8: Matchsticks ---

class Day8
  def initialize(strings)
    @strings = strings.split("\n")
  end

  def overhead
    in_memory_length = @strings.reduce(0) do |length, string|
      length += string.gsub(/\\(\\|"|x\h{2})/, '.').length - 2
    end

    @strings.join.length - in_memory_length
  end
end
