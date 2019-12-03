sum = 0

File.open("input.txt", "r").each do |line|
	x = line.to_i 

	while true
		x = (x / 3).floor - 2
		break if x <= 0
		sum += x
	end
end

puts "part 2: #{sum}"