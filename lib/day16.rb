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

  def sender
    @aunts.find do |name, things|
      things.all?{ |thing, quantity| @gift[thing] == quantity }
    end.first
  end
end
