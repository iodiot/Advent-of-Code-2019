class Intcode
	def initialize(code, input)
		@code = code.dup
		@input = input
		@output = []

		@paused = true
		@halted = false

		@pos = 0
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

	def run
		@paused = false

		while true
			case @code[@pos] % 100 
			when 1, 2, 5, 6, 7, 8
				opcode, modes = @code[@pos] % 100, @code[@pos] / 100
				a, b, c = @code[(@pos + 1)..(@pos + 3)]
				a = @code[a] if modes % 10 == 0
				b = @code[b] if (modes / 10) % 10 == 0

				case opcode
				when 1	# add
					@code[c] = a + b
					@pos += 4
				when 2	# mul
					@code[c] = a * b
					@pos += 4
				when 5	# jump-if-true
					@pos = a != 0 ? b : @pos + 3
				when 6	# jump-if-false
					@pos = a == 0 ? b : @pos + 3
				when 7	# less-than
					@code[c] = a < b ? 1 : 0
					@pos += 4
				when 8	# equals
					@code[c] = a == b ? 1 : 0
					@pos += 4
				end

			when 3	# input
				if @input.empty?
					@paused = true
					break
				end

				addr = @code[@pos + 1]
				@code[addr] = @input.first
				@input = @input.drop(1)
				@pos += 2

			when 4	# output
				addr = @code[@pos + 1]
				@output << @code[addr]
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