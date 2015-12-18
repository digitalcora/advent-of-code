# --- Day 14: Reindeer Olympics ---

require 'ostruct'

class Day14
  def initialize(reindeer)
    @reindeer = reindeer.lines.map do |racer|
      name = racer.match(/(\S+) can fly/)[1]
      stat_parts = racer.match(/
        (?:\S+).can.fly.
        (?<speed>\S+).km\/s.for.
        (?<fly_time>\S+).seconds,.but.then.must.rest.for.
        (?<rest_time>\S+).seconds
      /x)

      stats = stat_parts.names.zip(stat_parts.captures.map(&:to_i)).to_h
      OpenStruct.new(stats.merge(name: name))
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
