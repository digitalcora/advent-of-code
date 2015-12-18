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

  def corrected_sum(object = @document)
    case object
    when String, [], {} then 0
    when Numeric then object
    when Array then object.map{ |item| corrected_sum(item) }.reduce(:+)
    when Hash
      if object.values.include?('red')
        0
      else
        corrected_sum(object.values)
      end
    end
  end
end
