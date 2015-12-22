# --- Day 13: Knights of the Dinner Table ---

class Day13
  def initialize(edges, add_neutral: false)
    @nodes = Set.new
    @edges = Hash.new

    edges.each_line do |edge|
      parts = edge.match(/
        (?<person1>\S+).would.
        (?<sign>gain|lose).
        (?<number>\S+).happiness.units.by.sitting.next.to.
        (?<person2>\S+)\.
      /x)
      nodes = [parts[:person1], parts[:person2]].to_set
      happiness = parts[:number].to_i * (parts[:sign] == 'lose' ? -1 : 1)

      @nodes.merge(nodes)
      @edges[nodes] ||= 0
      @edges[nodes] += happiness
    end

    if add_neutral
      @nodes.each{ |node| @edges[[node, :neutral].to_set] = 0 }
      @nodes.merge([:neutral])
    end
  end

  def happiness_totals
    @nodes.to_a.permutation.map do |route|
      route.each_cons(2).reduce(0) do |distance, nodes|
        distance += @edges[nodes.to_set]
      end + @edges[[route.first, route.last].to_set]
    end
  end
end
