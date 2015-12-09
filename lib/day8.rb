# --- Day 8: Matchsticks ---

require 'yaml'

class Day8
  def initialize(strings)
    @strings = strings.split("\n")
  end

  def decode_overhead
    parsed_strings = @strings.map{ |string| YAML.load(string) }
    @strings.join.length - parsed_strings.join.length
  end

  def encode_overhead
    @strings.map(&:inspect).join.length - @strings.join.length
  end
end
