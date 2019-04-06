# frozen_string_literal: true

require_relative 'dictionary'

class Board
  def cardinalities
    [
      [-1, -1],
      [-1, 0],
      [-1, 1],
      [0, -1],
      [0, 1],
      [1, -1],
      [1, 0],
      [1, 1]
    ]
  end

  def initialize(string, dictionary)
    @board = string.lines.map(&:chomp).map(&:chars)
    throw 'Board must all be the same length' unless @board.map(&:length).uniq.length == 1
    @size_x = @board.length
    @size_y = @board[0].length

    @dictionary = dictionary
  end

  def print
    @board.each { |l| puts l.join ' ' }
  end

  def within_bounds(x, y)
    x >= 0 && x < @size_x &&
      y >= 0 && y < @size_y
  end

  def letter_at(x, y)
    @board[x][y]
  end

  def generate_words(start_x, start_y)
    _generate_words(start_x, start_y, '', [], [])
  end

  def _generate_words(x, y, prefix, words, visited)
    prefix = "#{prefix}#{letter_at(x, y)}"
    if @dictionary.is_word(prefix)
      # puts "#{prefix} was a word"
      words << prefix
    end
    visited += [[x, y]]
    # puts "generating words for  (#{x}, #{y}) - prefix #{prefix}"
    # puts "Visited: #{visited.inspect}"
    cardinalities.each do |card|
      new_x = x + card[0]
      new_y = y + card[1]
      if within_bounds(new_x, new_y) && !visited.include?([new_x, new_y]) &&
         @dictionary.is_prefix_of_word(prefix)
        _generate_words(new_x, new_y, prefix, words, visited)
      end
    end
    words
  end

  def generate_all_words
    (0..@size_x - 1).to_a.product((0..@size_y - 1).to_a).map do |(x, y)|
      # puts "Generating all words for coordinates #{x}, #{y}"
      generate_words(x, y)
    end
                    .flatten
                    .sort
                    .uniq
  end
 end
