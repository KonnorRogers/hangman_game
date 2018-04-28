require_relative 'display_status.rb'
require_relative 'file_managing.rb'

# Hangman game designed for TheOdinProject
class Hangman
  attr_reader :num_incorrect_guesses, :secret_word, :guesses, :display_word

  MAX_INCORRECT_GUESSES = 7
  SAFE_WORDS = %w[quit save load].freeze

  def initialize
    @file_management = FileManaging.new
    @display_status = DisplayStatus.new(self)
    @guesses = []
    @num_incorrect_guesses = 0
    @secret_word = select_random_word
    @display_word = reset_display_word
  end

  def play_game
    loop do
      break if game_over
      # instance_variables_hash
      @display_status.display_information

      input = user_input
      return if input == 'quit'

      @file_management.load_game.play_game if input == 'load'

      if input == 'save'
        @file_management.save_game(self)
        return
      end
      @guesses << input
      check_guess(input)
    end

    restart_game
  end

  def incorrect_guesses_left
    MAX_INCORRECT_GUESSES - @num_incorrect_guesses
  end

  private

  def restart_game
    puts "\nWould you like to play again? (Y/N)"

    loop do
      input = gets.chomp.downcase
      return if input == 'n'
      break if input == 'y'

      puts 'Improper input, please enter Y to restart or N to end the program!'
    end

    Hangman.new.play_game
  end

  def reset_display_word
    @display_word = Array.new(@secret_word.length, '_')
  end

  def player_lost
    return false if incorrect_guesses_left > 0

    system 'clear'

    puts @display_status.draw_hangman

    puts 'You have guessed incorrectly too many times. You have lost.'
    puts "\nThe word was '#{@secret_word}'"
    true
  end

  def player_won
    return false if @display_word.include?('_')

    system 'clear'
    puts 'CONGRATULATIONS YOU HAVE WON!'
    puts "The word was #{@secret_word}"
    true
  end

  def game_over
    return true if player_won
    return true if player_lost
  end

  # loads words into an array, selects only words of a certain length
  # then selects and then lowercases the word
  def select_random_word
    words = File.readlines('5desk.txt', chomp: true) { |word| word }
    words.select! { |word| word.length > 5 && word.length < 12 }
    words.sample.downcase
  end

  def check_input(input)
    return true if SAFE_WORDS.include?(input)
    return false if input.length > 1 || input.empty?
    return false if input.match?(/[^a-z]/)
    return false if @guesses.include?(input)

    true
  end

  def user_input
    puts "\nEnter your guess:"
    input = ''

    loop do
      input = gets.chomp.downcase
      break if check_input(input)
      @display_status.display_information

      incorrect_input(input)
    end

    input
  end

  def incorrect_input(input)
    if @guesses.include?(input)
      puts "'#{input}' was already guessed. Please enter a different letter."
    else
      puts 'Improper input, please enter a letter.'
    end
  end

  def check_guess(guess)
    unless @secret_word.include?(guess)
      @num_incorrect_guesses += 1
      return false
    end

    secret_word = @secret_word.split('')

    secret_word.each_with_index do |item, index|
      next unless item == guess
      @display_word[index] = guess
    end
  end
end

Hangman.new.play_game
