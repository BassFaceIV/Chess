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
		@nodes[4][0] << King.new(:white, "\u2654")
		@nodes[4][7] << King.new(:black, "\u265A")

		#queen: 3,0/7
		@nodes[3][0] << Queen.new(:white, "\u2655")
		@nodes[3][7] << Queen.new(:black, "\u265B")
	end

	def move(piece, destination)
		if piece.legal_move?(destination)
			@nodes[destination[0]][destination[1]][0] << @nodes[piece.position[0]][piece.position[1]].pop
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