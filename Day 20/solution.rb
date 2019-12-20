# --- Day 20: Donut Maze ---

def find_extreme_points(map)
	top_left = -1
	btm_right = -1

	map.each_with_index do |row, y|
		row.each_char.each_with_index do |ch, x|
			top_left = [x, y] if top_left == -1 and ch == '#'
			btm_right = [x, y] if ch == '#' 
		end
	end

	[top_left, btm_right]
end

def build_maze_and_portals(map)
	top_left, btm_right = find_extreme_points(map)

	maze = {}
	portals = {}

	for y in top_left[1]..btm_right[1]
		for x in top_left[0]..btm_right[0]
			pos = [x, y]
			maze[pos] = map[y][x]

			# portal? 
			if map[y][x] == '.'
				points = []
				for i in x - 2..x + 2
					points << [i, y] if i != x
				end
				for i in y - 2..y + 2
					points << [x, i] if i != y
				end
				portal = ""
				points.each {|xx, yy| portal << map[yy][xx] if map[yy][xx].ord >= 'A'.ord and map[yy][xx].ord <= 'Z'.ord}
				portals[pos] = portal if portal.length == 2
			end
		end
	end

	[maze, portals]
end

def inner_portal?(maze, pos)
	w, h = maze.keys.map {|k| k[0]}.max + 4, maze.keys.map {|k| k[1]}.max + 4

	margin = 4
	x, y = pos

	x > margin and y > margin and x < w - margin and y < h - margin 
end

def enter_portal(portals, pos)
	raise "No portal at this position" unless portals.key? pos

	name = portals[pos]

	points = portals.keys.select {|k| portals[k] == name} 

	points.delete(pos)
	points.length > 0 ? points[0] : pos
end

def equal?(point1, point2)
	(point1[0] == point2[0]) and (point1[1] == point2[1])
end

def traverse_maze(maze, portals, recursive)
	max_levels = recursive ? 30 : 1

	entry_point = portals.keys.find {|k| portals[k] == 'AA'}
	exit_point = portals.keys.find {|k| portals[k] == 'ZZ'}

	# remove entry/exit from portal list
	portals = portals.select{|k, v| v != 'AA' and v != 'ZZ'}

	# one maze per level
	mazes = (0..max_levels).map { maze.clone }

	# turn entry/exit points into walls on levels > 0
	mazes[1..max_levels].each {|maze| maze[exit_point] = '#'; maze[entry_point] = '#'}

	queue = [[entry_point, 1, 0]]

	while not queue.empty?
		pos, steps, level = queue.shift
		x, y = pos

		maze = mazes[level]

		maze[pos] = '*'

		[[x - 1, y], [x + 1, y], [x, y - 1], [x, y + 1]].each do |point|
			next if maze[point] != '.'

			# exit?
			if equal?(point, exit_point) and level == 0
				return steps
			end

			# portal?
			if portals.key? point
				if not recursive
					other_point = enter_portal(portals, point)
					queue << [other_point, steps + 2, 0]
				else
					inner = inner_portal?(maze, point)

					next if (not inner) and (level == 0)
					next if level >= max_levels

					other_point = enter_portal(portals, point)
					queue << [other_point, steps + 2, level + (inner ? +1 : -1)]
				end
			else
				queue << [point, steps + 1, level]
			end
		end
	end
end

map = []

File.open("input.txt", "r").each do |line|
	map << line.chomp
end

maze, portals = build_maze_and_portals(map)

puts "part 1: #{traverse_maze(maze, portals, false)}"
puts "part 2: #{traverse_maze(maze, portals, true)}"