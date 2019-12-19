# --- Day 17: Set and Forget ---

require 'ruby2d'
require_relative '../intcode.rb'

def draw_scaffolds(arr)
	puts arr.map {|x| x.chr}.join.split("\n")
end

def scaffold?(map, x, y)
	return false if x < 0 or x >= map[0].length or y < 0 or y >= map.length
	map[y][x] == '#'
end

def compute_alignment(map)
	sum = 0
	
	for y in 0...map.length
		for x in 0...map[0].length
			sum += x * y if scaffold?(map, x, y) and scaffold?(map, x - 1, y) and scaffold?(map, x + 1, y) and scaffold?(map, x, y - 1) and scaffold?(map, x, y + 1)
		end
	end

	sum
end

def to_bytes(str)
	str.each_char.map {|x| x.ord}
end

def find_path(map)
	w, h = map[0].length, map.length

	x, y = map.join.index('^') % w, map.join.index('^') / w

	steps = 0
	path = "L"
	x -= 1

	dirs = [[0, -1], [1, 0], [0, 1], [-1, 0]]
	dir = 3  

	prev_x, prev_y = -1, -1

	working = true

	while working
		if scaffold?(map, x, y)
			steps += 1
			prev_x, prev_y = x, y
		else
			path += ",#{steps}"
			x, y = prev_x, prev_y

			working = false

			[dir + 1, dir + 3].each_with_index do |new_dir, i|
				new_dir = new_dir % dirs.length

				if scaffold?(map, x + dirs[new_dir][0], y + dirs[new_dir][1])
					dir = new_dir 
					path += (i == 0) ? ',R' : ',L' 
					working = true
				end
			end

			steps = 0
		end

		x += dirs[dir][0]
		y += dirs[dir][1]
	end

	path
end

def compress(path)
	names = ['A', 'B', 'C']
	funcs = []

	while names.length > 0
		name = names.shift
		str = ''

		arr = path.split(',')

		while arr.length > 0
			x = arr.shift

			next if x == 'A' or x == 'B' or x == 'C'

			new_str = str + x + ','

			n = path.index(new_str)

			if n.nil? or path.index(new_str, n + 1).nil?
				path.gsub!(str, name + ',')
				path.gsub!(str[0..-2], name)
				funcs << str[0..-2]
				break
			end

			str = new_str
		end
	end

	[path, funcs].flatten
end

code = File.read("input.txt").split(',').map(&:to_i)

ascii = Intcode.new(code, [])

output = ascii.run

map = output.map {|x| x.chr}.join.split("\n")

puts "part 1: #{compute_alignment(map)}"

# ---------------------------------------------------

path = find_path(map)

inputs = compress(path)

input = to_bytes(inputs.join("\n") + "\nn\n")

code[0] = 2
ascii = Intcode.new(code, input)

output = ascii.run
output, dust = output[0...-1], output[-1]

puts "part 2: #{dust}"

