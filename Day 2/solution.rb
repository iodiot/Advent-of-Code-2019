intcode = File.read("input.txt").split(',').map(&:to_i)

def run(intcode, noun, verb)
	pos = 0
	
	intcode[1] = noun
	intcode[2] = verb

	while true
		case intcode[pos]
		when 1
			a, b, c = intcode[(pos + 1)..(pos + 3)]
			intcode[c] = intcode[a] + intcode[b]
			pos += 4
		when 2
			a, b, c = intcode[(pos + 1)..(pos + 3)]
			intcode[c] = intcode[a] * intcode[b]
			pos += 4
		when 99
			break
		else
			raise StandartError, "Invalid Intcode"
		end
	end

	intcode[0]
end

puts "part 1: #{run(intcode.dup, 12, 2)}"

(0..99).each do |noun|
	(0..99).each do |verb|
		if run(intcode.dup, noun, verb) == 19690720
			puts "part 2: noun = #{noun}, verb = #{verb}, 100 * noun + verb = #{100 * noun + verb}"
			break
		end
	end
end
