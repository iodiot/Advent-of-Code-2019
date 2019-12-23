# --- Day 23: Category Six ---

require_relative '../intcode.rb'

code = File.read("input.txt").split(',').map(&:to_i)

n = 50

computers = n.times.map {|x| Intcode.new(code, [x, -1])}

last_nat_packet = []
last_nat_y = -1

part_1 = -1
part_2 = -1

while true
	packets = Hash.new {|h, k| h[k] = [] }

	computers.each do |comp|
		output = comp.run

		i = 0

		while i < output.length
			addr, x, y = output[i], output[i + 1], output[i + 2]
			packets[addr] << [x, y]
			i += 3
		end

		comp.clear_output
	end

	if packets[255].length > 0
		last_nat_packet = packets[255][-1]

		part_1 = packets[255][-1][1] if part_1 == -1
	end

	idle_counter = 0

	n.times.each do |i|
		if packets[i].length > 0
			computers[i].send_to_input(packets[i])
		else
			computers[i].send_to_input([-1])
			idle_counter += 1
		end
	end

	if idle_counter == n 
		computers[0].send_to_input(last_nat_packet)

		if last_nat_packet[1] == last_nat_y
			part_2 = last_nat_y
			break
		end
		last_nat_y = last_nat_packet[1]
	end
end

puts "part 1: #{part_1}"
puts "part 2: #{part_2}"