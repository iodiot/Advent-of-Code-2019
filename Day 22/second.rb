# --- Day 22: Slam Shuffle ---

def invmod(a, m)
	def egcd(a, b)
		if a == 0
		    return [b, 0, 1]
		else
	    g, y, x = egcd(b % a, a)
	    return [g, x - (b / a) * y, y]
	  end
	end

  g, x, y = egcd(a, m)

  if g != 1
    raise 'Modular inverse does not exist'
  else
    return x % m
  end
end

nc = 119315717514047
n = 101741582076661
a, b = 1, 0

File.open("input.txt", 'r').read.lines.reverse.each do |line|
  case line.chomp
  when /new/ then a,b = -a, -b + nc-1
  when /cut (.*)/ then b += $1.to_i
  when /increment (.*)/ then a *= m=invmod $1.to_i, nc; b *= m
  end
end

r = (2020 * a.pow(n, nc) + b * (a.pow(n, nc) - 1) * invmod(a - 1, nc)) % nc

puts "part 2: #{r}"


