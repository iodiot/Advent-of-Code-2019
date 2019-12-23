# --- Day 18: Many-Worlds Interpretation ---

def door?(ch)
	ch >= 'A' and ch <= 'Z'
end

def key?(ch)
	(ch >= 'a' and ch <= 'z') or (ch == '*')
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

File.open("input.txt", "r").each_with_index do |line, i|
	amaze << line.chomp
	n = line.index('@')

	unless n.nil?
		x, y = n, i
		amaze[y][x] = '*'
	end
end

nodes = build_nodes(amaze)

@dp = {}

all_keys = amaze.join.each_char.select {|ch| key?(ch)}.sort
all_keys.each {|k| @dp[k] = 10005000}
all_keys.delete('*')

def dfs(nodes, all_keys, keys, steps, key)
	return if steps > @dp[key]

	@dp[key] = steps

	if keys.count == all_keys.count
		p "#{keys.join(' ')} -> #{steps}"
		return
	end

	all_keys.select {|x| x != key}.sort {|a, b| nodes[[key, a].sort][:dist] <=> nodes[[key, b].sort][:dist] }.each do |other_key|
		next if keys.include?(other_key)
		z = [key, other_key].sort
		next if (nodes[z][:doors].map {|x| x.downcase} - keys).length > 0

		new_keys = keys.clone
		new_keys << other_key

		dfs(nodes, all_keys, new_keys, steps + nodes[z][:dist], other_key)
	end
end

dfs(nodes, all_keys, [], 0, '*')
