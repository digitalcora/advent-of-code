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

      @replacements.each do |(from_sequence, to_sequence)|
        scanner.reset
        source_pattern = Regexp.new(from_sequence)

        loop do
          scanner.scan_until(source_pattern)

          if scanner.matched?
            result = @molecule.dup
            result[scanner.pre_match.size, from_sequence.size] = to_sequence
            molecules << result
          else
            break
          end
        end
      end
    end.uniq
  end

  def minimal_steps_from(initial_molecule)
    steps = [@molecule]
    replacements = @replacements
      .map(&:reverse)
      .sort_by do |(from, to)|
        from.scan(/[A-Z][a-z]*/).size - to.scan(/[A-Z][a-z]*/).size
      end
      .reverse

    loop do
      from_sequence, to_sequence = replacements.find do |(from, _)|
        steps.last.include?(from)
      end

      steps << steps.last.sub(/(.*)#{from_sequence}/, "\\1#{to_sequence}")

      return steps[1..-1] if steps.last == initial_molecule
    end
  end
end
