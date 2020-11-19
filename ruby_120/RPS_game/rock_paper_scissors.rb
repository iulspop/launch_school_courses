require "io/console"

def prompt(message, *extra)
  puts "==> #{message}", *extra
end

def clear_screen
  system('clear') || system('clr')
end

VALID_CHOICE = ['rock', 'paper', 'scissors', 'lizard', 'Spock']

class RPSGame
  SCORE_TO_WIN = 5

  def initialize
    @human    = Human.new
    @computer = Computer.new
  end

  def play
    display_welcome_message
    loop do
      human.reset_score
      computer.reset_score
      rounds_loop
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

  def rounds_loop
    loop do
      play_round
      break if [human.score, computer.score].include? SCORE_TO_WIN
      any_key_to_continue
    end
  end

  def play_round
    human.choose
    computer.choose
    won_or_lost = human.compare(computer)
    update_score(won_or_lost, human, computer)
    display_round_info
  end

  def update_score(won_or_lost, human, computer)
    human.increment_score    if won_or_lost == 'won'
    computer.increment_score if won_or_lost == 'lost'
  end

  def display_round_info
    display_score(human, computer)
    display_result(won_or_lost, human.move, computer.move)
    display_choices(human, computer)
  end

  def display_score(human, computer)
    clear_screen()
    puts '==== SCORE ===='
    puts "Player: #{human.score}   " \
    "Computer: #{computer.score}", ''
  end

  def display_choices(human, computer)
    puts "You chose:      #{human.move}"
    puts "Computer chose: #{computer.move}", ''
  end

  def display_result(won_or_lost, player_move, computer_move)
    case won_or_lost
    when 'won'
      prompt(player_move.attack_description(computer_move))
      prompt 'You won this round.', ''
    when 'lost'
      prompt(computer_move.attack_description(player_move))
      prompt 'You lost this round.', ''
    when 'tie'
      prompt 'This round is a tie.', ''
    end
  end

  def any_key_to_continue
    prompt 'Press any key to start next round...'
    STDIN.getch
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
  WIN_MOVES = VALID_CHOICE.permutation(2).to_a.select do |(first, second)|
    case first
    when 'rock'     then ['scissors', 'lizard'].include?(second)
    when 'paper'    then ['rock', 'Spock'].include?(second)
    when 'scissors' then ['paper', 'lizard'].include?(second)
    when 'lizard'   then ['Spock', 'paper'].include?(second)
    when 'Spock'    then ['scissors', 'rock'].include?(second) end
  end

  VERBS = {
    "scissors" => {
      "paper" => "cuts",
      "lizard" => "decapitates"
    },
    "paper" => {
      "rock" => "covers",
      "Spock" => "disproves"
    },
    "rock" => {
      "scissors" => "crushes",
      "lizard" => "crushes"
    },
    "lizard" => {
      "paper" => "eats",
      "Spock" => "poisons"
    },
    "Spock" => {
      "rock" => "vaporizes",
      "scissors" => "crushes"
    }
  }

  def initialize(value)
    @value = value
  end

  def >(other_move)
    win?(self, other_move)
  end

  def <(other_move)
    win?(other_move, self)
  end

  def to_s
    @value.capitalize
  end

  def attack_description(other_move)
    "#{self} #{VERBS[value][other_move.value]} #{other_move}!"
  end

  protected

  attr_reader :value

  private

  def win?(move1, move2)
    moves = [move1.value, move2.value]
    if WIN_MOVES.include? moves then true
    else false end
  end
end

class Player
  attr_reader :score

  def initialize
    @score = 0
  end

  def move
    @move.clone
  end

  def compare(other_player)
    return 'won'  if move > other_player.move
    return 'lost' if move < other_player.move
    'tie'
  end

  def increment_score
    self.score += 1
  end

  def reset_score
    self.score = 0
  end

  private

  attr_writer :move, :score
end

class Human < Player
  VALID_SHORTCUT = VALID_CHOICE.map(&:chr).zip(VALID_CHOICE).to_h

  def choose
    clear_screen()
    choice = choice_prompt
    self.move = Move.new(choice)
  end

  private

  def choice_prompt
    loop do
      prompt "Choose one: #{VALID_CHOICE.join(', ')}"
      print_shortcuts
      choice = gets.chomp
      break choice if VALID_CHOICE.include?(choice)
      break VALID_SHORTCUT[choice] if VALID_SHORTCUT.include?(choice)

      clear_screen()
      puts 'Oops. That\'s not a valid choice.'
    end
  end

  def print_shortcuts
    prompt 'Shortcuts:'
    VALID_SHORTCUT.each do |shortcut, choice|
      puts "   #{shortcut} for #{choice}"
    end
  end
end

class Computer < Player
  def choose
    self.move = Move.new(VALID_CHOICE.sample)
  end
end

RPSGame.new.play
