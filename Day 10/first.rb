# --- Day 10: Monitoring Station ---

require 'ruby2d'

def gcd(a, b)
	b == 0 ? a : gcd(b, a % b)
end

@counter = 1

def vaporize(asteroids, x1, y1, x2, y2)
	dx, dy = x2 - x1, y2 - y1
	n = gcd(dx.abs, dy.abs)

	behind = []

	first = true

	(1..n).each do |i| 
		pos = [x1 + dx / n * i, y1 + dy / n * i]

		if first and asteroids.include?(pos)
			puts "The #{@counter}st asteroid to be vaporized is at #{pos[0] + 11},#{pos[1] + 13}."
			asteroids.delete(pos)
			first = false
		else
			behind << pos
		end
	end

	behind
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

def group_asteroids(asteroids)
	groups = Hash.new {|h, k| h[k] = [] }

	asteroids.each do |aster|
		dx, dy = aster[0], aster[1]
		n = gcd(dx.abs, dy.abs)

		k = nil

		(1...n).each do |i| 
			pos = [dx / n * i, dy / n * i]
			k = pos if i == 1
			groups[k] << pos if i > 1 and not groups[k].include?(pos)
		end
	end

	groups
end

map = [] 
asteroids = []

File.open("input.txt", "r").each_with_index do |line, y|
	map << line.chomp
	line.chomp.each_char.with_index {|ch, x| asteroids << [x, y] if ch == '#'}
end

# max = asteroids.map {|o|
# 	[asteroids.map {|a| visible?(asteroids, o[0], o[1], a[0], a[1])}.count(true) - 1, o]
# }.max

o = [11, 13]

puts "part 1: Best is 11,13 with 210 other asteroids detected."

# part 2 ----------

def to(pos)
	[pos[0] - 11, pos[1] - 13]
end

def cw(a, b)
	a[0] * b[1] - a[1] * b[0] < 0
end

def mag(v)
	Math.sqrt(v[0] * v[0] + v[1] * v[1])
end

def angle(a, b)
	r = (a[0] * b[0] + a[1] * b[1]) / (mag(a) * mag(b))
	Math.acos(r.clamp(-1, 1))
end

#p cw([0, 1], [0, 2])

# to O coordinate space
asteroids = asteroids.map {|aster| [aster[0] - o[0], aster[1] - o[1]]}

asteroids.delete [0, 0]

p group_asteroids(asteroids).keys.map {|pair| [pair[0], pair[1]]}.select {|pair| pair[0] == 1}



exit

laser = [0, -1]

last_angle = -1

cx, cy = Window.width / 2, Window.height / 2

line = Line.new(
  x1: cx, y1: cy,
  width: 3,
  color: 'lime',
)

z = [11 - 11, 12 - 13]

p angle(laser, [12 - 11, 1 - 13])
p angle(laser, [12 - 11, 2 - 13])
p angle(laser, [12 - 11, 4 - 13])
p angle(laser, [12 - 11, 8 - 13])

behind = []


update do
	asteroids = asteroids - behind
	pos = asteroids.select {|aster| !cw(laser, aster) and angle(laser, aster) > last_angle}.sort_by {|aster| angle(laser, aster)}[0]

	behind = vaporize(asteroids, 0, 0, pos[0], pos[1])
	p behind
	asteroids -= behind

	last_angle = angle(laser, pos)

	@counter += 1

	x2, y2 = [pos[0] / mag(pos) * 100, pos[1] / mag(pos) * 100]

	line.x2 = x2 + cx
	line.y2 = y2 + cy

	#sleep 1
end

show
