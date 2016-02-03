require_relative 'piece'

class King < Piece
	attr_accessor :castled
	attr_accessor :check
	attr_accessor :check_mate

	def initialize(label, color, position, symbol)
		super(label, color, position, symbol)
		@castled = false
		@check = false
		@check_mate = false
	end

	def generate_moves
		@moves = []

		modifiers = [[0, 1],
					 [1, 1],
					 [1, 0],
					 [1, -1],
					 [0, -1],
					 [-1, -1],
					 [-1, 0],
					 [-1, 1]]

		apply_boundaries(modifiers)

		modifiers.each do |distance|
			@moves << [@position[0] + distance[0], @position[1] + distance[1]]
		end
	end

	def in_check?
		checks = []
		knight_moves = [[1, 2], [2, 1], [2, -1], [1, -2], [-1, -2], [-2, -1], [-2, 1], [-1, 2]]
		troops = @enemies + @allies

		enemy_moves = {[0, 1] => [:queen, :rook],
					   [1, 0] => [:queen, :rook],
					   [0, -1] => [:queen, :rook],
					   [-1, 0] => [:queen, :rook],
					   [1, 1] => [:queen, :bishop],
					   [1, -1] => [:queen, :bishop],
					   [-1, -1] => [:queen, :bishop],
					   [-1, 1] => [:queen, :bishop]}

		@enemies.each do |enemy|
			#special check for knights
			if enemy[1] == :knight
				knight_moves.each do |move|
					checks << enemy if enemy[0] == [@position[0] + move[0], @position[1] + move[1]]
				end
			elsif enemy[1] == :pawn
				left = [@position[0] - 1, @position[1] + ((@color == :white) ? 1 : -1)]
				right = [@position[0] + 1, @position[1] + ((@color == :white) ? 1 : -1)]
				checks << enemy if (enemy[0] == left) || (enemy[0] == right)
			else
				#check dir of magn of enemy_pos - king_pos ([0, x], [x, 0], [0, -x], [-x, 0]) => (Q, R)...
				distance = [enemy[0][0] - @position[0], enemy[0][1] - @position[1]]

				if (distance[0] == 0) || (distance[1] == 0) || (distance[0].abs == distance[1].abs)
					dir = [distance[0] <=> 0, distance[1] <=> 0]
					#check dir matches proper piece
					if enemy_moves[dir].any? { |piece| piece == enemy[1] }
						#check each node between king and enemy
						if distance[0] == 0
							path = Array.new(distance[1].abs - 1) { |i| [@position[0], @position[1] + (dir[1] * (i + 1))] }
						elsif distance[1] == 0
							path = Array.new(distance[0].abs - 1) { |i| [@position[0] + (dir[0] * (i + 1)), @position[1]] }
						else
							path = Array.new(distance[0].abs - 1) { |i| [@position[0] + (dir[0] * (i + 1)), @position[1] + (dir[1] * (i + 1))] }
						end

						checks << enemy if !troops.any? { |troop| path.include? troop[0] }
					end
				end
			end
		end

		@check = checks.empty? ? false : true

		return @check
	end

	def apply_knight_friendlies(modifiers)
		modifiers.delete_if do |mod|
			@allies.any? do |ally|
				ally[0] == [@position[0] + mod[0], @position[1] + mod[1]]
			end
		end
	end
end