require 'day21'

RSpec.describe Day21 do
  it 'determines when a given player wins against a given boss' do
    rpg = Day21.new(boss_health: 12, boss_damage: 7, boss_armor: 2)

    victory = rpg.player_wins?(health: 8, damage: 5, armor: 5)

    expect(victory).to be true
  end

  it 'determines when a given player loses against a given boss' do
    rpg = Day21.new(boss_health: 12, boss_damage: 8, boss_armor: 2)

    victory = rpg.player_wins?(health: 8, damage: 5, armor: 5)

    expect(victory).to be false
  end

  it 'determines the minimum the player could spend and win' do
    rpg = Day21.new(boss_health: 109, boss_damage: 8, boss_armor: 2)

    expect(rpg.cheapest_win).to eq 111
  end

  it 'determines the maximum the player could spend and lose' do
    rpg = Day21.new(boss_health: 109, boss_damage: 8, boss_armor: 2)

    expect(rpg.costliest_loss).to eq 188
  end
end
