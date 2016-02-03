class Piece
	@@pieces = 0
	attr_accessor :id
	attr_accessor :color
	attr_accessor :moves
	attr_accessor :position
	attr_accessor :display
	attr_accessor :allies
	attr_accessor :enemies
	attr_accessor :label

	def initialize(label, color, position, symbol)
		@id = @@pieces
		@label = label
		@color = color
		@position = position
		@display = symbol
		@moves = []
		@allies = []
		@enemies = []

		#generate_moves

		@@pieces += 1
	end

	def generate_moves
		#generates immediate possible moves
		raise NotImplementedError.new "generate_moves"
	end

	def apply_boundaries(modifiers)
		modifiers.delete_if { |mod| (@position[0] + mod[0] < 0) || (@position[0] + mod[0] > 7) || (@position[1] + mod[1] < 0) || (@position[1] + mod[1] > 7) }
		apply_friendlies(modifiers)
	end

	def apply_attacks(modifiers)
		modifiers.delete_if do |mod|
			mod_dir = [mod[0] <=> 0, mod[1] <=> 0]
			mod_mag = Math.sqrt(mod[0] ** 2 + mod[1] ** 2)

			#delete if it has the same direction, but a greater magnetude than any enemy
			@enemies.any? do |enemy|
				enemy_dif0 = enemy[0][0] - @position[0]
				enemy_dif1 = enemy[0][1] - @position[1]
				enemy_dir = [enemy_dif0 <=> 0, enemy_dif1 <=> 0]
				enemy_mag = Math.sqrt(enemy_dif0 ** 2 + enemy_dif1 ** 2)
				(enemy_dir == mod_dir) && (mod_mag.floor > enemy_mag.floor)
			end
		end
	end

	def apply_friendlies(modifiers)
		modifiers.delete_if do |mod|
			mod_dir = [mod[0] <=> 0, mod[1] <=> 0]
			mod_mag = Math.sqrt(mod[0] ** 2 + mod[1] ** 2)

			#delete if it has the same direction and a greater or equal magnetude than any ally
			@allies.any? do |allies|
				allies_dif0 = allies[0][0] - @position[0]
				allies_dif1 = allies[0][1] - @position[1]
				allies_dir = [allies_dif0 <=> 0, allies_dif1 <=> 0]
				allies_mag = Math.sqrt(allies_dif0 ** 2 + allies_dif1 ** 2)
				(allies_dir == mod_dir) && (mod_mag >= allies_mag)
			end
		end
	end

	def legal_move?(destination)
		#checks to see if desired move is in possible moves
		@moves.each do |coordinates|
			if (coordinates === destination)
				return true
			end
		end

		puts "Illegal move"
		return false
	end
end