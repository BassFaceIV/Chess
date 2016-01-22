class Piece
	@@pieces = 0
	attr_accessor :id
	attr_accessor :color

	def initialize(color)
		@id = @@pieces
		@color = color

		@@pieces += 1
	end
end