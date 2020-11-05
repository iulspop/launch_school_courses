require "io/console"

SCORE_TO_WIN = 5
VALID_CHOICE = ['rock', 'paper', 'scissors', 'lizard', 'Spock']
VALID_SHORTCUT = VALID_CHOICE.map(&:chr).zip(VALID_CHOICE).to_h
WIN_CHOICES = VALID_CHOICE.permutation(2).to_a.select do |(first, second)|
  case first
  when 'rock' then ['scissors', 'lizard'].include?(second)
  when 'paper' then ['rock', 'Spock'].include?(second)
  when 'scissors' then ['paper', 'lizard'].include?(second)
  when 'lizard' then ['Spock', 'paper'].include?(second)
  when 'Spock' then ['scissors', 'rock'].include?(second) end
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
RULES_MESSAGE = <<-MSG
The rules are: 
    - Scissors cuts Paper, decapitates Lizard.
    - Paper covers Rock, disproves Spock.
    - Rock crushes Scissors, crushes Lizard.
    - Lizard eats Paper, poisons Spock.
    - Spock vaporizes Rock, crushes Scissors.
MSG

def prompt(message, *extra)
  puts "==> #{message}", *extra
end

def clear_screen
  system('clear') || system('clr')
end

def welcome
  clear_screen()
  puts 'Welcome to the "Rock Paper Scissors Spock Lizard" game!', ''
  sleep 0.15

  prompt(RULES_MESSAGE)
  print "\n"
  prompt 'The first to score 5 points wins!', ''

  prompt 'Press any key to start game...'
  STDIN.getch
end

def print_shortcuts
  prompt 'Shortcuts:'
  VALID_SHORTCUT.each { |shortcut, choice| puts "   #{shortcut} for #{choice}" }
end

def get_choice
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
  choice
end

def win?(first, second)
  choices = [first, second]
  WIN_CHOICES.include?(choices)
end

def compute_winner(player_choice, computer_choice)
  return 'player'   if win?(player_choice, computer_choice)
  return 'computer' if win?(computer_choice, player_choice)
  'tie'
end

def update_score(scores, round_winner)
  scores[:player_score] += 1 if round_winner == 'player'
  scores[:computer_score] += 1 if round_winner == 'computer'
end

def display_score(scores)
  clear_screen()
  puts '==== SCORE ===='
  puts "Player: #{scores[:player_score]}   " \
  "Computer: #{scores[:computer_score]}" , ''
end

def round_description(first, second)
  "#{first.capitalize} #{VERBS[first][second]} #{second.capitalize}!"
end

def display_round_results(round_winner, player_choice, computer_choice)
  case round_winner
  when 'player'
    prompt(round_description(player_choice, computer_choice))
    prompt 'You won this round.'
  when 'computer'
    prompt(round_description(computer_choice, player_choice))
    prompt 'You lost this round.'
  when 'tie'
    prompt 'This round is a tie.'
  end
  puts ''
end

def display_choices(choice, computer_choice)
  puts "You chose:      #{choice.capitalize}"
  puts "Computer chose: #{computer_choice.capitalize}", ''
end

def display_game_winner(scores)
  if scores[:player_score] == SCORE_TO_WIN
    prompt "You won the game!"
  else
    prompt "You lost the game!"
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

def goodbye
  clear_screen()
  puts 'Thank you for playing. Good bye!'
end

welcome()
loop do
  scores = {
    player_score: 0,
    computer_score: 0
  }

  loop do
    display_score(scores)

    player_choice = get_choice()
    computer_choice = VALID_CHOICE.sample

    round_winner = compute_winner(player_choice, computer_choice)
    update_score(scores, round_winner)

    display_score(scores)
    display_round_results(round_winner, player_choice, computer_choice)
    display_choices(player_choice, computer_choice)

    break if scores.values.include? SCORE_TO_WIN

    any_key_to_continue
  end

  display_game_winner(scores)
  break unless play_again?
end

goodbye()
