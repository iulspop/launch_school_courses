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
  def initialize
    squares = []
    9.times { squares << Square.new }
    create_lines(squares)
  end

  def display
    clear_screen
    puts to_ascii_board(lines[0..2]), ''
  end

  def winner?
    winner = nil
    lines.any? { |line| winner = line.winner? }
    winner
  end

  def full?
    lines[0..2].all? { |line| line.full? }
  end

  def mark_square(position, mark)
    vertical_index, horizontal_index = position
    lines[vertical_index].squares[horizontal_index].update_mark(mark)
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
end

class Player
  attr_reader :mark, :initiative

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
  def choose_square
    any_key_to_continue
    [0, 1]
  end

  def pick_mark
    self.mark = ['X', 'O'].sample
    self.initiative = mark == 'X' ? true : false
  end

end

class Computer < Player
  def choose_square
    any_key_to_continue
    [0, 0]
  end

  def pick_mark(human_mark)
    self.mark = human_mark == 'X' ? 'O' : 'X'
    self.initiative = mark == 'X' ? true : false
  end
end

class Game
  def initialize
    @human = Human.new
    @computer = Computer.new
  end

  def play_game
    play_all_rounds
    # display_game_winner(scores)
    # break unless play_again?
  end

  private

  attr_accessor :board

  attr_reader :human, :computer

  def play_all_rounds
    loop do
      reset_board
      reset_player_marks

      play_round

      board.display
      # update_score
      # display_score

      # break if win_game?
      # display_round_winner
      # any_key_to_continue('Press any key to start next round...')
    end
  end

  def play_round
    loop do
      board.display

      human.initiative ? play_move(human) : play_move(computer)
      pass_initiative

      break if board.winner? || board.full?
    end
  end

  def reset_board
    self.board = Board.new
  end

  def reset_player_marks
    human.pick_mark
    computer.pick_mark(human.mark)
  end

  def play_move(player)
    board.mark_square(player.choose_square, player.mark)
  end

  def pass_initiative
    human.toggle_initiative
    computer.toggle_initiative
  end
end

Game.new.play_game