class Day5
  def initialize(strings)
    @strings = strings.lines
  end

  def nice_count
    @strings.count do |string|
      string =~ /([aeiou].*){3,}/\
      && string =~ /(.)\1/\
      && string !~ /ab|cd|pq|xy/
    end
  end

  def improved_nice_count
    @strings.count do |string|
      string =~ /(..).*\1/ && string =~ /(.).\1/
    end
  end
end
