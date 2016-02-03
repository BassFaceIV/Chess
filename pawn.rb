require_relative 'piece'

class Pawn < Piece
	attr_accessor :moved

	def initialize(label, color, position, symbol)
		super(label, color, position, symbol)
		@moved = false
	end

	def generate_moves
		pawn_moves = @color == :white ? [[0, 1]] : [[0, -1]]
		pawn_moves << [pawn_moves[0][0], pawn_moves[0][1] * 2] if @moved == false
		@moves = []

		apply_attacks(pawn_moves)
		apply_obstacles(pawn_moves)
		apply_boundaries(pawn_moves)

		pawn_moves.each do |distance|
			@moves << [@position[0] + distance[0], @position[1] + distance[1]]
		end

		#puts "#{@position}: #{@moves}"
	end

	def apply_obstacles(modifiers)
		troops = @enemies + @allies

		if @color == :white
			modifiers.delete([0, 1]) if troops.any? { |troop| troop[0] == [@position[0], @position[1] + 1]}
			modifiers.delete([0, 2]) if troops.any? { |troop| troop[0] == [@position[0], @position[1] + 1]}
			modifiers.delete([0, 2]) if troops.any? { |troop| troop[0] == [@position[0], @position[1] + 2]}
		else
			modifiers.delete([0, -1]) if troops.any? { |troop| troop[0] == [@position[0], @position[1] - 1]}
			modifiers.delete([0, -2]) if troops.any? { |troop| troop[0] == [@position[0], @position[1] - 1]}
			modifiers.delete([0, -2]) if troops.any? { |troop| troop[0] == [@position[0], @position[1] - 2]}
		end
	end

	def apply_attacks(modifiers)
		if @color == :white
			#modifiers.delete([0, 1]) if @enemies.any? { |enemy| enemy[0] == [@position[0], @position[1] + 1]}
			modifiers << [1, 1] if @enemies.any? { |enemy| enemy[0] == [@position[0] + 1, @position[1] + 1]}
			modifiers << [-1, 1] if @enemies.any? { |enemy| enemy[0] == [@position[0] - 1, @position[1] + 1]}
		else
			#modifiers.delete([0, -1]) if @enemies.any? { |enemy| enemy[0] == [@position[0], @position[1] - 1]}
			modifiers << [1, -1] if @enemies.any? { |enemy| enemy[0] == [@position[0] + 1, @position[1] - 1]}
			modifiers << [-1, -1] if @enemies.any? { |enemy| enemy[0] == [@position[0] - 1, @position[1] - 1]}
		end
	end
end