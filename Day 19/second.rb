# --- Day 19: Tractor Beam --- 

require_relative '../intcode.rb'

def square_fits?(code, x, y)
	points = [[x, y], [x + 99, y], [x, y + 99], [x + 99, y + 99]]

	while points.length > 0
		program = Intcode.new(code, points.shift)
		return false if program.run[-1] == 0
 	end

 	true
end

def compute_beam_interval(code, y)
	started = false
	start_x = -1
	x = 0
	while true
		program = Intcode.new(code, [x, y])
		r = program.run[-1]
		start_x = x if not started and r == 1
		started = true if r == 1
		return [start_x, x] if r == 0 and started
		x += 1
	end
end

code = File.read("input.txt").split(',').map(&:to_i)

y = 900
result = -1
working = true

while working
	interval = compute_beam_interval(code, y)

	for x in interval[0]..interval[1]
		if square_fits?(code, x, y)
			result = x * 10000 + y
			working = false
			break
		end
	end

	y += 1
end

puts "part 2: #{result}"
