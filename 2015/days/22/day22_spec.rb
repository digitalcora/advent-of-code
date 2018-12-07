require_relative 'day22'

RSpec.describe Day22 do
  it 'wins a battle with the lowest possible mana cost' do
    rpg = Day22.new(
      player_health: 10,
      player_mana: 250,
      boss_health: 13,
      boss_damage: 8
    )

    expect(rpg.best_mana).to be 226
    expect(rpg.best_spells).to eq %i(poison magic_missile)
  end

  it 'wins a battle against a tougher boss' do
    rpg = Day22.new(
      player_health: 10,
      player_mana: 250,
      boss_health: 14,
      boss_damage: 8
    )

    expect(rpg.best_mana).to be 641
    expect(rpg.best_spells).to eq %i(recharge shield drain poison magic_missile)
  end

  it 'cannot win a battle against an impossible boss' do
    rpg = Day22.new(
      player_health: 10,
      player_mana: 250,
      boss_health: 16,
      boss_damage: 8
    )

    expect(rpg.best_mana).to be nil
    expect(rpg.best_spells).to be nil
  end

  it 'wins a battle on hard mode' do
    rpg = Day22.new(
      player_health: 10,
      player_mana: 250,
      boss_health: 18,
      boss_damage: 2,
      hard_mode: true
    )

    expect(rpg.best_mana).to be 528
    expect(rpg.best_spells).to eq %i(recharge poison drain magic_missile)
  end
end
