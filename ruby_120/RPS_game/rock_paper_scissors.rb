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
    @human    = Human.new
    @computer = Computer.new
  end

  def play
    display_welcome_message
    loop do
      human.choose
      computer.choose
      @won_or_lost = human.compare(computer)
      display_choices(human, computer)
      display_winner(@won_or_lost)
      break unless play_again?
    end
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
    when 'won'  then prompt 'You won!'
    when 'lost' then prompt 'You lost!'
    when 'tie'  then prompt 'It\'s a tie!' end
    puts ''
  end

  def play_again?
    loop do
      prompt 'Play again?'
      answer = gets.chomp.downcase
      return true  if ['yes', 'y'].include?(answer)
      return false if ['no', 'n'].include?(answer)
      clear_screen()
      puts 'Oops. Please enter Yes or No.'
    end
  end

  def display_goodbye_message
    clear_screen()
    puts 'Thank you for playing. Good bye!'
  end
end

class Move
  WIN_MOVES = [['rock', 'scissors'], ['paper', 'rock'], ['scissors', 'paper']]
end

class Player
  VALID_CHOICE = ['rock', 'paper', 'scissors']
  VALID_SHORTCUT = VALID_CHOICE.map(&:chr).zip(VALID_CHOICE).to_h
  WIN_MOVES = [['rock', 'scissors'], ['paper', 'rock'], ['scissors', 'paper']]

  def move
    @move.clone
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
    moves = [move1, move2]
    if WIN_MOVES.include? moves then true
    else false end
  end
end

class Human < Player
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
end

class Computer < Player
  def choose
    self.move = VALID_CHOICE.sample
  end
end

RPSGame.new.play