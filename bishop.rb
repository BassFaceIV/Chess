require_relative 'piece'

class Bishop < Piece
	def generate_moves
		bishop_moves = []
		move_range =* (1..7)
		@moves = []

		move_range.each do |x|
			bishop_moves << [x, x]
			bishop_moves << [x, -x]
			bishop_moves << [-x, -x]
			bishop_moves << [-x, x]
		end

		apply_boundaries(bishop_moves)
		puts "Modifiers A: #{bishop_moves}"
		apply_attacks(bishop_moves)
		puts "Modifiers B: #{bishop_moves}"

		bishop_moves.each do |distance|
			@moves << [@position[0] + distance[0], @position[1] + distance[1]]
		end

		puts "moves: #{@moves}"
	end
end