require_relative 'day23'

RSpec.describe Day23 do
  it 'runs the example program' do
    computer = Day23.new(<<~EOS)
      inc a
      jio a, +2
      tpl a
      inc a
    EOS

    computer.run!

    expect(computer.registers[:a]).to eq 2
  end

  it 'runs a more complex program' do
    computer = Day23.new(test_program)

    computer.run!

    expect(computer.registers[:b]).to eq 170
  end

  it 'can preload registers with non-zero values' do
    computer = Day23.new(test_program, {a: 1, b: 0})

    computer.run!

    expect(computer.registers[:b]).to eq 247
  end

  def test_program
    <<~EOS
      jio a, +16
      inc a
      inc a
      tpl a
      tpl a
      tpl a
      inc a
      inc a
      tpl a
      inc a
      inc a
      tpl a
      tpl a
      tpl a
      inc a
      jmp +23
      tpl a
      inc a
      inc a
      tpl a
      inc a
      inc a
      tpl a
      tpl a
      inc a
      inc a
      tpl a
      inc a
      tpl a
      inc a
      tpl a
      inc a
      inc a
      tpl a
      inc a
      tpl a
      tpl a
      inc a
      jio a, +8
      inc b
      jie a, +4
      tpl a
      inc a
      jmp +2
      hlf a
      jmp -7
    EOS
  end
end
