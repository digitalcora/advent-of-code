class Day20
  def initialize(target_presents:, house_limit: nil, present_multiplier: 10)
    @target_presents = target_presents
    @house_limit = house_limit
    @present_multiplier = present_multiplier
  end

  def first_house_number
    highest_house_number = @target_presents / @present_multiplier
    house_presents = Array.new(highest_house_number + 1, 0)

    1.upto(highest_house_number).each do |elf_number|
      elf_last_house = if @house_limit
        [highest_house_number, elf_number * @house_limit].min
      else
        highest_house_number
      end

      elf_number.step(by: elf_number, to: elf_last_house).each do |house|
        house_presents[house] += elf_number * @present_multiplier
      end
    end

    house_presents.find_index{ |presents| presents >= @target_presents }
  end
end
