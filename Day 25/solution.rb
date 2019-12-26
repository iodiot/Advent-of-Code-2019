#  --- Day 25: Cryostasis ---

require_relative '../intcode.rb'

def to_bytes(str)
	str += "\n" unless str[-1] == "\n"
	str.each_char.map {|x| x.ord}
end

def sensitive_floor?(output)
	output.include?("== Pressure-Sensitive Floor ==")
end

def read_items(output)
	items = []

	if output.include? "Items here:"
		n = output.index("Items here:") + 1

		while output[n].length > 0
			items << output[n][2..]
			n += 1
		end
	end

	items
end

def read_doors(output)
	doors = []

	if output.include? "Doors here lead:"
		n = output.rindex("Doors here lead:") + 1


		while output[n].length > 0
			doors << output[n][2..]
			n += 1
		end
	end

	doors
end

code = File.read("input.txt").split(',').map(&:to_i)

droid = Intcode.new(code, [])

ticks = 0

bad_items = ["giant electromagnet", "escape pod", "molten lava", "photons", "infinite loop"]

area = {}
x, y = 0, 0

last_doors = []

items = []


while true
	droid.clear_output
	output = droid.run.map {|x| x.chr}.join.split("\n")

	cmd = output.join.index("Command?") != nil

 	unless cmd
 		puts "final output:"
		puts output
		break
 	end

 	items_in_room = read_items(output)

 	item = (items_in_room - bad_items).sample

 	doors_in_room = read_doors(output)

 	last_doors = doors_in_room if doors_in_room.length > 0

 	if sensitive_floor?(output) and items.count >= 4
 		item_to_drop = items.sample
 		droid.send_to_input to_bytes("drop #{item_to_drop}")
 		#puts "DROP #{item_to_drop}"
 		items.delete item_to_drop
 	elsif (not item.nil?) and items.count < 4
 		droid.send_to_input to_bytes("take #{item}")
 		#puts "TAKE #{item}"
 		items << item
 	else
 		door = last_doors.sample

 		droid.send_to_input to_bytes(door)
 		#puts "MOVE #{door}"
 	end


	ticks += 1
end

puts ""
puts "correct items: #{items}"

