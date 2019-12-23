# --- Day 22: Slam Shuffle ---

techniques = []

File.open("input.txt", "r").each do |line|
	tokens = line.chomp.split(' ')
	if tokens[0] == "deal"
		techniques << ["inc", tokens[-1].to_i]  if tokens[2] == "increment"
 		techniques << ["deal"] if tokens[2] == "new"
 	else
 		techniques << ["cut", tokens[-1].to_i]
 	end
end

cards = (0..10006).map {|x| x}

techniques.each do |tech|
	new_cards = []

	case tech[0]
	when "deal"
		new_cards = cards.reverse
	when "inc"
		i = 0
		j = 0

		new_cards = cards.clone 

		while i < cards.length
			new_cards[j % new_cards.length] = cards[i]
			i += 1
			j += tech[1]
		end
	when "cut"
		n = tech[1]

		new_cards = cards[n..-1] + cards[0...n] if n > 0
		new_cards = cards[n..-1] + cards[0...n] if n < 0
	end

	cards = new_cards
end

p cards.index 2019