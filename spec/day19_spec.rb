require 'day19'

RSpec.describe Day19 do
  it 'finds all distinct molecules that can be created with one replacement' do
    test1 = Day19.new(molecule: 'HOH', replacements: test_replacements)
    test2 = Day19.new(molecule: 'HOHOHO', replacements: test_replacements)

    expect(test1.distinct_molecules.size).to eq 4
    expect(test2.distinct_molecules.size).to eq 7
  end

  def test_replacements
    [
      'H => HO',
      'H => OH',
      'O => HH'
    ].join("\n")
  end
end
