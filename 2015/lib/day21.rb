# --- Day 21: RPG Simulator 20XX ---

class Day21
  def initialize(boss_health:, boss_damage:, boss_armor:)
    @boss = Fighter.new(boss_health, boss_damage, boss_armor)
  end

  def cheapest_win
    winning_loadouts.min_by(&:cost).cost
  end

  def costliest_loss
    losing_loadouts.max_by(&:cost).cost
  end

  def player_wins?(health:, damage:, armor:)
    turn = 0
    boss = @boss.dup
    player = Fighter.new(health, damage, armor)
    fighters = [player, boss]

    until fighters.any?(&:defeated?)
      attacker = fighters[turn % 2]
      defender = fighters[(turn + 1) % 2]

      damage = [1, attacker.damage - defender.armor].max
      defender.health -= damage

      turn += 1
    end

    boss.defeated?
  end

  private

  class Fighter < Struct.new(:health, :damage, :armor)
    def defeated?
      health <= 0
    end
  end

  class Item < Struct.new(:name, :cost, :damage, :armor)
  end

  class Loadout < Struct.new(:items)
    def cost
      items.map(&:cost).reduce(:+)
    end

    def damage
      items.map(&:damage).reduce(:+)
    end

    def armor
      items.map(&:armor).reduce(:+)
    end
  end

  def winning_loadouts
    LOADOUTS.select do |loadout|
      player_wins?(
        health: PLAYER_HEALTH,
        damage: loadout.damage,
        armor: loadout.armor
      )
    end
  end

  def losing_loadouts
    LOADOUTS - winning_loadouts
  end

  PLAYER_HEALTH = 100

  WEAPONS = [
    Item.new('Dagger', 8, 4, 0),
    Item.new('Shortsword', 10, 5, 0),
    Item.new('Warhammer', 25, 6, 0),
    Item.new('Longsword', 40, 7, 0),
    Item.new('Greataxe', 74, 8, 0)
  ]

  ARMOR = [
    Item.new('Leather Armor', 13, 0, 1),
    Item.new('Chainmail Armor', 31, 0, 2),
    Item.new('Splintmail Armor', 53, 0, 3),
    Item.new('Bandedmail Armor', 75, 0, 4),
    Item.new('Platemail Armor', 102, 0, 5)
  ]

  RINGS = [
    Item.new('Ring of Damage +1', 25, 1, 0),
    Item.new('Ring of Damage +2', 50, 2, 0),
    Item.new('Ring of Damage +3', 100, 3, 0),
    Item.new('Ring of Defense +1', 20, 0, 1),
    Item.new('Ring of Defense +2', 40, 0, 2),
    Item.new('Ring of Defense +3', 80, 0, 3)
  ]

  EQUIPMENT = [
    { items: WEAPONS, min: 1, max: 1 },
    { items: ARMOR, min: 0, max: 1 },
    { items: RINGS, min: 0, max: 2 }
  ]

  LOADOUTS = begin
    slot_choices = EQUIPMENT.map do |slot|
      (slot[:min]..slot[:max]).flat_map do |item_count|
        slot[:items].combination(item_count).to_a
      end
    end

    slot_choices[0].product(*slot_choices[1..-1]).map do |choices|
      Loadout.new(choices.flatten)
    end
  end
end
