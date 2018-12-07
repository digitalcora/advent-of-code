class Day22
  def initialize(**stats)
    @battle = Battle.new(**stats)
    @best_win = nil
  end

  def best_mana
    best_win&.mana_spent
  end

  def best_spells
    best_win&.spells_cast
  end

  private

  def best_win
    @best_win ||= find_win(@battle)
  end

  def find_win(battle)
    branches = battle.branches.reject(&:lost?)

    if @best_win
      branches.reject!{ |branch| branch.mana_spent >= @best_win.mana_spent }
    end

    if branches.empty?
      nil
    elsif branches.any?(&:won?)
      @best_win = branches.select(&:won?).min_by(&:mana_spent)
    else
      branches.map{ |branch| find_win(branch) }.compact.min_by(&:mana_spent)
    end
  end

  private

  class Battle
    attr_reader :mana_spent, :spells_cast

    def initialize(
      boss_health:,
      boss_damage:,
      player_health:,
      player_mana:,
      hard_mode: false
    )
      @boss = Boss.new(boss_health, boss_damage, 0)
      @player = Player.new(player_health, player_mana, 0, 0, hard_mode)
      @mana_spent = 0
      @spells_cast = []
      @player.handicap!
      raise "already won?!" if won?
      raise "dead on arrival" if lost?
    end

    def branches
      @player.castable(@boss).map do |spell|
        battle = dup
        battle.cast!(spell)
        battle
      end
    end

    def cast!(spell)
      raise "battle is won!" if won?
      raise "battle is lost" if lost?

      turn_phases(spell).each do |phase|
        phase.call
        break if won? || lost?
      end
    end

    def lost?
      @player.health <= 0
    end

    def won?
      @boss.health <= 0
    end

    def dup
      super.tap do |duped|
        duped.instance_variable_set(:@boss, @boss.dup)
        duped.instance_variable_set(:@player, @player.dup)
      end
    end

    private

    def turn_phases(spell)
      [
        ->{
          @mana_spent += @player.cast!(spell, @boss)
          @spells_cast += [spell]
        },
        ->{ @player.effects!; @boss.effects! },
        ->{ @boss.attack!(@player) },
        ->{ @player.handicap! },
        ->{ @player.effects!; @boss.effects! }
      ]
    end
  end

  class Boss < Struct.new(:health, :damage, :poison)
    def attack!(target)
      target.health -= [1, damage - target.armor].max
    end

    def effects!
      if poison > 0
        self.poison -= 1
        self.health -= 3
      end
    end
  end

  class Player < Struct.new(:health, :mana, :shield, :recharge, :hard_mode)
    SPELLS = {
      magic_missile: 53,
      drain: 73,
      shield: 113,
      poison: 173,
      recharge: 229
    }

    def armor
      shield > 0 ? 7 : 0
    end

    def cast!(spell, target = nil)
      raise "cannot cast #{spell}" unless castable(target).include?(spell)

      self.mana -= SPELLS[spell]

      case spell
      when :magic_missile then target.health -= 4
      when :drain then target.health -= 2; self.health += 2
      when :shield then self.shield = 6
      when :poison then target.poison = 6
      when :recharge then self.recharge = 5
      end

      SPELLS[spell]
    end

    def castable(target)
      SPELLS.select{ |name, cost| cost <= mana }.keys.tap do |spells|
        spells.delete(:poison) if target.nil? || target.poison > 0
        spells.delete(:recharge) if recharge > 0
        spells.delete(:shield) if shield > 0
      end
    end

    def effects!
      if recharge > 0
        self.mana += 101
        self.recharge -= 1
      end

      if shield > 0
        self.shield -= 1
      end
    end

    def handicap!
      if hard_mode
        self.health -= 1
      end
    end
  end
end
