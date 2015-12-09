# --- Day 1: Not Quite Lisp ---

class Day1
  def initialize(directions)
    @directions = directions
  end

  def final_floor
    @directions.count('(') - @directions.count(')')
  end

  def basement_position
    floor = 0

    @directions.each_char.with_index do |character, index|
      floor += 1 if character == '('
      floor -= 1 if character == ')'

      return index + 1 if floor < 0
    end

    nil
  end
end
