require_relative 'piece'

class King < Piece
	attr_accessor :castled
	attr_accessor :check
	attr_accessor :check_mate

	def initialize(color, position, symbol)
		super(color, position, symbol)
		@castled = false
		@check = false
		@check_mate = false
	end

	def generate_moves
		modifiers = [[0, 1],
					 [1, 1],
					 [1, 0],
					 [1, -1],
					 [0, -1],
					 [-1, -1],
					 [-1, 0],
					 [-1, 1]]

		apply_boundaries(modifiers)

		#modifiers.each do |modifier|
			#newX = @position[0] + modifier[1][0]
			#newY = @position[1] + modifier[1][1]
			#if !in_check?(board, [newX, newY])
			#	@moves << [newX, newY]
			#end
		#end

		if @moves.empty?
			@check_mate = true
		end
	end

	def remove_move(coordinates)
		@moves.delete([coordinates[0], coordinates[1]])
	end

	def in_check?(board, coordinates = @position)
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

		knight_moves = {:a => [1, 2],
						:b => [2, 1],
						:c => [2, -1],
						:d => [1, -2],
						:f => [-1, -2],
						:g => [-2, -1],
						:h => [-2, 1],
						:i => [-1, 2]}

		bishop_moves = apply_boundaries(coordinates, bishop_moves)

		queen_moves.each do |move|
			move[1].each do |distance|
				location = board.nodes[coordinates[0] + distance[0]][coordinates[1] + distance[1]][0]
				if (!location.nil?) && (location.color != @color)
					if location.is_a?(Bishop) || location.is_a?(Queen) || location.is_a?(Rook)
						return true
					end

					if ((distance[0].abs == 1) || (distance[1].abs == 1)) && location.is_a?(King)
						return true
					end

					if location.is_a?(Pawn) && (distance[0].abs == 1)
						if (@color == :black) && (distance[1] == -1)
							return true
						end

						if (@color == :white) && (distance[1] == 1)
							return true
						end
					end
				end
			end
		end

		knight_moves = apply_boundaries(coordinates, knight_moves)

		knight_moves.each do |move|
			location = board.nodes[coordinates[0] + move[1][0]][coordinates[1] + move[1][1]][0]
			if (!location.nil?) && (location.color != @color) && location.is_a?(Knight)
				return true
			end
		end
	end
end