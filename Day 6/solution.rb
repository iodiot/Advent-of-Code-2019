# --- Day 6: Universal Orbit Map ---

orbits = {}

File.open("input.txt", "r").each do |line|
	right, left = line.strip.split(')')
	orbits[left] = right
end

dp = {}

orbits.keys.each do |planet|
	seq = []
	curr = planet
	while curr != "COM"
		if dp.key? curr
			seq += dp[curr]
			break
		end

		curr = orbits[curr]
		seq << curr
	end 

	dp[planet] = seq
end

puts "part 1: #{dp.values.map {|x| x.count}.reduce &:+}"

transfers = 0

dp["YOU"].each do |planet|
	if dp["SAN"].include? planet
		transfers = dp["YOU"].find_index(planet) + dp["SAN"].find_index(planet)
		break
	end
end

puts "part 2: #{transfers}"