# --- Day 9: All in a Single Night ---

class Day9
  def initialize(edges)
    @nodes = Set.new
    @edges = Hash.new

    edges.lines.each do |edge|
      parts = edge.match(/(?<place1>\S+) to (?<place2>\S+) = (?<distance>\S+)/)
      nodes = [parts[:place1], parts[:place2]].to_set

      @nodes.merge(nodes)
      @edges[nodes] = parts[:distance].to_i
    end
  end

  def distances
    @nodes.to_a.permutation.map do |route|
      route.each_cons(2).reduce(0) do |distance, nodes|
        distance += @edges[nodes.to_set]
      end
    end
  end
end
