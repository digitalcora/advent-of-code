class Day25
  def initialize(initial_code)
    @initial_code = initial_code
  end

  def code_at(target_row, target_col)
    row = 1
    col = 1
    code = @initial_code

    loop do
      break code if row == target_row && col == target_col

      if row == 1
        row = col + 1
        col = 1
      else
        row -= 1
        col += 1
      end

      code = code * 252533 % 33554393
    end
  end
end
