# --- Day 12: JSAbacusFramework.io ---

require 'json'

class Day12
  def initialize(json)
    @document = JSON.parse(json)
  end

  def sum(object = @document)
    case object
    when String, [], {} then 0
    when Numeric then object
    when Array, Hash then object.to_a.map{ |item| sum(item) }.reduce(:+)
    end
  end
end
