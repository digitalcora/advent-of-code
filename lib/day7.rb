class Day7
  def initialize(raw_instructions)
    @gates = assemble_gates(parse_instructions(raw_instructions))
  end

  def outputs
    @gates.map{ |name, gate| [name, gate.output] }.to_h
  end

  private

  def parse_instructions(raw_instructions)
    raw_instructions.lines.map do |instruction_string|
      instruction_string.match(/
        ^(
          (?<input1>\S+) |
          ((?<operation>NOT)\ (?<input1>\S+)) |
          ((?<input1>\S+)\ (?<operation>AND|OR|LSHIFT|RSHIFT)\ (?<input2>\S+))
        )\ ->\ (?<name>\S+)$
      /x)
    end
  end

  def assemble_gates(instructions)
    instructions.each.with_object({}) do |instruction, gates|
      inputs = [instruction[:input1], instruction[:input2]].map do |input|
        Integer(input) rescue input.to_sym rescue nil
      end

      gates[instruction[:name].to_sym] = Gate.new(
        gates: gates, inputs: inputs, operation: instruction[:operation]
      )
    end
  end
end

class Gate
  def initialize(gates:, inputs:, operation:)
    @gates, @inputs, @operation = gates, inputs, operation
  end

  def output
    output = case @operation
      when nil then values.first
      when 'NOT' then ~values.first
      when 'AND' then values.first & values.last
      when 'OR' then values.first | values.last
      when 'LSHIFT' then values.first << values.last
      when 'RSHIFT' then values.first >> values.last
    end

    case
      when output < 0 then 65536 + output
      when output > 65535 then output - 65536
      else output
    end
  end

  private

  def values
    @values ||= @inputs.map do |input|
      if @gates.has_key?(input)
        @gates[input].output
      else
        input
      end
    end
  end
end
