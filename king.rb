require 'piece'

class King < Piece
	def initialize(color)
		super(color)
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

		if @position[0] == 0
			modifiers.delete(:nw)
			modifiers.delete(:w)
			modifiers.delete(:sw)
		end

		if @position[0] == 7
			modifiers.delete(:ne)
			modifiers.delete(:e)
			modifiers.delete(:se)
		end

		if @position[1] == 0
			modifiers.delete(:sw)
			modifiers.delete(:s)
			modifiers.delete(:se)
		end

		if @position[1] == 7
			modifiers.delete(:nw)
			modifiers.delete(:n)
			modifiers.delete(:ne)
		end

		modifiers.each do |modifier|
			@moves << [(@position[0].ord + modifier[1][0]).chr, @position[1] + modifier[1][1]]
		end
	end
end

#add @position to Piece
#initialize moves to [] in Piece