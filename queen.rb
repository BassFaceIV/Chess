require_relative 'piece'

class Queen < Piece
	def generate_moves(board)
		queen_moves = {:n => [], :ne => [], :e => [], :se => [], :s => [], :sw => [], :w => [], :nw => []}
		move_range =* (-7..7)

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

		queen_moves = apply_boundaries(coordinates, queen_moves)
		queen_moves = apply_attacks(coordinates, queen_moves)
	end

	def apply_boundaries(coordinates, modifiers)
		modifiers.each do |mod|
			if mod[1][0].is_a?(Array)
				mod[1].each do |dist|
					if (coordinates[0] + dist[0] < 0) || (coordinates[0] + dist[0] > 7) || (coordinates[1] + dist[1] < 0) || (coordinates[1] + dist[1] > 7)
						mod[1].delete(dist)
					end
				end

				if mod[1].empty?
					modifiers.delete(mod)
				end
			else
				if (coordinates[0] + mod[1][0] < 0) || (coordinates[0] + mod[1][0] > 7) || (coordinates[1] + mod[1][1] < 0) || (coordinates[1] + mod[1][1] > 7)
					modifiers.delete(mod)
				end
			end
		end

		return modifiers
	end

	def apply_attacks(board, modifiers)
		modifiers.each do |direction|
			remove_remaining = false

			direction[1].each do |distance|
				if remove_remaining
					direction[1].delete(distance)
				elsif !board.nodes[distance[0]][distance[1]].nil?
					remove_remaining = true
				end
			end
		end

		return modifiers
	end
end

#add apply_boundaries to Piece
#add board parameter to generate_moves template in Piece