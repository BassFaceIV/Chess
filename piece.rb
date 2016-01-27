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
		modifiers.delete_if { |mod| (coordinates[0] + mod[0] < 0) || (coordinates[0] + mod[0] > 7) || (coordinates[1] + mod[1] < 0) || (coordinates[1] + mod[1] > 7) }
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