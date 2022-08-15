defmodule Advent.BunnyVMTest do
  use ExUnit.Case, async: true
  alias Advent.BunnyVM, as: VM

  describe "new/1" do
    test "initializes all registers to 0" do
      vm = VM.new("cpy 1 a")
      assert VM.get(vm, :a) == 0
      assert VM.get(vm, :b) == 0
      assert VM.get(vm, :c) == 0
      assert VM.get(vm, :d) == 0
    end
  end

  describe "run/0" do
    test "runs the program until it halts" do
      # Simple program that doubles A and stores the result in B, using C as scratch.
      vm =
        VM.new("""
          cpy a c
          inc b
          inc b
          dec c
          jnz c -3
        """)

      assert vm |> VM.set(:a, 21) |> VM.run() |> VM.get(:b) == 42
    end
  end

  describe "CPY" do
    test "loads a constant into a register" do
      assert VM.new("cpy 123 a") |> VM.run() |> VM.get(:a) == 123
    end

    test "copies the value of a register into another register" do
      assert VM.new("cpy a c") |> VM.set(:a, 10) |> VM.run() |> VM.get(:c) == 10
    end
  end

  describe "INC" do
    test "increments the value of a register" do
      assert VM.new("inc b\ninc b\ninc b") |> VM.run() |> VM.get(:b) == 3
    end
  end

  describe "DEC" do
    test "decrements the value of a register" do
      assert VM.new("dec d\ndec d\ndec d") |> VM.run() |> VM.get(:d) == -3
    end
  end

  describe "JNZ" do
    test "is ignored if the source is 0" do
      assert VM.new("jnz 0 2\ninc a") |> VM.run() |> VM.get(:a) == 1
      assert VM.new("jnz a 2\ninc a") |> VM.run() |> VM.get(:a) == 1
    end

    test "jumps to a new relative instruction if the source is not 0" do
      assert VM.new("jnz 1 2\ninc a") |> VM.run() |> VM.get(:a) == 0
      assert VM.new("dec a\njnz a 2\ninc a") |> VM.run() |> VM.get(:a) == -1
    end
  end
end
