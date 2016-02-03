require_relative 'board'

class Chess
	attr_accessor :board
	attr_accessor :player_turn
	attr_accessor :game_over

	def initialize
		#Add logic to create new game or load an existing one
		@board = Board.new
		@player_turn = 1
		@game_over = false
	end

	def load_game
		pass
	end

	def save_game
		pass
	end

	def game_loop
		board.update

		while !@game_over
			@board.display

			moved = false
			begin
				from, to = query_player
				moved = @board.move(player_turn, from, to) if !@game_over
				#puts "-------------------------------GAME LOOP---------------------------------"
				@board.update
				#puts @board.kings[:black].check_mate
			end while !moved && !@game_over

			winner = false#@board.check_mate?
			if winner != false
				puts "Player #{@player_turn} destroyed Player #{@player_turn == 1 ? 2 : 1}!"
				@game_over = true
			end
			
			@player_turn = @player_turn == 1 ? 2 : 1
		end
	end

	def query_player
		puts "Moves: [a# => b#], [quit]"
		print "(Player #{player_turn}) >> "
		move = gets.chomp
		return parseMove(move)
	end

	def parseMove(move)
		case move
		when "quit" then @game_over = true
		else
			from, to = move.split(" => ")

			from = from.split("")
			from[0] = from[0].ord - 97
			from[1] = from[1].to_i

			to = to.split("")
			to[0] = to[0].ord - 97
			to[1] = to[1].to_i

			return from, to
		end
	end
end

game = Chess.new
game.game_loop
#game.board.move(game.board.nodes[3][0][0], [3, 6])
#game.board.pass_others(game.board.nodes[4][7][0])
#puts "Check: #{game.board.nodes[4][7][0].in_check?}"
#game.board.display