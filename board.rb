class Board
	attr_accessor :nodes

	def initialize
		@nodes = []
		8.times { @nodes << [] }
		@nodes.each do |node|
			8.times { node << [] }
		end

		#king: 4,0/7
		@nodes[4][0] << King.new(:white)
		@nodes[4][7] << King.new(:black)

		#queen: 3,0/7
		@nodes[3][0] << Queen.new(:white)
		@nodes[3][7] << Queen.new(:black)
	end

	def move(piece, destination)
		if piece.legal_move?(destination)
			@nodes[destination[0]][destination[1]][0] << @nodes[piece.position[0]][piece.position[1]].pop
		end
	end
end