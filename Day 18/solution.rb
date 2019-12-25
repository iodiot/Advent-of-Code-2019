# --- Day 18: Many-Worlds Interpretation ---

class Robot 
	@@markers = ['*', '!', '%', '$']

	def self.markers
		@@markers
	end

	def initialize(amaze, start_marker)
		@amaze = clone_arr amaze
		@start_marker = start_marker

		@nodes = build_nodes(@amaze)
		@all_keys = @nodes.keys.select {|from, to| from == start_marker}.map {|pair| pair[1]}
	end

	def door?(ch)
		ch >= 'A' and ch <= 'Z'
	end

	def key?(ch)
		(ch >= 'a' and ch <= 'z') or @@markers.include?(ch) or (ch == '@')
	end

	def clone_arr(arr)
		arr.map {|x| x.dup}
	end

	def build_nodes(amaze)
		keys = {}
		nodes = {}

		w, h = amaze[0].length, amaze.length

		amaze.join.each_char.with_index do |ch, i|
			keys[ch] = [i % w, i / w] if key?(ch)
		end

		keys.keys.sort.each do |from|
			keys.keys.sort.each do |to|
				next if from == to

				queue = [[keys[from], 0, []]]
				maze = clone_arr(amaze)

				while not queue.empty?
					pos, steps, doors = queue.shift
					x, y = pos

					doors << maze[y][x] if door?(maze[y][x])

					if x == keys[to][0] and y == keys[to][1]
						nodes[[from, to]] = {:dist => steps, :doors => doors}
						break 
					end

					maze[y][x] = '#'

					[[x - 1, y], [x + 1, y], [x, y - 1], [x, y + 1]].each do |point|
						what = maze[point[1]][point[0]]
						queue << [point, steps + 1, doors.clone] if what != '#'
					end
				end
			end
		end

		nodes
	end

	def dfs(nodes, keys, steps, key)
		hash_key = "#{key}-#{(@all_keys - keys).join}"

		return if steps >= @dp[hash_key]

		@dp[hash_key] = steps

		if keys.count == @all_keys.count
			#p "#{keys.join(' ')} -> #{steps}"
			@distances << steps
			return
		end

		(@all_keys - keys).sort_by {|x| nodes[[key, x].sort][:dist]}.each do |other_key|
			z = [key, other_key].sort

			# closed doors on the way?
			doors = nodes[z][:doors].map {|x| x.downcase} & @all_keys
			next if (doors - keys).length > 0

			dfs(nodes, keys.clone << other_key, steps + nodes[z][:dist], other_key)
		end
	end

	def traverse
		@dp = Hash.new {|h, k| h[k] = 10005000 }

		@distances = []

		dfs(@nodes, [], 0, @start_marker)

		@distances.min
	end
end

amaze = []

x, y = -1, -1

File.open("input.txt", "r").each_with_index do |line, i|
	amaze << line.chomp
	n = line.index('@')
	x, y = n, i unless n.nil?
end

def part_1(amaze)
	robot = Robot.new(amaze, '@')

	robot.traverse
end

def part_2(amaze, x, y)
	str = "@#@###@#@"
	n = 0
	markers_clone = Robot.markers.clone
	for j in y - 1..y + 1
		for i in x -1..x + 1
			if str[n] == '#'
				amaze[j][i] ='#'
			else
				amaze[j][i] = markers_clone.shift
			end

			n += 1
		end
	end

	markers_clone = Robot.markers.clone

	steps = 0

	while markers_clone.length > 0 
		robot = Robot.new(amaze, markers_clone.shift)
		steps += robot.traverse
	end

	steps
end

p "part 1: #{part_1(amaze)}"
p "part 2: #{part_2(amaze, x, y)}"
