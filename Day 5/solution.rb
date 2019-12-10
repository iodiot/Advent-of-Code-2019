# --- Day 5: Sunny with a Chance of Asteroids ---

require_relative "../intcode.rb"

code = File.read("input.txt").split(',').map(&:to_i)

puts "part 1: #{Intcode.new(code, [1]).run.last}"
puts "part 1: #{Intcode.new(code, [5]).run.last}"

