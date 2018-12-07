require_relative 'day19'

RSpec.describe Day19 do
  it 'finds all distinct molecules that can be created with one replacement' do
    test1 = Day19.new(molecule: 'HOH', replacements: test_replacements)
    test2 = Day19.new(molecule: 'HOHOHO', replacements: test_replacements)

    expect(test1.distinct_molecules.size).to eq 4
    expect(test2.distinct_molecules.size).to eq 7
  end

  it 'finds the minimal set of replacements that create a molecule from "e"' do
    test1 = Day19.new(molecule: 'HOH', replacements: test_replacements)
    test2 = Day19.new(molecule: 'HOHOHO', replacements: test_replacements)

    expect(test1.minimal_steps_from('e').size).to eq 3
    expect(test2.minimal_steps_from('e').size).to eq 6
  end

  def test_replacements
    [
      'e => H',
      'e => O',
      'H => HO',
      'H => OH',
      'O => HH'
    ].join("\n")
  end
end
