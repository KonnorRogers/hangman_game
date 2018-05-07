require 'yaml'

# used to save and load hangman games
class FileManaging
  def save_game(hangman)
    Dir.mkdir('saved_game') unless Dir.exist?('saved_game')

    yaml = YAML.dump(hangman)
    File.open('saved_game/save_file.yaml', 'w') { |file| file.write(yaml) }
  end

  def load_game
    YAML.load_file('saved_game/save_file.yaml')
  end
end
