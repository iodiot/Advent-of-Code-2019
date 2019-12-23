
# --- Day 18: Many-Worlds Interpretation ---


def closed_doors?(maze)
	maze.join.each_char.select {|ch| ch != '.' and ch != '#' }.length > 0
end

def door?(ch)
	ch >= 'A' and ch <= 'Z'
end

def key?(ch)
	ch >= 'a' and ch <= 'z'
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

amaze = []
x, y = -1, -1

File.open("input.txt", "r").each_with_index do |line, i|
	amaze << line.chomp
	n = line.index('@')

	unless n.nil?
		x, y = n, i
		amaze[y][x] = '.'
	end
end

total_keys = amaze.join.each_char.select {|ch| key?(ch)}.count

bot = {:pos => [x, y], :steps => 0, :maze => clone_arr(amaze), :keys => []}

queue = [bot]

min_steps = -1

nodes = build_nodes(amaze)

while not queue.empty? 
	bot = queue.shift
	
	pos, maze, keys, steps = bot[:pos], bot[:maze], bot[:keys], bot[:steps]
	x, y = pos

	what = maze[y][x]

	if key?(what)
		#p "#{what} #{steps}"

		unless keys.include? what
			keys << what 
			maze = clone_arr(amaze)
		end
	end

	if keys.count == total_keys
		min_steps = steps
		break
	end

	maze[y][x] = '#'

	[[x - 1, y], [x + 1, y], [x, y - 1], [x, y + 1]].each do |point|
		what = maze[point[1]][point[0]]

		next if what == '#'
		next if door?(what) and not keys.include?(what.downcase)

		queue << {:pos => point, :steps => steps + 1, :maze => maze, :keys => keys.clone}
	end
end

p min_steps