require_relative 'scaffolding.rb'

# Used to display info for hangman
class DisplayStatus
  def initialize(hangman)
    @scaffolding = Scaffolding.new
    @hangman = hangman
    @scaffold = ['-----------------------']
  end

  def display_information
    system 'clear'
    puts 'Welcome to Hangman!!'
    puts "Valid commands are 'quit', 'save', and 'load.'"
    puts

    display_word
    display_guesses
    incorrect_guesses
    draw_hangman
  end

  def incorrect_guesses
    # puts "Number of incorrect guesses: #{@hangman.num_incorrect_guesses}"
    puts "Incorrect guesses left: #{@hangman.incorrect_guesses_left}"
    puts
  end

  def display_word
    puts
    puts @hangman.display_word.join('  ')
  end

  def display_guesses
    puts 'Previous guesses: '
    puts @hangman.guesses.join(', ')
    # @hangman.guesses.each { |guess| print " #{guess}" }
    # puts
  end

  def draw_hangman
    @scaffold.each { |scaffold| print scaffold }
  end

  def update_hangman
    @scaffold << SCAFFOLDING[@hangman.num_incorrect_guesses]
  end
end
