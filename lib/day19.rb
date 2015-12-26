# --- Day 19: Medicine for Rudolph ---

require 'strscan'

class Day19
  def initialize(molecule:, replacements:)
    @molecule = molecule
    @replacements = replacements.each_line.map do |line|
      line.chomp.split(' => ')
    end
  end

  def distinct_molecules
    [].tap do |molecules|
      scanner = StringScanner.new(@molecule)

      @replacements.each do |(source, target)|
        scanner.reset
        source_pattern = Regexp.new(source)

        loop do
          scanner.scan_until(source_pattern)

          if scanner.matched?
            result = @molecule.dup
            result[scanner.pre_match.size, source.size] = target
            molecules << result
          else
            break
          end
        end
      end
    end.uniq
  end
end
