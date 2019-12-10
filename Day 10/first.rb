# --- Day 10: Monitoring Station ---


def gcd(a, b)
	b == 0 ? a : gcd(b, a % b)
end


def visible?(asteroids, x1, y1, x2, y2)
	dx, dy = x2 - x1, y2 - y1
	n = gcd(dx.abs, dy.abs)

	(1...n).each do |i| 
		return false if asteroids.include? [x1 + dx / n * i, y1 + dy / n * i]
	end

	true
end

map = [] 
asteroids = []

File.open("input.txt", "r").each_with_index do |line, y|
	map << line.chomp
	line.chomp.each_char.with_index {|ch, x| asteroids << [x, y] if ch == '#'}
end

o = [3, 4]

max = asteroids.map {|o|
	asteroids.map {|a| visible?(asteroids, o[0], o[1], a[0], a[1])}.count(true) - 1
}.max

puts "part 1: #{max}"