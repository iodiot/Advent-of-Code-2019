# --- Day 19: Tractor Beam --- 

require_relative '../intcode.rb'

code = File.read("input.txt").split(',').map(&:to_i)

affected = 0

for y in 0...50
	start_y = y
	start_x = -1

	for x in 0...50
		program = Intcode.new(code, [x, y])
		pulled = program.run[-1] == 1
		affected += 1 if pulled
	end
end

puts "part 1: #{affected}"

