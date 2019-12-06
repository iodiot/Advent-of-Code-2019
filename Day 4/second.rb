# --- Day 4: Secure Container ---

from = 402328
to = 864247

n = 0

for x in from..to
	arr = x.to_s.split('').map(&:to_i)

	inc = true

	for i in 1...6
		inc = false if arr[i] < arr[i - 1]
	end

	next unless inc

	k = 0

	for i in 1...6
		if arr[i] == arr[i - 1]
			k += 1
		else
			if k == 1
				n += 1
				k = 0
				break
			end

			k = 0
		end
	end

	n += 1 if k == 1
end

puts "part 2: #{n}"