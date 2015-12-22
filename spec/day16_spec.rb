require 'day16'

RSpec.describe Day16 do
  it 'determines which Aunt Sue sent the gift using the initial rules' do
    sender = Day16.new(gift: test_gift, aunts: test_aunts).initial_sender
    expect(sender).to eq 'Sue 4'
  end

  it 'determines which Aunt Sue sent the gift using the corrected rules' do
    sender = Day16.new(gift: test_gift, aunts: test_aunts).corrected_sender
    expect(sender).to eq 'Sue 2'
  end

  def test_gift
    {
      children: 3,
      cats: 7,
      samoyeds: 2,
      pomeranians: 3,
      akitas: 0,
      vizslas: 0,
      goldfish: 5,
      trees: 3,
      cars: 2,
      perfumes: 1
    }
  end

  def test_aunts
    [
      'Sue 1: cats: 7, samoyeds: 1, cars: 3',
      'Sue 2: akitas: 0, trees: 5, perfumes: 1',
      'Sue 3: children: 2, vizslas: 0, trees: 3',
      'Sue 4: pomeranians: 3, goldfish: 5',
      'Sue 5: samoyeds: 2, akitas: 1, cars: 2'
    ].join("\n")
  end
end
