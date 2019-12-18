# --- Day 16: Flawed Frequency Transmission ---

input = File.read('input.txt').split('').map &:to_i

phases = 100
pattern = [0, 1, 0, -1]

offset = input[0...7].join.to_i
count = input.count * 10000

new_input = []
(count - 1).downto(offset) {|x| new_input << input[x % input.count]}
input = new_input

phases.times do
	new_input = []

	sum = 0

	input.each do |x|
		sum += x
		new_input << sum.abs % 10 
	end

	input = new_input
end

puts "part 2: #{input.reverse[0...8].join}

