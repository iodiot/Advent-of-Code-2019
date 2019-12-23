# --- Day 21: Springdroid Adventure ---

require_relative '../intcode.rb'

code = File.read("input.txt").split(',').map(&:to_i)

File.open("input.txt", "r").each do |line|
	p line
end