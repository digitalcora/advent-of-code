# --- Day 10: Elves Look, Elves Say ---

class Day10
  def initialize(first_value)
    @first_value = first_value
  end

  def look_and_say
    Enumerator.new do |yielder|
      value = @first_value

      loop do
        yielder << value
        value = value.gsub(/(.)\1*/){ |digits| digits.length.to_s + digits[0] }
      end
    end
  end
end
