# --- Day 8: Space Image Format ---

w, h = 25, 6
#w, h = 2, 2

image = File.read("input.txt").split('').map(&:to_i)

pos = 0

layers = []

while pos < image.count
	layers << image[pos...(pos + w * h)]
	pos += w * h
end

right_layer = layers.sort {|a, b| a.count(0) <=> b.count(0) }.first

n = right_layer.count(1) * right_layer.count(2)

puts "part 1: #{n}"

final = []

for i in 0...w * h
	for j in 0...layers.count
		color = layers[j][i]
		if color == 0 or color == 1
			final << color
			break
		end
	end
end

puts "part 2:"

(0...h).each do |row|
	puts final[row * w...(row + 1) * w].map {|x| x == 0 ? ' ' : '*'}.join
end