require 'colorize'
require_relative 'king'
require_relative 'queen'
require_relative 'rook'
require_relative 'bishop'
require_relative 'knight'
require_relative 'pawn'

class Board
	attr_accessor :nodes
	attr_accessor :kings

	def initialize
		@nodes = []
		8.times { @nodes << [] }
		@nodes.each do |node|
			8.times { node << [] }
		end

		#king: 4,0/7
		@nodes[4][0] << King.new(:king, :white, [4, 0], "\u2654")
		@nodes[4][7] << King.new(:king, :black, [4, 7], "\u265A")

		#queen: 3,0/7
		@nodes[3][0] << Queen.new(:queen, :white, [3, 0], "\u2655")
		@nodes[3][7] << Queen.new(:queen, :black, [3, 7], "\u265B")

		#rook: 0/7, 0/7
		@nodes[0][0] << Rook.new(:rook, :white, [0, 0], "\u2656")
		@nodes[7][0] << Rook.new(:rook, :white, [7, 0], "\u2656")
		@nodes[0][7] << Rook.new(:rook, :black, [0, 7], "\u265C")
		@nodes[7][7] << Rook.new(:rook, :black, [7, 7], "\u265C")

		#bishop: 2/5, 0/7
		@nodes[2][0] << Bishop.new(:bishop, :white, [2, 0], "\u2657")
		@nodes[5][0] << Bishop.new(:bishop, :white, [5, 0], "\u2657")
		@nodes[2][7] << Bishop.new(:bishop, :black, [2, 7], "\u265D")
		@nodes[1][3] << Bishop.new(:bishop, :black, [1, 3], "\u265D") #5,7

		#knight: 1/6, 0/7
		@nodes[1][0] << Knight.new(:knight, :white, [1, 0], "\u2658")
		@nodes[6][0] << Knight.new(:knight, :white, [6, 0], "\u2658")
		@nodes[1][7] << Knight.new(:knight, :black, [1, 7], "\u265E")
		@nodes[6][7] << Knight.new(:knight, :black, [6, 7], "\u265E")

		#pawn: 0-7, 1/6
		@nodes[0][1] << Pawn.new(:pawn, :white, [0, 1], "\u2659")
		@nodes[1][1] << Pawn.new(:pawn, :white, [1, 1], "\u2659")
		@nodes[2][1] << Pawn.new(:pawn, :white, [2, 1], "\u2659")
		@nodes[3][1] << Pawn.new(:pawn, :white, [3, 1], "\u2659")
		@nodes[4][1] << Pawn.new(:pawn, :white, [4, 1], "\u2659")
		@nodes[5][1] << Pawn.new(:pawn, :white, [5, 1], "\u2659")
		@nodes[6][1] << Pawn.new(:pawn, :white, [6, 1], "\u2659")
		@nodes[7][1] << Pawn.new(:pawn, :white, [7, 1], "\u2659")
		@nodes[0][6] << Pawn.new(:pawn, :black, [0, 6], "\u265F")
		@nodes[1][6] << Pawn.new(:pawn, :black, [1, 6], "\u265F")
		@nodes[2][6] << Pawn.new(:pawn, :black, [2, 6], "\u265F")
		@nodes[3][6] << Pawn.new(:pawn, :black, [3, 6], "\u265F")
		@nodes[4][6] << Pawn.new(:pawn, :black, [4, 6], "\u265F")
		@nodes[5][6] << Pawn.new(:pawn, :black, [5, 6], "\u265F")
		@nodes[6][6] << Pawn.new(:pawn, :black, [6, 6], "\u265F")
		@nodes[7][6] << Pawn.new(:pawn, :black, [7, 6], "\u265F")

		@kings = {:white => @nodes[4][0][0], :black => @nodes[4][7][0]}
	end

	def update
		@nodes.each do |columns|
			columns.each do |rows|
				piece = rows[0]

				if !piece.nil?
					#puts "#{piece.label}: #{piece.position}"
					pass_others(piece)
					piece.generate_moves
				end
			end
		end

		@kings.each do |color, king|
			king.check = king.in_check?
			puts "#{color} king check = #{king.check}"
		end
	end

	def move(player, origin, destination)
		piece = @nodes[origin[0]][origin[1]][0]
		if !piece.nil?
			if ((player == 1) && (piece.color == :white)) || ((player == 2) && (piece.color == :black))

				if piece.legal_move?(destination)

					tempNode = @nodes[destination[0]][destination[1]][0]
					prevPosition = piece.position

					@nodes[destination[0]][destination[1]] << @nodes[piece.position[0]][piece.position[1]].pop
					piece.position = destination

					attacked = attacked?(destination)

					update

					#puts "Player #{player}: Check = #{check?(player, piece)}"

					if check?(player, piece)
						@nodes[prevPosition[0]][prevPosition[1]] << @nodes[destination[0]][destination[1]].pop
						piece.position = prevPosition

						if attacked
							@nodes[destination[0]][destination[1]] << tempNode
						end
					else
						if piece.is_a?(Pawn)
							piece.moved = true
						end

						return true
					end
				end
			else
				puts "That is not your piece"
			end
		else
			puts "There is no piece at that location"
		end

		return false
	end

	def pass_others(piece)
		piece.allies = []
		piece.enemies = []
		@nodes.each do |columns|
			columns.each do |rows|
				if !rows.empty?
					if rows[0].color == piece.color
						piece.allies << [rows[0].position, rows[0].label]
					else
						piece.enemies << [rows[0].position, rows[0].label]
					end
				end
			end
		end
	end

	def attacked?(location)
		piece = @nodes[location[0]][location[1]]
		if piece.size > 1
			piece.delete_at(0)
			return true
		end
		return false
	end

	def display
		bg_flag = false

		8.times do |x|
			bg_flag = bg_flag ? false : true

			print "#{7 - x}"
			@nodes.each do |node|
				node = node[7 - x]
				if node.empty?
					print "   ".colorize(:background => bg_flag ? :white : :black)
				else
					print " #{node[0].display} ".colorize(:background => bg_flag ? :white : :black)
				end

				bg_flag = bg_flag ? false : true
			end
			print "\n"
		end

		puts "  a  b  c  d  e  f  g  h"
	end

	def check?(player, piece)
		color = player == 1 ? :white : :black
		#puts "Checking checkness:"
		#puts "    #{color}, #{@kings[color].check} && #{@kings[color].id} != #{piece.id}"
		if @kings[color].check
			puts "Your king is in check"
			return true
		end
		return false
	end

	def check_mate?
		if @kings[:white].check_mate
			return :white
		elsif @kings[:black].check_mate
			return :black
		else
			return false
		end
	end
end