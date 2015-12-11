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

        value = ''.tap do |next_value|
          value.scan(/((.)\2*)/).each do |digits, digit|
            next_value << digits.length.to_s << digit
          end
        end
      end
    end
  end
end
