require_relative 'piece'

class Knight < Piece
	def generate_moves
		knight_moves = [[1, 2], [2, 1], [2, -1], [1, -2], [-1, -2], [-2, -1], [-2, 1], [-1, 2]]
		@moves = []

		apply_boundaries(knight_moves)

		knight_moves.each do |distance|
			@moves << [@position[0] + distance[0], @position[1] + distance[1]]
		end
	end

	def apply_friendlies(modifiers)
		modifiers.delete_if do |mod|
			@allies.any? do |ally|
				ally == [@position[0] + mod[0], @position[1] + mod[1]]
			end
		end
	end
end