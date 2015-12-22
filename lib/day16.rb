# --- Day 16: Aunt Sue ---

class Day16
  def initialize(gift:, aunts:)
    @gift = gift
    @aunts = aunts.each_line.map do |aunt|
      name = aunt[/^(.+?):/, 1]
      things = aunt
        .sub(name, '')
        .scan(/(\S+): (\d+)/)
        .map{ |(thing, quantity)| [thing.to_sym, quantity.to_i] }
        .to_h

      [name, things]
    end.to_h
  end

  def initial_sender
    @aunts.find do |name, things|
      things.all?{ |thing, quantity| @gift[thing] == quantity }
    end.first
  end

  UNDERESTIMATED_THINGS = %i(cats trees)
  OVERESTIMATED_THINGS = %i(goldfish pomeranians)

  def corrected_sender
    @aunts.find do |name, things|
      things.all? do |thing, quantity|
        if UNDERESTIMATED_THINGS.include?(thing)
          quantity > @gift[thing]
        elsif OVERESTIMATED_THINGS.include?(thing)
          quantity < @gift[thing]
        else
          quantity == @gift[thing]
        end
      end
    end.first
  end
end
