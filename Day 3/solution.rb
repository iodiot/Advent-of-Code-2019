lines = File.read("input.txt").split("\n")

def to_points(line)
	points = [[0, 0]]
	x, y = 0, 0
	line.split(',').each do |turn|
		dir, step = turn[0], turn[1..].to_i
		x += step if dir == 'R'
		x -= step if dir == 'L'
		y += step if dir == 'U'
		y -= step if dir == 'D'
		points << [x, y, step]
	end
	points 
end

points_1 = to_points(lines[0])
points_2 = to_points(lines[1])

crosses = []
steps = []

steps_1 = 0

for i in 1...points_1.count
	steps_2 = 0

	for j in 1...points_2.count
		a, b = points_1[i - 1], points_1[i]
		c, d = points_2[j - 1], points_2[j]

		ab_hor = a[1] == b[1]
		cd_hor = c[1] == d[1]

		# intersects only if one is horizontal and second is vertical 
		if ab_hor ^ cd_hor
			a, b, c, d = c, d, a, b if (not ab_hor) and cd_hor
			aa, cc = a, c
			a, b = b, a if a[0] > b[0]
			c, d = d, c if c[1] > d[1]
			cross = [d[0], a[1]]

			if (a[1] > c[1]) and (a[1] < d[1]) and (c[0] > a[0]) and (c[0] < b[0])
				crosses << cross  
				steps << steps_1 + steps_2 + (cross[0] - aa[0]).abs + (cross[1] - cc[1]).abs
			end
		end

		steps_2 += points_2[j][2]
	end

	steps_1 += points_1[i][2]
end

min_distance = crosses.map {|point| point[0].abs + point[1].abs }.min
min_steps = steps.min

puts "part 1: #{min_distance}"
puts "part 2: #{min_steps}"