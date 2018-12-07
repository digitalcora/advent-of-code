require_relative 'day11'

RSpec.describe Day11 do
  it 'finds Santa a new password that conforms to the corporate policy' do
    expect(Day11.new('abcdefgh').next_password).to eq 'abcdffaa'
    expect(Day11.new('ghijklmn').next_password).to eq 'ghjaabcc'
  end
end
