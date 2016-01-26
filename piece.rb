class Piece
	@@pieces = 0
	attr_accessor :id
	attr_accessor :color
	attr_accessor :moves
	attr_accessor :position
	attr_accessor :display

	def initialize(color, position, symbol)
		@id = @@pieces
		@color = color
		@moves = []
		@position = position
		@display = symbol

		generate_moves

		@@pieces += 1
	end

	def generate_moves
		#generates immediate possible moves
		raise NotImplementedError.new "generate_moves"
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

	def legal_move?(destination)
		#checks to see if desired move is in possible moves
		@moves.each do |coordinates|
			if (coordinates === destination)
				return true
			end
		end

		puts "Illegal move"
		return false
	end
end