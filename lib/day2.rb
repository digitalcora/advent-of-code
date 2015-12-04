# --- Day 2: I Was Told There Would Be No Math ---

class Day2
  def initialize(presents)
    @presents = presents.each_line.map{ |sides| sides.split('x').map(&:to_i) }
  end

  def paper_needed
    @presents.reduce(0) do |total, sides|
      area = sides.combination(2).map{ |pair| pair.reduce(:*) }.reduce(:+) * 2
      total += area + sides.sort[0..1].reduce(:*)
    end
  end
end
