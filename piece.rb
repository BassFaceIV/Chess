class Piece
	@@pieces = 0
	attr_accessor :id
	attr_accessor :color
	attr_accessor :moves

	def initialize(color)
		@id = @@pieces
		@color = color

		@@pieces += 1
	end

	def generate_moves
		#generates immediate possible moves
		raise NotImplementedError.new "generate_moves"
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