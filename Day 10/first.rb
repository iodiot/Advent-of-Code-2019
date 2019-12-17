# --- Day 10: Monitoring Station ---

require 'ruby2d'

def gcd(a, b)
	b == 0 ? a : gcd(b, a % b)
end

@counter = 0

def vaporize(asteroids, x1, y1, x2, y2)
	dx, dy = x2 - x1, y2 - y1
	n = gcd(dx.abs, dy.abs)

	(1..n).each do |i| 
		pos = [x1 + dx / n * i, y1 + dy / n * i]

		if asteroids.include? pos
			asteroids.delete(pos)
			@counter += 1
			puts "The #{@counter}st asteroid to be vaporized is at #{pos[0]},#{pos[1]}."
			return
		end
	end
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

def cw(a, b)
	a[0] * b[1] - a[1] * b[0] < 0
end

def mag(v)
	Math.sqrt(v[0] * v[0] + v[1] * v[1])
end

def angle(a, b)
	(a[0] * b[0] + a[1] * b[1]) / (mag(a) * mag(b))
	#Math.acos(x)
end

p angle([0, 1], [0, -1])

alfa = Math::PI
x1 = o[0]
y1 = o[1]
px2, py2 = -1, -1

n = 0

cx, cy = Window.width / 2, Window.height / 2

p cx

line = Line.new(
  x1: cx, y1: cy,
  width: 3,
  color: 'lime',
)

update do

	if n < 10000
		x2, y2 = 250 * Math.sin(-alfa), 250 * Math.cos(alfa)

		line.x2 = x2 + cx
		line.y2 = y2 + cy

		#vaporize(asteroids, x1, y1, x2, y2)

		#puts "#{x2},#{y2}"

		n += 1

		alfa += Math::PI / 360
	end

end

show