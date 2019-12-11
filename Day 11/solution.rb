# --- Day 11: Space Police ---

require_relative "../intcode.rb"

PART_1 = 1
PART_2 = 2

BLACK = 0
WHITE = 1

LEFT = 0
RIGHT = 1

NORTH = 0
EAST = 1
SOUTH = 2
WEST = 3

def turn_robot(dir, turn)
	return (dir + (turn == RIGHT ? 1 : -1)) % 4
end

def move_robot(dir, pos)
	x, y = pos

	case dir 
	when NORTH
		y -= 1
	when EAST
		x += 1
	when SOUTH
		y += 1
	when WEST
		x -= 1
	end

	[x, y]
end

mode = PART_1

code = File.read("input.txt").split(',').map(&:to_i)

pos = [0, 0]
dir = NORTH
panels = {}
n = 0

panels[pos] = WHITE if mode == PART_2

brain = Intcode.new(code, [])

while not brain.halted?
	color = panels.key?(pos) ? panels[pos] : BLACK

	brain.send_to_input color

	brain.run

	color, turn = brain.output[-2], brain.output[-1]

	n += 1 unless panels.key? pos

	panels[pos] = color

	dir = turn_robot(dir, turn)
	pos = move_robot(dir, pos)
end

puts "part 1: #{n}" if mode == PART_1

if mode == PART_2
	w = panels.keys.map {|x| x[0]}.max
	h = panels.keys.map {|x| x[1]}.max

	label = (h + 1).times.map { ' ' * (w + 1)}

	panels.keys.each {|pos| label[pos[1]][pos[0]] = '#' if panels[pos] == WHITE} 

	puts "part 2: "
	puts label
end
