from = 402328
to = 864247

n = 0

for x in from..to
	arr = x.to_s.split('').map(&:to_i)

	inc = true
	pair = false

	for i in 1...6
		inc = false if arr[i] < arr[i - 1]
		pair = true if arr[i] == arr[i - 1]
	end

	n += 1 if inc and pair
end

puts "part 1: #{n}"