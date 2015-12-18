# --- Day 14: Reindeer Olympics ---

class Day14
  def initialize(reindeer)
    @reindeer = reindeer.lines.map do |racer|
      parts = racer.match(/
        (?:\S+).can.fly.
        (?<speed>\S+).km\/s.for.
        (?<fly_time>\S+).seconds,.but.then.must.rest.for.
        (?<rest_time>\S+).seconds
      /x)

      parts.names.map(&:to_sym).zip(parts.captures.map(&:to_i)).to_h
    end
  end

  def distances_at_time(seconds)
    @reindeer.map do |racer|
      interval = racer[:fly_time] + racer[:rest_time]

      0.upto(seconds).reduce(0) do |distance, second|
        if (second % interval) < racer[:fly_time]
          distance + racer[:speed]
        else
          distance
        end
      end
    end
  end
end
