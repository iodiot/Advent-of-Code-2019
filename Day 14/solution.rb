# --- Day 14: Space Stoichiometry ---

reactions = {}

File.open("input.txt", "r").each do |line|
	left, right = line.split('=>')

	out_q, out_el = right.chomp.split(' ')

	reactions[out_el] = {:q => out_q.to_i, :i => left.split(',').map {|x| x.split(' ')}}
end

leftovers = {}

reactions.keys.each {|x| leftovers[x] = 0}

def react(reactions, leftovers, required_q, required_el)
	available = [leftovers[required_el], required_q].min
	leftovers[required_el] -= available
	required_q -= available
	return [0, 0] if required_q == 0

	output_q = reactions[required_el][:q]

	batches = (required_q.to_f / output_q.to_f).ceil

	ore = 0

	reactions[required_el][:i].each do |pair|
		q, el  = pair[0].to_i, pair[1]

		if el == 'ORE'
			ore += q * batches
		else
			leftover, ore_to_add = react(reactions, leftovers, q * batches, el)
			leftovers[el] += leftover
			ore += ore_to_add
		end
	end

	return [output_q * batches - required_q, ore]
end

part_1 = react(reactions, leftovers.dup, 1, 'FUEL')[1]

max_ore = 1000000000000
max_n = max_ore / 100

part_2 = (1..max_n).bsearch {|x| react(reactions, leftovers.dup, x, 'FUEL')[1] > max_ore } - 1

puts "part 1: #{part_1}"
puts "part 2: #{part_2}"
