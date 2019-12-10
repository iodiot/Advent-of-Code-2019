# --- Day 7: Amplification Circuit ---

require_relative "../intcode.rb"

code = File.read("input.txt").split(',').map(&:to_i)

phases = [5, 6, 7, 8, 9]

signals = []

phases.permutation.to_a.map do |perm|
	output = [0]

	ampls = perm.map {|phase| Intcode.new(code, [phase])}

	ampls[0].send_to_input(0)

	curr = 0

	while ampls.any? {|a| not a.halted?}
		output = ampls[curr].run
		curr = (curr + 1) % ampls.count
		ampls[curr].send_to_input(output.last)
	end

	signals << output
end

puts "part 2: #{signals.flatten.max}"


