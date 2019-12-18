# --- Day 16: Flawed Frequency Transmission ---

input = File.read('input.txt').split('').map &:to_i


phases = 100
pattern = [0, 1, 0, -1]

phases.times do
	new_input = []

	for i in 0...input.count
		sum = 0

		for j in 0...input.count
			sum += input[j] * pattern[((j + 1) / (i + 1)) % pattern.count]
		end

		new_input << sum.abs % 10
	end

	input = new_input
end

puts "part 1: #{input.join[0...8]}"

