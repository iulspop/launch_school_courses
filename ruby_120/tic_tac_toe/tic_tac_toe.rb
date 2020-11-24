require 'io/console'

X_MARK = <<-MSG
              
    .____,    
   . \\  / ,   
   |`-  -'|   
   |,-  -.|   
   ' /__\\ `   
    '    `    
              
MSG

O_MARK = <<-MSG
              
     ____     
   ,' __ `.   
  / ,'  `. \\  
  | | () | |  
  \\ `.__,' /  
   `.____,'   
              
MSG

EMPTY_SQUARE = <<-MSG
              
              
              
              
              
              
              
              
MSG

HORIZONTAL_LINE = <<-MSG
\n______________|______________|_______________
MSG

VERTICAL_LINE = <<-MSG
|
|
|
|
|
|
|
|
MSG

def prompt(message, *extra)
  puts "==> #{message}", *extra
end

def clear_screen
  system('clear') || system('clr')
end

def any_key_to_continue(message = 'Press any key to continue...')
  prompt message
  STDIN.getch
end

class Line
  attr_reader :squares

  def initialize(sqr1, sqr2, sqr3)
    @squares = [sqr1, sqr2, sqr3]
  end

  def full?
    squares.all? { |sqr| sqr.mark != '' }
  end

  def winner?
    return 'X' if all?('X')
    return 'O' if all?('O')
    nil
  end

  private

  def all?(string)
    squares.all? { |sqr| sqr.mark == string }
  end
end

class Square
  def initialize
    @mark = ''
  end

  def update_mark(mark)
    if mark != 'X' && mark != 'O'
      raise 'Error invalid mark value, please use "X" or "O" strings'
    end
    self.mark = mark
  end

  def mark
    @mark.clone
  end

  private

  attr_writer :mark
end

class Board
  VALID_MOVES = {
    'q' => [0, 0],
    'w' => [0, 1],
    'e' => [0, 2],
    'a' => [1, 0],
    's' => [1, 1],
    'd' => [1, 2],
    'z' => [2, 0],
    'x' => [2, 1],
    'c' => [2, 2]
  }

  attr_reader :moves

  def initialize
    squares = []
    9.times { squares << Square.new }
    create_lines(squares)

    @moves = VALID_MOVES.clone
  end

  def display
    clear_screen
    puts to_ascii_board(lines[0..2]), ''
  end

  def display_moves
    display = ''
    VALID_MOVES.keys.each_with_index do |move, index|
      display << (moves.include?(move) ? move + ' ' : '  ')
      display << "\n" if (index + 1) % 3 == 0
    end
    puts display
  end

  def winner?(human_mark, computer_mark)
    winning_mark = find_winning_mark

    case winning_mark
    when human_mark    then 'human'
    when computer_mark then 'computer'
    when nil           then 'tie' end
  end

  def find_winning_mark
    winning_mark = nil
    lines.any? { |line| winning_mark = line.winner? }
    winning_mark
  end

  def full?
    lines[0..2].all? { |line| line.full? }
  end

  def mark_square(position, mark)
    row_index, column_index = position
    lines[row_index].squares[column_index].update_mark(mark)
    moves.delete_if { |_, value| value == [row_index, column_index]}
  end

  def get_smart_move(player_mark)
    offence = get_opening(player_mark)
    defence = get_opening(player_mark == 'X' ? 'O' : 'X')
    offence || defence || moves.values.sample
  end

  private

  attr_reader :lines

  def add_horizontal_lines(squares)
    lines << Line.new(squares[0], squares[1], squares[2])
    lines << Line.new(squares[3], squares[4], squares[5])
    lines << Line.new(squares[6], squares[7], squares[8])
  end

  def add_vertical_lines(squares)
    lines << Line.new(squares[0], squares[3], squares[6])
    lines << Line.new(squares[1], squares[4], squares[7])
    lines << Line.new(squares[2], squares[5], squares[8])
  end

  def add_diagonal_lines(squares)
    lines << Line.new(squares[0], squares[4], squares[8])
    lines << Line.new(squares[2], squares[4], squares[6])
  end

  def create_lines(squares)
    @lines = []
    add_horizontal_lines(squares)
    add_vertical_lines(squares)
    add_diagonal_lines(squares)
  end

  def concat_vertical(string1, string2)
    lines1 = string1.split("\n")
    lines2 = string2.split("\n")
    concat_lines = []
  
    lines1.each_with_index do |line, index|
      concat_lines << line + lines2[index]
    end
  
    concat_lines.join("\n")
  end
  
  def concat_many_verticals(*strings)
    strings.reduce { |concat, string| concat_vertical(concat, string) }
  end
  
  def concat_row(first, middle, last)
    concat_many_verticals(first, VERTICAL_LINE, middle, VERTICAL_LINE, last)
  end
  
  def to_ascii_sqr(mark)
    case mark
    when 'X' then X_MARK
    when 'O' then O_MARK
    when ''  then EMPTY_SQUARE end
  end
  
  def to_ascii_board(row_lines)
    ascii_board = row_lines.map do |row|
      row.squares.map { |square| to_ascii_sqr(square.mark) }
    end
    ascii_board.map do |row|
      concat_row(row[0], row[1], row[2]) + HORIZONTAL_LINE
    end
  end

  def lines_with_opening(player_mark)
    lines.each_with_object([]) do |line, lines_with_opening|
      row_as_string = line.squares.map { |sqr| sqr.mark }.join
      lines_with_opening << line if row_as_string.match?(/#{player_mark}{2}/)
    end
  end

  def squares_with_opening(lines_with_opening)
    openings = []
    lines_with_opening.each do |line|
      line.squares.each do |square|
        openings << square if square.mark == ''
      end
    end
    openings
  end

  def square_to_move(square)
    lines[0..2].each_with_index do |line, row_index|
      line.squares.each_with_index do |other_square, column_index|
        return [row_index, column_index] if square == other_square
      end
    end
  end

  def squares_to_moves(squares)
    squares.map do |square|
      square_to_move(square)
    end
  end

  def get_opening(player_mark)
    squares = squares_with_opening(lines_with_opening(player_mark))
    squares.empty? ? nil : squares_to_moves(squares).sample
  end
end

class Player
  attr_reader :mark, :initiative, :score

  def initialize
    @score = 0
    # create_name
  end

  def increment_score
    self.score += 1
  end

  def toggle_initiative
    self.initiative = !initiative
  end

  private

  attr_writer :score, :mark, :initiative
end

class Human < Player
  def pick_mark
    self.mark = ['X', 'O'].sample
    self.initiative = mark == 'X' ? true : false
  end

  def choose_square(board)
    player_move = prompt_to_choose(board)
    Board::VALID_MOVES[player_move]
  end

  private

  def prompt_to_choose(board)
    player_move = ''
    prompt 'It your turn to mark a space.', ''
    loop do
      prompt 'To mark a square, select one of the following:'
      board.display_moves
      player_move = gets.chomp.downcase

      break if board.moves.include?(player_move)
      puts 'Oops, invalid move.'
    end
    player_move
  end
end

class Computer < Player
  def choose_square(board)
    prompt 'It\'s the computers turn.', ''
    any_key_to_continue 'Press any key for computer mark square...'
    board.get_smart_move(mark)
  end

  def pick_mark(human_mark)
    self.mark = human_mark == 'X' ? 'O' : 'X'
    self.initiative = mark == 'X' ? true : false
  end

end

class Game
  WIN_SCORE = 3

  def initialize
    @human = Human.new
    @computer = Computer.new
  end

  def play_game
    loop do
      play_all_rounds
      display_game_winner
      break unless play_again?
    end
  end

  private

  attr_accessor :board

  attr_reader :human, :computer

  def play_all_rounds
    loop do
      reset_board
      reset_player_marks

      round_winner = play_round

      board.display
      update_score(round_winner)
      display_score

      break if win_game?
      display_round_winner(round_winner)
      any_key_to_continue('Press any key to start next round...')
    end
  end

  def reset_board
    self.board = Board.new
  end

  def reset_player_marks
    human.pick_mark
    computer.pick_mark(human.mark)
  end

  def play_round
    loop do
      board.display

      human.initiative ? play_move(human) : play_move(computer)
      pass_initiative

      winner = board.winner?(human.mark, computer.mark)
      break winner if winner != 'tie' || board.full?
    end
  end

  def play_move(player)
    board.mark_square(player.choose_square(board), player.mark)
  end

  def pass_initiative
    human.toggle_initiative
    computer.toggle_initiative
  end

  def update_score(round_winner)
    human.increment_score    if round_winner == 'human'
    computer.increment_score if round_winner == 'computer'
  end

  def display_score
    puts '', '==== SCORE ===='
    puts "Player: #{human.score}   " \
         "Computer: #{computer.score}", ''
  end

  def win_game?
    [human.score, computer.score].include?(WIN_SCORE)
  end

  def display_round_winner(round_winner)
    case round_winner
    when 'human'    then prompt 'You won this round!', ''
    when 'computer' then prompt 'You lost this round!', ''
    when 'tie'      then prompt 'This round is a tie.', '' end
  end

  def display_game_winner
    case WIN_SCORE
    when human.score    then prompt 'You won the game!', ''
    when computer.score then prompt 'You lost the game!', '' end
  end

  def play_again?
    loop do
      prompt 'Play again?'
      answer = gets.chomp.downcase
      return true  if ['yes', 'y'].include?(answer)
      return false if ['no', 'n'].include?(answer)
      clear_screen
      puts 'Oops. Please enter Yes or No.'
    end
  end

  def display_goodbye_message
    clear_screen
    puts 'Thank you for playing. Good bye!'
  end
end

Game.new.play_game