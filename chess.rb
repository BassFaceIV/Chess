require_relative 'board'

class Chess
	attr_accessor :board

	def initialize
		#Add logic to create new game or load an existing one
		@board = Board.new
	end

	def load_game
		pass
	end

	def save_game
		pass
	end

	def game_loop
		@board.display
	end

	def query_player
		pass
	end
end

game = Chess.new
game.game_loop
game.board.move(game.board.nodes[3][0][0], [3, 6])
game.board.display
game.board.move(game.board.nodes[3][6][0], [7, 2])
game.board.display
game.board.move(game.board.nodes[7][2][0], [0, 6])
game.board.display
game.board.move(game.board.nodes[7][2][0], [7, 2])
game.board.display
game.board.move(game.board.nodes[7][2][0], [9, 2])
game.board.display
game.board.move(game.board.nodes[7][2][0], [0, 2])
game.board.display