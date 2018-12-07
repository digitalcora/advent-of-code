require_relative 'day25'

RSpec.describe Day25 do
  it 'finds the code at a given row and column of the code sheet' do
    expect(Day25.new(20151125).code_at(4, 3)).to be 21345942
  end
end
