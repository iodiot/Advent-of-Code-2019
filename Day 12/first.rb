# --- Day 12: The N-Body Problem ---

require 'ruby2d'

def total_energy(bodies)
	bodies.map {|body| body[:p].map {|x| x.abs}.sum * body[:v].map {|x| x.abs}.sum}.sum
end

bodies = []
steps = []


File.open("input.txt", "r").each do |line|
	bodies << {:p => line.scan(/-?\d+/).map(&:to_i), :v => [0, 0, 0]}
end

1000.times do |n|
	# apply gravity
	bodies.each do |a|
		bodies.each do |b|
			next if a == b

			for k in 0...3
				a[:v][k] += a[:p][k] < b[:p][k] ? +1 : -1 unless a[:p][k] == b[:p][k]
			end
		end
	end

	# apply velocity
	bodies.each do |body|
		for k in 0...3
			body[:p][k] += body[:v][k]
		end
	end

	steps << bodies.map {|body| body[:p].dup}
end

puts "part 1: #{total_energy(bodies)}"

def visualize(steps)
	set title: "--- Day 12: The N-Body Problem ---"

	n = 0
	size = 10

	colors = ["red", "yellow", "blue", "green"]

	circles = []

	cx = (get :width) / 2
	cy = (get :height) / 2

	for i in 0...4
		circles[i] = Circle.new(radius: size, color: colors[i])
	end

	text = Text.new(
  	"",
  	x: 25, y: 25,
  	size: 20,
  	color: 'white',
	)

	update do
		sleep 0.5
		if n < steps.count
			text.text = "Step: #{n}"

			for i in 0...4
				pos = steps[n][i]

				circles[i].x = pos[0] * size * 2 + cx
				circles[i].y = pos[1] * size * 2 + cy
				circles[i].z = pos[2]
			end

			n += 1
		end
	end

	show
end

# visualize(steps)