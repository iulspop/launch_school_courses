=begin
Rock paper scissors I a game where two players select an piece, if their piece wins they won the round. first to win three rounds wins the game.

nouns: player, move, rule
verbs: choose, compare
=end

require "io/console"

def prompt(message, *extra)
  puts "==> #{message}", *extra
end

def clear_screen
  system('clear') || system('clr')
end

class RPSGame
  def initialize
    @human    = Player.new
    @computer = Player.new
  end

  def play
    display_welcome_message
    human.choose
    computer.random_choice
    @won_or_lost = human.compare(computer)
    display_choices(human, computer)
    display_winner(@won_or_lost)
    display_goodbye_message
  end

  private

  attr_reader :human, :computer

  def display_welcome_message
    clear_screen()
    puts 'Let\'s Play Rock Paper Scissors!', ''
    prompt 'Press any key to start game...'
    STDIN.getch
  end

  def display_choices(human, computer)
    clear_screen()
    puts "You chose:      #{human.move.capitalize}"
    puts "Computer chose: #{computer.move.capitalize}", ''
  end

  def display_winner(won_or_lost)
    case won_or_lost
    when 'won'
      prompt 'You won!'
    when 'lost'
      prompt 'You lost!'
    when 'tie'
      prompt 'It\'s a tie!'
    end
    puts ''
    prompt 'Press any key to end game...'
    STDIN.getch
  end

  def display_goodbye_message
    clear_screen()
    puts 'Thank you for playing. Good bye!'
  end
end

class Player
  VALID_CHOICE = ['rock', 'paper', 'scissors']
  VALID_SHORTCUT = VALID_CHOICE.map(&:chr).zip(VALID_CHOICE).to_h

  def move
    @move.clone
  end

  def choose
    clear_screen()
    choice = ''
    loop do
      prompt "Choose one: #{VALID_CHOICE.join(', ')}"
      print_shortcuts
      choice = gets.chomp
  
      break if VALID_CHOICE.include?(choice)
      break choice = VALID_SHORTCUT[choice] if VALID_SHORTCUT.include?(choice)
      clear_screen()
      puts 'Oops. That\'s not a valid choice.'
    end
    self.move = choice
  end

  def random_choice
    self.move = VALID_CHOICE.sample
  end

  def compare(other_player)
    return 'won'  if win?(self.move, other_player.move)
    return 'lost' if win?(other_player.move, self.move)
    'tie'
  end

  private

  attr_writer :move

  def print_shortcuts
    prompt 'Shortcuts:'
    VALID_SHORTCUT.each { |shortcut, choice| puts "   #{shortcut} for #{choice}" }
  end

  def win?(move1, move2)
    case move1
    when 'rock'
      true if move2 == 'scissors'
    when 'paper'
      true if move2 == 'rock'
    when 'scissors'
      true if move2 == 'paper'
    else
      false
    end
  end
end

RPSGame.new.play