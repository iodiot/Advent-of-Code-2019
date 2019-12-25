# --- Day 24: Planet of Discord ---

def count_adjacent(area, x, y)
	n = 0
	w, h = area[0].length, area.length
	[[x - 1, y], [x + 1, y], [x, y - 1], [x, y + 1]].each do |xx, yy|
		n += (area[yy][xx] == '#' ? 1 : 0) if xx >= 0 and xx < w and yy >= 0 and yy < h 
	end
	n
end

def calc_rating(area)
	i = area.join.index('#')
	rating = 0

	while not i.nil?
		rating += 1 << i
		i = area.join.index('#', i + 1)
	end

	rating
end

area = []

File.open("input.txt", "r").each do |line|
	area << line.chomp
end

layouts = []

while true do 
	new_area = area.map {|row| ' ' * row.length}

	for y in 0...area.length
		for x in 0...area[0].length
			n = count_adjacent(area, x, y)

			if area[y][x] == '#'
				new_area[y][x] = n == 1 ? '#' : '.'
			else
				new_area[y][x] = ((n == 1) or (n == 2)) ? '#' : '.'
			end
		end
	end

	area = new_area

	new_layout = area.join

	if layouts.include? new_layout
		puts calc_rating(area)
		break
	end

	layouts << new_layout
end

