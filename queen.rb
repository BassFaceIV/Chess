require_relative 'piece'

class Queen < Piece
	def generate_moves
		queen_moves = {:n => [], :ne => [], :e => [], :se => [], :s => [], :sw => [], :w => [], :nw => []}
		move_range =* (-7..7)
		@moves = []

		move_range.each do |x|
			queen_moves[:n] << [0, x]
			queen_moves[:ne] << [x, x]
			queen_moves[:e] << [x, 0]
			queen_moves[:se] << [x, -x]
			queen_moves[:s] << [0, -x]
			queen_moves[:sw] << [-x, -x]
			queen_moves[:w] << [-x,0]
			queen_moves[:nw] << [-x, x]
		end

		#queen_moves = apply_boundaries(@position, queen_moves)
		#queen_moves = apply_attacks(board, queen_moves)

		queen_moves.each do |direction, distances|
			distances.each do |distance|
				@moves << [@position[0] + distance[0], @position[1] + distance[1]]
			end
		end
	end

	def apply_attacks(board, modifiers)
		modifiers.each do |direction|
			remove_remaining = false

			direction[1].each do |distance|
				puts "#{board.nodes[@position[0] + distance[0]][@position[1] + distance[1]]}"
				if remove_remaining
					direction[1].delete(distance)
				elsif !board.nodes[@position[0] + distance[0]][@position[1] + distance[1]].nil?
					remove_remaining = true
				end
			end
		end

		return modifiers
	end
end