# --- Day 1: Not Quite Lisp ---

class Day1
  def initialize(directions)
    raise 'invalid input' unless directions =~ /^[()]*$/
    @directions = directions
  end

  def final_floor
    @directions.count('(') - @directions.count(')')
  end

  def basement_position
    /^(\(\g<1>*\))*\)/.match(@directions)&.end(0)
  end
end
