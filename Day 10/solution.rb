# --- Day 10: Monitoring Station ---

require 'ruby2d'

def gcd(a, b)
	b == 0 ? a : gcd(b, a % b)
end

def visible?(asteroids, x1, y1, x2, y2)
	dx, dy = x2 - x1, y2 - y1
	n = gcd(dx.abs, dy.abs)

	(1...n).each do |i| 
		pos = [x1 + dx / n * i, y1 + dy / n * i]
		return false if asteroids.include? [x1 + dx / n * i, y1 + dy / n * i]
	end

 	true
end

def angle(dx, dy)
	g = gcd(dx, dy)
	return Float::INFINITY if g == 0

	step = 0
	step = 100 if dx >= 0 and dy >= 0
	step = 1000 if dx <= 0 and dy >= 0
	step = 10000 if dx < 0 and dy <= 0

	return Math.atan2(dy / g, dx / g) + step
end

def sqr_distance(dx, dy)
	dx * dx + dy * dy
end

def reachable(asteroids, from)
	dp = {}

	asteroids.each do |point|
		next if point == from

		dx = point[0] - from[0]
		dy = point[1] - from[1]

		alfa = angle(dx, dy)

		if dp.include? alfa
			dp[alfa] = point if sqr_distance(dx, dy) < sqr_distance(dp[alfa][0] - from[0], dp[alfa][1] - from[1])
		else
			dp[alfa] = point
		end
	end

	dp
end

def part_2(asteroids, from)
	counter = 1

	asteroids.delete from

	while true
		reach = reachable(asteroids, from)

		sorted_keys = reach.keys.sort_by {|x| x}

		start_key = sorted_keys.find {|x| x >= Math::PI / 2}

		i = sorted_keys.index(start_key)
		n = 0

		to_delete = []

		while n < sorted_keys.length
			key = sorted_keys[i]
			to_delete << reach[key]

			return reach[key][0] * 100 + reach[key][1] if counter == 200

			i = (i + 1) % sorted_keys.length
			n += 1
			counter += 1
		end

		asteroids = asteroids - to_delete
	end
end

def part_1(asteroids)
	asteroids.map {|from|
		[reachable(asteroids, from).length, from]
	}.max
end

map = [] 
asteroids = []

File.open("input.txt", "r").each_with_index do |line, y|
	map << line.chomp
	line.chomp.each_char.with_index {|ch, x| asteroids << [x, y] if ch == '#'}
end

max, from = part_1(asteroids)

puts "part 1: #{max}"
puts "part 2: #{part_2(asteroids, from)}"
