# --- Day 12: The N-Body Problem ---

def compare(initial, bodies, dim)
	for i in 0...4
		return false if initial[i][:p][dim] != bodies[i][:p][dim]
	end
	true
end

initial = []

File.open("input.txt", "r").each do |line|
	initial << {:p => line.scan(/-?\d+/).map(&:to_i), :v => [0, 0, 0]}
end

numbers = []

for dim in 0...3 do
	n = 0

	# copy
	bodies = initial.map {|x| {:p => x[:p].dup, :v => x[:v].dup}}

	while true do 
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

		if compare(initial, bodies, dim) 
			numbers << n + 2
			break
		end

		n += 1
	end
end

steps_count = numbers.reduce(1, :lcm)

puts "part 2: #{steps_count}

