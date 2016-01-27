require 'colorize'
require_relative 'king'
require_relative 'queen'

class Board
	attr_accessor :nodes

	def initialize
		@nodes = []
		8.times { @nodes << [] }
		@nodes.each do |node|
			8.times { node << [] }
		end

		#king: 4,0/7
		@nodes[4][0] << King.new(:white, [4, 0], "\u2654")
		@nodes[4][7] << King.new(:black, [4, 7], "\u265A")

		#queen: 3,0/7
		@nodes[3][0] << Queen.new(:white, [3, 0], "\u2655")
		@nodes[3][7] << Queen.new(:black, [3, 7], "\u265B")
	end

	def move(piece, destination)
		pass_others(piece)
		piece.generate_moves
		if piece.legal_move?(destination)
			@nodes[destination[0]][destination[1]] << @nodes[piece.position[0]][piece.position[1]].pop
			piece.position = destination
			return true
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
						piece.allies << rows[0].position
					else
						piece.enemies << rows[0].position
					end
				end
			end
		end
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
end