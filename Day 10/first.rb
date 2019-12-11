# --- Day 10: Monitoring Station ---

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

alfa = 0
step = Math::PI / 360
len = 29
x1 = o[0]
y1 = o[1]
px2, py2 = -1, -1

n = 0

y2 = 1

while true 
	# x2 = (len * Math.sin(alfa) + x1).round
	# y2 = (-len * Math.cos(alfa) + y1).round



	# alfa += step

	# next if x2 == px2 and y2 == py2

	# px2, py2 = x2, y2

		x2 = 11 + n
		y2 = -13

vaporize(asteroids, x1, y1, x2, y2)


	#puts "#{x2},#{y2}"
#
	n += 1
	break if n > 10
end

