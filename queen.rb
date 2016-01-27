require_relative 'piece'

class Queen < Piece
	def generate_moves
		#queen_moves = {:n => [], :ne => [], :e => [], :se => [], :s => [], :sw => [], :w => [], :nw => []}
		queen_moves = []
		move_range =* (1..7)
		@moves = []

		move_range.each do |x|
			queen_moves << [0, x]
			queen_moves << [x, x]
			queen_moves << [x, 0]
			queen_moves << [x, -x]
			queen_moves << [0, -x]
			queen_moves << [-x, -x]
			queen_moves << [-x,0]
			queen_moves << [-x, x]
		end

		apply_boundaries(queen_moves)
		apply_attacks(queen_moves)

		queen_moves.each do |distance|
			@moves << [@position[0] + distance[0], @position[1] + distance[1]]
		end
	end
end