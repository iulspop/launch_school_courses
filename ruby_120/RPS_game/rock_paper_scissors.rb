require "io/console"

def prompt(message, *extra)
  puts "==> #{message}", *extra
end

def clear_screen
  system('clear') || system('clr')
end

def any_key_to_continue(message)
  prompt message
  STDIN.getch
end

EARTH_ART = <<-MSG
o               .        ___---___                    .                   
       .              .--\\        --.     .     .         .
                    ./.;_.\\     __/~ \\.     
                   /;  / `-'  __\\    . \\                            
 .        .       / ,--'     / .   .;   \\        |
                 | .|       /       __   |      -O-       .
                |__/    __ |  . ;   \\ | . |      |
                |      /  \\\\_    . ;| \\___|    
   .    o       |      \\  .~\\___,--'     |           .
                 |     | . ; ~~~~\\_    __|
    |             \\    \\   .  .  ; \\  /_/   .
   -O-        .    \\   /         . |  ~/                  .
    |    .          ~\\ \\   .      /  /~          o
  .                   ~--___ ; ___--~       
                 .          ---         .              
MSG

SATURN_ART = <<-MSG
        ~+

                 *       +
           '                  |
       ()    .-.,="``"=.    - o -
             '=/_       \\     |
          *   |  '=._    |
               \\     `=./`,        '
            .   '=.__.=' `='      *
   +                         +
        O      *        '       .
MSG

ROBOT_ART = <<-MSG
o
 \\_/\\o
( Oo)                     \\|/
(_=-)  .===O-  ~~Z~A~P~~  -O-
/   \\_/U'                 /|\\
||  |_/
\\\\  |
{K ||
 | PP
 | ||
 (__\\\\
MSG

class RPSGame
  SCORE_TO_WIN = 5
  RULES_MESSAGE = <<-MSG
The rules are: 
  - Scissors cuts Paper, decapitates Lizard.
  - Paper covers Rock, disproves Spock.
  - Rock crushes Scissors, crushes Lizard.
  - Lizard eats Paper, poisons Spock.
  - Spock vaporizes Rock, crushes Scissors.

The first to win five rounds wins the tournament!
MSG

  def initialize
    @human    = Human.new
    @computer = Robots.const_get(Robots::constants.sample).new
  end

  def play
    display_welcome_message
    display_rules_message
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
    intro_message = <<-MSG
Oh #{human.name}, the Space Hero,

You've been called to defend the Galaxy from the evil #{computer.name} robot.
#{computer.name} is bent on turning us all into paper clips! 

Go challenge the thinking machine to a \"Rock Paper Scissors Lizard Spock!\" tournament.
Once victorious, access its code and deactivate the paper clip maximizer!

Beware, each robot plays in its own way. That is the key to saving the Galaxy!
MSG
    clear_screen()
    puts intro_message, ''
    any_key_to_continue('Press any key to see tournament rules...')
  end

  def display_rules_message
    clear_screen()
    puts RULES_MESSAGE, ''
    any_key_to_continue('Press any key to challenge the robot...')
  end

  def rounds_loop
    loop do
      play_round
      break if [human.score, computer.score].include? SCORE_TO_WIN
      any_key_to_continue('Press any key to start next round...')
    end
  end

  def play_round
    computer.choose(human.last_move)
    human.choose
    won_or_lost = human.compare(computer)
    update_score(won_or_lost, human, computer)
    display_round_info(won_or_lost)
  end

  def update_score(won_or_lost, human, computer)
    human.increment_score    if won_or_lost == 'won'
    computer.increment_score if won_or_lost == 'lost'
  end

  def display_round_info(won_or_lost)
    display_score(human, computer)
    display_result(won_or_lost, human.move, computer.move)
    display_choices(human, computer)
  end

  def display_score(human, computer)
    clear_screen()
    puts ROBOT_ART, ''
    puts '==== SCORE ===='
    puts "#{human.name}: #{human.score}   " \
    "#{computer.name}: #{computer.score}", ''
  end

  def display_choices(human, computer)
    puts "#{human.name} chose: #{human.move}"
    puts "#{computer.name} chose: #{computer.move}", ''
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

class Player
  VALID_CHOICE = ['rock', 'paper', 'scissors', 'lizard', 'Spock']

  attr_reader :score, :name

  def initialize
    set_name
    @score = 0
    @move_history = []
  end

  def move
    @move.clone
  end

  def last_move
    @move_history[-1].clone.to_s.downcase
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

  attr_writer :score, :name

  def move=(choice)
    @move_history << choice
    @move = choice
  end
end

class Human < Player
  VALID_SHORTCUT = VALID_CHOICE.map(&:chr).zip(VALID_CHOICE).to_h

  def choose
    clear_screen()
    choice = choice_prompt
    self.move = Move.new(choice)
  end

  private

  def set_name
    clear_screen()
    name = name_input_loop
    self.name = name.capitalize
  end

  def name_input_loop
    loop do
      puts EARTH_ART, ''
      prompt 'Please enter a name for your space hero'
      prompt '(Only letters and at least three chars)'
      name = gets.chomp
      break name if name.match?(/^[a-z]{3,}$/i)
      clear_screen()
      puts "Oops, please enter a valid name"
    end
  end

  def choice_prompt
    loop do
      puts SATURN_ART, ''
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

module Robots
  class RoboRaptor < Player
    def set_name
      self.name = 'Robo-Raptor'
    end

    def choose(opponent_last_move)
      self.move =
        if ['rock', 'scissors'].include? opponent_last_move
          Move.new('Spock')
        else
          Move.new('lizard')
        end
    end
  end

  class Galactron < Player
    def set_name
      self.name = 'Galactron'
    end

    def choose(_opponent_last_move)
      self.move = Move.new(VALID_CHOICE.sample)
    end
  end

  class YesMan < Player
    def set_name
      self.name = 'Yes Man'
    end

    def choose(opponent_last_move)
      self.move = opponent_last_move || Move.new(VALID_CHOICE.sample)
    end
  end

  class TikTok < Player
    def set_name
      self.name = 'Tik-Tok'
    end

    def choose(opponent_last_move)
      self.move =
        if ['paper', 'lizard'].include? opponent_last_move
          Move.new('scissors')
        else
          Move.new('Spock')
        end
    end
  end

  class OldBob < Player
    def set_name
      self.name = 'Old B.O.B'
    end

    def choose(opponent_last_move)
      self.move =
        if ['paper', 'Spock'].include? opponent_last_move
          Move.new('paper')
        else
          Move.new('rock')
        end
    end
  end
end

class Move
  WIN_MOVES = (Player::VALID_CHOICE).permutation(2).to_a
                                    .select do |(first, second)|
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

RPSGame.new.play
