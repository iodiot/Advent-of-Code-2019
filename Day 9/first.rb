# --- Day 9: Sensor Boost ---

require_relative "../intcode.rb"

code = File.read("input.txt").split(',').map(&:to_i)

intcode = Intcode.new(code, [1])

p intcode.run

p intcode.halted?