require 'json'

class Day12
  def initialize(json)
    @document = JSON.parse(json)
  end

  def sum(object: @document, ignore_red: false)
    case object
    when String, [], {} then 0
    when Numeric then object
    when Array
      object.map{ |item| sum(object: item, ignore_red: ignore_red) }.reduce(:+)
    when Hash
      if ignore_red && object.values.include?('red')
        0
      else
        sum(object: object.values, ignore_red: ignore_red)
      end
    end
  end
end
