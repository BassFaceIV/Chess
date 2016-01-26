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
		modifiers = {:n => [0, 1],
					 :ne => [1, 1],
					 :e => [1, 0],
					 :se => [1, -1],
					 :s => [0, -1],
					 :sw => [-1, -1],
					 :w => [-1, 0],
					 :nw => [-1, 1]}

		modifiers = apply_boundaries(@position, modifiers)

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

	def apply_boundariesBACKUP(coordinates, modifiers)
		if coordinates[0] == 0
			modifiers.delete(:nw)
			modifiers.delete(:w)
			modifiers.delete(:sw)
			modifiers.delete(:f)
			modifiers.delete(:g)
			modifiers.delete(:h)
			modifiers.delete(:i)
		end

		if coordinates[0] == 1
			modifiers.delete(:g)
			modifiers.delete(:h)
		end

		if coordinates[0] == 6
			modifiers.delete(:a)
			modifiers.delete(:d)
		end

		if coordinates[0] == 7
			modifiers.delete(:ne)
			modifiers.delete(:e)
			modifiers.delete(:se)
			modifiers.delete(:a)
			modifiers.delete(:b)
			modifiers.delete(:c)
			modifiers.delete(:d)
		end

		if coordinates[1] == 0
			modifiers.delete(:sw)
			modifiers.delete(:s)
			modifiers.delete(:se)
			modifiers.delete(:c)
			modifiers.delete(:d)
			modifiers.delete(:f)
			modifiers.delete(:g)
		end

		if coordinates[1] == 1
			modifiers.delete(:d)
			modifiers.delete(:f)
		end

		if coordinates[1] == 6
			modifiers.delete(:a)
			modifiers.delete(:i)
		end

		if coordinates[1] == 7
			modifiers.delete(:nw)
			modifiers.delete(:n)
			modifiers.delete(:ne)
			modifiers.delete(:a)
			modifiers.delete(:b)
			modifiers.delete(:h)
			modifiers.delete(:i)
		end

		return modifiers
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