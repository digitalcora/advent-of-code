# --- Day 1: Not Quite Lisp ---

class Day1
  def initialize(directions)
    @directions = directions
  end

  def floor
    floor = 0

    @directions.each_char do |character|
      floor += 1 if character == '('
      floor -= 1 if character == ')'
    end

    floor
  end
end
