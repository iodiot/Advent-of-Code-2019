sum = 0

File.open("input.txt", "r").each do |line|
	sum += (line.to_i / 3).floor - 2
end

puts "part 1: #{sum}"