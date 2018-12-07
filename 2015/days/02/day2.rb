class Day2
  def initialize(presents)
    @presents = presents.each_line.map{ |sides| sides.split('x').map(&:to_i) }
  end

  def paper_needed
    @presents.reduce(0) do |total, sides|
      area = sides.combination(2).map{ |pair| pair.reduce(:*) }.reduce(:+) * 2
      smallest_side_area = sides.sort[0..1].reduce(:*)

      total + area + smallest_side_area
    end
  end

  def ribbon_needed
    @presents.reduce(0) do |total, sides|
      smallest_perimeter = sides.sort[0..1].reduce(:+) * 2
      volume = sides.reduce(:*)

      total + smallest_perimeter + volume
    end
  end
end
