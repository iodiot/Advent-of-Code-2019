# --- Day 9: Sensor Boost ---

require_relative "../intcode.rb"

code = File.read("input.txt").split(',').map(&:to_i)

puts "part 1: #{Intcode.new(code, [1]).run}"
puts "part 2: #{Intcode.new(code, [2]).run}"

