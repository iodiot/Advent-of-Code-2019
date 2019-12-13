# --- Day 13: Care Package ---

require_relative '../intcode.rb'
require "ruby2d"

code = File.read("input.txt").split(',').map(&:to_i)

TYPES = {0 => :empty, 1 => :wall, 2 => :block, 3 => :paddle, 4 => :ball}

code[0] = 2
arcade = Intcode.new(code, [])
output = arcade.run

tiles = {}

n = 0

while n < output.count
	x, y, t = output[n..n + 2]

	type = TYPES[t]

	if x != -1
		tiles[[x, y]] = type
	end

	n += 3
end

blocks = tiles.values.count :block

puts "part 1: #{blocks}"

# part 2 ----------

SIZE = 10
TOP_X = (get :width) / 2 - tiles.keys.map {|x| x[0]}.max * SIZE / 2
TOP_Y = 50

def sgn(x)
	return 0 if x == 0
	x > 0 ? +1 : -1
end

def show_tile(x, y, t, w)
	xx = x * SIZE + TOP_X
	yy = y * SIZE + TOP_Y

	case t
	when :empty
		return Square.new(x: xx, y: yy, size: SIZE, color: "black", z: 0)
	when :wall
		return Square.new(x: xx, y: yy, size: SIZE, color: "gray", z: 0)
	when :block
		return Square.new(x: xx, y: yy, size: SIZE, color: "blue", z: 0)
	when :paddle
		return Square.new(x: xx, y: yy, size: SIZE, color: "yellow", z: 10)	
	when :ball
		return Circle.new(x: xx, y: yy, radius: SIZE / 2, color: "red", z: 10)
	end
end

def show_screen(tiles)
	set title: "--- Day 13: Care Package ---"

	w = tiles.keys.map {|x| x[0]}.max
	h = tiles.keys.map {|x| x[1]}.max

	screen_tiles = {}
	screen_ball = nil
	screen_pad = nil

	screen_score = Text.new(
  	"",
  	x: 20, y: 20,
  	size: 20,
  	color: 'white',
	)

	for y in 0..h
		for x in 0..w
			st = show_tile(x, y, tiles[[x, y]], w)			

			if tiles[[x, y]] == :ball
				screen_ball = st 
			elsif  tiles[[x, y]] == :paddle
				screen_pad = st 
			else
				screen_tiles[[x, y]] = st
			end
		end
	end

	[screen_tiles, screen_ball, screen_pad, screen_score]
end

arcade.send_to_input([0])
arcade.clear_output

score = 0

screen_tiles, screen_ball, screen_pad, screen_score = show_screen(tiles)

update do 

	if not arcade.halted? 
		output = arcade.run
		arcade.clear_output

		n = 0

		while n < output.count
			x, y, t = output[n..n + 2]

			if x != -1
				type = TYPES[t]
				tiles[[x, y]] = type
				
				screen_tiles[[x, y]].remove if screen_tiles.key? [x, y] and  type == :empty

			else
				screen_score.text = "Score: #{t}"
			end

			n += 3
		end	

		pad = tiles.keys.find {|x| tiles[x] == :paddle}
		ball = tiles.keys.find {|x| tiles[x] == :ball}

		# update screen ball and pad
		screen_pad.x = pad[0] * SIZE + TOP_X
		screen_pad.y = pad[1] * SIZE + TOP_Y
		screen_ball.x = ball[0] * SIZE + TOP_X
		screen_ball.y = ball[1] * SIZE + TOP_Y

		arcade.send_to_input(sgn(ball[0] - pad[0]))
	end

end

show

puts "part 2: #{score}"




