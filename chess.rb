require_relative 'board'

class Chess
	attr_accessor :board
	attr_accessor :player_turn
	attr_accessor :game_over
	attr_accessor :player_ended

	def initialize
		#Add logic to create new game or load an existing one
		@board = Board.new
		@player_turn = 1
		@game_over = false
		@player_ended = false
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
				begin
					from, to = query_player
				end while (from == :unrecognized)

				moved = @board.move(player_turn, from, to) if !@player_ended
				@board.update
				winner = @board.check_mate?(@player_turn == 1 ? 2 : 1)
				@game_over = winner || @player_ended
			end while !moved && !@game_over

			if winner != false
				puts "Player #{@player_turn} destroyed Player #{@player_turn == 1 ? 2 : 1}!"
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
		move = move.split(" ")

		case
		when move[0] == "quit" then @player_ended = true
		when move[1] == "=>"
			from, to = move[0], move[2]

			from = from.split("")
			from[0] = from[0].ord - 97
			from[1] = from[1].to_i

			to = to.split("")
			to[0] = to[0].ord - 97
			to[1] = to[1].to_i

			return from, to
		else
			puts "Command not recognized"
			return :unrecognized
		end
	end
end

game = Chess.new
game.game_loop