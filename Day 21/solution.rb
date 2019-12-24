# --- Day 21: Springdroid Adventure ---

require_relative '../intcode.rb'

def to_bytes(str)
	str.gsub("\n\n", "\n").to_s.each_char.map {|x| x.ord}
end

script_1 = [
	'OR A J', 
	'AND B J',
	'AND C J',
	'NOT J J',
	'AND D J',
	'WALK',
	''
]

script_2 = [
	'OR A J', 
	'AND B J',
	'AND C J',
	'NOT J J',
	'AND D J',
	'OR H T',
	'OR E T',
	'AND T J',
	'RUN',
	''
]

code = File.read("input.txt").split(',').map(&:to_i)

puts "part 1: #{Intcode.new(code, to_bytes(script_1.join("\n"))).run[-1]}"
puts "part 2: #{Intcode.new(code, to_bytes(script_2.join("\n"))).run[-1]}"

