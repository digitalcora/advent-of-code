require 'ostruct'

class Day14
  RACER_FORMAT = /
    (?<name>\S+).can.fly.
    (?<speed>\S+).km\/s.for.
    (?<fly_time>\S+).seconds,.but.then.must.rest.for.
    (?<rest_time>\S+).seconds
  /x

  RACER_STATS = %i(speed fly_time rest_time)

  def initialize(reindeer)
    @reindeer = reindeer.each_line.map do |racer|
      attributes = racer.match(RACER_FORMAT)
      stats = RACER_STATS.map{ |stat| [stat, attributes[stat].to_i] }.to_h

      OpenStruct.new(stats.merge(name: attributes[:name]))
    end
  end

  def racers_at_time(seconds)
    racers = @reindeer.dup.each do |racer|
      racer.distance = racer.score = 0
      racer.interval = racer.fly_time + racer.rest_time
    end

    (0...seconds).each do |second|
      racers.each do |racer|
        if (second % racer.interval) < racer.fly_time
          racer.distance += racer.speed
        end
      end

      lead_distance = racers.map(&:distance).max
      racers.each do |racer|
        racer.score += 1 if racer.distance == lead_distance
      end
    end

    racers
  end
end
