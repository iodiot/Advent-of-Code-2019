class Intcode
	def initialize(code, input)
		@code = code.dup
		@input = input
		@output = []

		@paused = true
		@halted = false

		@pos = 0
		@rbase = 0
	end

	def send_to_input(x)
		@input << x
		@input.flatten!
	end

	def halted?
		@halted
	end

	def paused?
		@paused
	end

	def output
		@output
	end

	def get(pos, mode = 0)
		raise "Negative address" if pos < 0

		@code[pos] = 0 if @code[pos].nil?
		addr = @code[pos]

		case mode % 10
		when 0
			return get(addr, 1)
		when 1
			return addr
		when 2
			return get(addr + @rbase, 1)
		end
	end

	def set(pos, val, mode = 0)
		raise "Negative address" if pos < 0

		case mode % 10
		when 0
			addr = @code[pos]
			@code[addr] = val
		when 1
			@code[pos] = val
		when 2
			addr = @code[pos]
			@code[addr + @rbase] = val
		end 
	end

	def run
		@paused = false

		while true
			opcode, modes = @code[@pos] % 100, @code[@pos] / 100

			case opcode
			when 1, 2, 5, 6, 7, 8
				a, b = get(@pos + 1, modes), get(@pos + 2, modes / 10)

				case opcode
				when 1	# add
					set(@pos + 3, a + b, modes / 100)
					@pos += 4
				when 2	# mul
					set(@pos + 3, a * b, modes / 100)
					@pos += 4
				when 5	# jump-if-true
					@pos = a != 0 ? b : @pos + 3
				when 6	# jump-if-false
					@pos = a == 0 ? b : @pos + 3
				when 7	# less-than
					set(@pos + 3, a < b ? 1 : 0, modes / 100)
					@pos += 4
				when 8	# equals
					set(@pos + 3, a == b ? 1 : 0, modes / 100)
					@pos += 4
				end

			when 3	# input
				if @input.empty?
					@paused = true
					break
				end

				set(@pos + 1, @input.first, modes)

				@input = @input.drop(1)
				@pos += 2

			when 4	# output
				@output << get(@pos + 1, modes)
				@pos += 2

			when 9	# adjust relative base
				@rbase += get(@pos + 1, modes)
				@pos += 2

			when 99	# halt
				@halted = true
				break
			else
				raise "Invalid Intcode: #{@code[@pos]}"
			end
		end

		@output
	end
end