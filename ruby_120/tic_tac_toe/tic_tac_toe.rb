require 'io/console'

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

sqr1 = Square.new
sqr1.update_mark('X')

sqr2 = Square.new
sqr2.update_mark('X')

sqr3 = Square.new
sqr3.update_mark('X')

line1 = Line.new(sqr1, sqr2, sqr3)
p line1.squares
p line1.full?

class Board
  def initialize
    squares = []
    9.times { squares << Square.new }
    create_lines(squares)
  end

  def display
    p lines[0].squares
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
end

board = Board.new
p board.winner?
p board.full?

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

      board.mark_square(human.choose_square, human.mark) if human.initiative
      board.mark_square(computer.choose_square, computer.mark) if computer.initiative

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

  def pass_initiative
    human.toggle_initiative
    computer.toggle_initiative
  end
end

Game.new.play_game