# --- Day 5: Sunny with a Chance of Asteroids ---

def run(intcode, input)
	pos = 0

	output = []
	
	while true
		case intcode[pos] % 100 
		when 1, 2, 5, 6, 7, 8
			opcode, modes = intcode[pos] % 100, intcode[pos] / 100
			a, b, c = intcode[(pos + 1)..(pos + 3)]
			a = intcode[a] if modes % 10 == 0
			b = intcode[b] if (modes / 10) % 10 == 0

			case opcode
			when 1	# add
				intcode[c] = a + b
				pos += 4
			when 2	# mul
				intcode[c] = a * b
				pos += 4
			when 5	# jump-if-true
				pos = a != 0 ? b : pos + 3
			when 6	# jump-if-false
				pos = a == 0 ? b : pos + 3
			when 7	# less-than
				intcode[c] = a < b ? 1 : 0
				pos += 4
			when 8	# equals
				intcode[c] = a == b ? 1 : 0
				pos += 4
			end

		when 3	# input
			addr = intcode[pos + 1]
			intcode[addr] = input
			pos += 2

		when 4	# output
			addr = intcode[pos + 1]
			output << intcode[addr]
			pos += 2

		when 99	# halt
			break
		else
			raise "Invalid Intcode: #{intcode[pos]}"
		end
	end

	output
end

intcode = File.read("input.txt").split(',').map(&:to_i)

puts "part 1: #{run(intcode.dup, 1).last}"
puts "part 2: #{run(intcode.dup, 5).last}"

