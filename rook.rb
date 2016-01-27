require_relative 'piece'

class Rook < Piece
	def generate_moves
		rook_moves = []
		move_range =* (1..7)
		@moves = []

		move_range.each do |x|
			rook_moves << [0, x]
			rook_moves << [x, 0]
			rook_moves << [0, -x]
			rook_moves << [-x, 0]
		end

		apply_boundaries(rook_moves)
		apply_attacks(rook_moves)

		rook_moves.each do |distance|
			@moves << [@position[0] + distance[0], @position[1] + distance[1]]
		end
	end
end