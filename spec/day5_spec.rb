require 'day5'

RSpec.describe Day5 do
  it 'determines how many strings in the input are nice' do
    expect(Day5.new('ugknbfddgicrmopn').nice_count).to eq 1
    expect(Day5.new('aaa').nice_count).to eq 1
    expect(Day5.new('jchzalrnumimnmhp').nice_count).to eq 0
    expect(Day5.new('haegwjzuvuyypxyu').nice_count).to eq 0
    expect(Day5.new('dvszwmarrgswjxmb').nice_count).to eq 0
    expect(Day5.new("aaa\njchzalrnumimnmhp").nice_count).to eq 1
  end
end
