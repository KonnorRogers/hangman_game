# 7 guesses
#  |
#  0
# /|\
# / \

# hangman game
class Hangman
  attr_accessor :incorrect_guesses, :possible_words
  def intialize
    @incorrect_guesses = 0
    @possible_words = load_words
  end

  def load_words
    possible_words = []
    all_words = File.readlines('5desk.txt') { |word| word }
    all_words.select do |word|
      next if word.length > 12 || word.length < 5
      possible_words << word
    end

    possible_words
  end
end

p Hangman.new.load_words
