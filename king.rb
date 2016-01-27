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

		if @moves.empty?
			@check_mate = true
		end
	end

	def in_check?
		basic_moves = []
		knight_moves = [[1, 2], [2, 1], [2, -1], [1, -2], [-1, -2], [-2, -1], [-2, 1], [-1, 2]]
		move_range =* (1..7)

		move_range.each do |x|
			basic_moves << [0, x]
			basic_moves << [x, x]
			basic_moves << [x, 0]
			basic_moves << [x, -x]
			basic_moves << [0, -x]
			basic_moves << [-x, -x]
			basic_moves << [-x, 0]
			basic_moves << [-x, x]
		end

		apply_boundaries(basic_moves)
		basic_moves += knight_moves
		apply_knight_friendlies(basic_moves)
		basic_moves.delete_if { |mod| (@position[0] + mod[0] < 0) || (@position[0] + mod[0] > 7) || (@position[1] + mod[1] < 0) || (@position[1] + mod[1] > 7) }

		return basic_moves.any? do |move|
			@enemies.any? do |enemy|
				enemy == [@position[0] + move[0], @position[1] + move[1]]
			end
		end
	end

	def apply_knight_friendlies(modifiers)
		modifiers.delete_if do |mod|
			@allies.any? do |ally|
				ally == [@position[0] + mod[0], @position[1] + mod[1]]
			end
		end
	end
end