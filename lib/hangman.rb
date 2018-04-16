# 7 guesses
#  |
#  0
# /|\
# / \

# hangman game
class Hangman
  attr_reader :num_incorrect_guesses, :secret_word, :guesses

  MAX_INCORRECT_GUESSES = 7
  SAFE_WORDS = %w[quit save].freeze

  def initialize
    @guesses = []
    @num_incorrect_guesses = 0
    @secret_word = select_random_word
  end

  def play_game
    puts 'Welcome to Hangman!!'
    loop do
      input = user_input
      break if input == 'quit'
      @guesses << input
      p @guesses
    end

    puts 'Goodbye!'
  end

  private

  # loads words into an array, selects only words of a certain length
  # then selects and then lowercases the word
  def select_random_word
    words = File.readlines('5desk.txt', chomp: true) { |word| word }
    words.select! { |word| word.length > 5 && word.length < 12 }
    words.sample.downcase
  end

  def display_guesses
    @guesses.each { |guess| print "#{guess} " }
  end

  def check_input(input)
    return true if SAFE_WORDS.include?(input)
    return false if input.length > 1 || input.empty?
    return false if input.match?(/[^a-z]/)

    true
  end

  def user_input
    puts 'Enter your guess:'
    input = ''

    loop do
      input = gets.chomp.downcase
      break if check_input(input)
      puts 'Improper input, please enter a letter.'
    end

    input
  end
end

puts Hangman.new.play_game
