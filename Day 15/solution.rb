# --- Day 15: Oxygen System ---

require 'ruby2d'
require_relative '../intcode.rb'

movements = {1 => [0, -1] , 4 => [1, 0], 3 => [-1, 0], 2 => [0, 1]}

code = File.read("input.txt").split(',').map(&:to_i)

droid = code

queue = Queue.new

(1..4).each {|move| queue << [Intcode.new(code, [move]), [0, 0], 0]}

map = {[0, 0] => '.'}

part_1 = -1

tank_pos = nil

while queue.length > 0
	droid, last_pos, moves = queue.pop

	last_move = droid.input[-1]

	pos = [last_pos[0] + movements[last_move][0], last_pos[1] + movements[last_move][1]]

	next if map.key? pos

	case droid.run[-1]
	when 0	# hit a wall
		map[pos] = '#'
	when 1	# moved one step in the requested direction
		map[pos] = '.'

		(1..4).each {|move| queue << [droid.make_copy(move), pos, moves + 1]}
	when 2	# oxygen
		part_1 = moves + 1
		tank_pos = pos
	end
end

puts "part 1: #{part_1}"

def print_map(map)
	min_x = map.keys.map {|k| k[0]}.min
	max_x = map.keys.map {|k| k[0]}.max
	min_y = map.keys.map {|k| k[1]}.min
	max_y = map.keys.map {|k| k[1]}.max

	for y in min_y..max_y
		for x in min_x..max_x
			if map.key? [x, y]
				print map[[x, y]]
			else 
				print ' '
			end
		end
		print "\n"
	end
end

queue = Queue.new
temp_queue = Queue.new

queue << tank_pos

minutes = 0

while true
	if queue.empty?
		queue = temp_queue
		temp_queue = Queue.new
		break if queue.empty?
		minutes += 1
	end

	pos = queue.pop

	map[pos] = 'O'

	(1..4).each do |move|
		new_pos = [pos[0] + movements[move][0], pos[1] + movements[move][1]]
		temp_queue << new_pos if map[new_pos] == '.'
	end
end

puts "part 2: #{minutes}"
