# --- Day 7: Amplification Circuit ---

require_relative "../intcode.rb"

code = File.read("input.txt").split(',').map(&:to_i)

phases = [0, 1, 2, 3, 4]

signals = []

phases.permutation.to_a.map do |perm|
	output = [0]

	while perm.count > 0
		input = [perm.first] + output
		intcode = Intcode.new(code, input)
		output = intcode.run

		perm = perm.drop(1)
	end

	signals << output
end

puts "part 1: #{signals.flatten.max}"

