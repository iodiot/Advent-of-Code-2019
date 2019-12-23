# --- Day 22: Slam Shuffle ---

def egcd(a, b)
	if a == 0
	    return [b, 0, 1]
	else
    g, y, x = egcd(b % a, a)
    return [g, x - (b / a) * y, y]
  end
end

def modinv(a, m)
  g, x, y = egcd(a, m)
 
  if g != 1
    raise 'Modular inverse does not exist'
  else
    return x % m
  end
end

n = 101741582076661
D = 119315717514047

print((pow(A, n, D)*X + (pow(A, n, D)-1) * modinv(A-1, D) * B) % D)