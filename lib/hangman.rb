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
    @display_word = Array.new(@secret_word.length, '_')
  end

  def play_game
    loop do
      display_information

      input = user_input
      break if input == 'quit'
      @guesses << input
      check_guess(input)
    end

    puts 'Goodbye!'
  end

  def display_information
    system 'clear'
    puts 'Welcome to Hangman!!'
    puts 'Valid commands are quit and save.'
    p display_word
    puts 'Previous guesses:'
    p @guesses
  end

  def display_word
    @display_word.join(' ')
  end

  private

  def player_won
    if @display_word.include?('_')
      puts 'You have won! Congratulations!'
      true
    end
  end

  def game_over
    return true if player_won
    return true if @num_incorrect_guesses > MAX_INCORRECT_GUESSES
  end

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
    return false if @guesses.include?(input)

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

  def check_guess(guess)
    # return false unless @secret_word.include?(guess)
    unless @secret_word.include?(guess)
      @num_incorrect_guesses += 1
      return false
    end

    letter_indexes = []
    secret_word = @secret_word.split('')
    secret_word.each_with_index do |item, index|
      next unless item == guess
      letter_indexes << index
    end

    letter_indexes.each { |index| @display_word[index] = guess }
  end
end

puts Hangman.new.play_game
