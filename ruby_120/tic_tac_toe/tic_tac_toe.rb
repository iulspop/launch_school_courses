=begin
two players each take a turn marking their sign (X or O) on sq
ares in a 3 by 3 board.
First to mark their signs on a full row wins.
if board full end game.

nouns
game, player, board, square, line
human, computer

verbs
mark_square, check_if_a_player_won, board_full

game
  has two players
  has a board

player
  @sign
  @score
  increment_score

  human
    mark_square

  computer
    mark_square

board
  has 8 lines
    use 3 horizontal lines
  check if full
  check if a player won
  display
  display moves

line
  references 3 squares
  do all three squares have the same sign?
  do all three squares have a sign?

square
  @value
  update

=end

class Line
  def initialize(sqr1, sqr2, sqr3)
    @line = [sqr1, sqr2, sqr3]
  end

  def line
    @line.dup.map(&:dup)
  end

  def full?
    line.all? { |sqr| sqr.sign != '' }
  end

  def winner?
    return 'X' if all?('X')
    return 'O' if all?('O')
    nil
  end

  private

  def all?(string)
    line.all? { |sqr| sqr.sign == string }
  end
end

class Square
  def initialize
    @sign = ''
  end

  def update_sign(sign)
    if sign != 'X' && sign != 'O'
      raise 'Error invalid sign value, please use "X" or "O" strings'
    end
    self.sign = sign
  end

  def sign
    @sign.clone
  end

  private

  attr_writer :sign
end

sqr1 = Square.new
sqr1.update_sign('X')

sqr2 = Square.new
sqr2.update_sign('X')

sqr3 = Square.new
sqr3.update_sign('X')

line1 = Line.new(sqr1, sqr2, sqr3)
p line1.line
p line1.full?

class Board
  def initialize
    squares = []
    9.times { squares << Square.new }
    @lines = create_lines(squares)
  end

  def winner?
    winner = nil
    lines.any? { |line| winner = line.winner? }
    winner
  end

  def full?
    lines[0..2].all? { |line| line.full? }
  end

  private

  def add_horizontal_lines(lines, squares)
    lines << Line.new(squares[0], squares[1], squares[2])
    lines << Line.new(squares[3], squares[4], squares[5])
    lines << Line.new(squares[6], squares[7], squares[8])
  end

  def add_vertical_lines(lines, squares)
    lines << Line.new(squares[0], squares[3], squares[6])
    lines << Line.new(squares[1], squares[4], squares[7])
    lines << Line.new(squares[2], squares[5], squares[8])
  end

  def add_diagonal_lines(lines, squares)
    lines << Line.new(squares[0], squares[4], squares[8])
    lines << Line.new(squares[2], squares[4], squares[6])
  end

  def create_lines(squares)
    lines = []
    add_horizontal_lines(lines, squares)
    add_vertical_lines(lines, squares)
    add_diagonal_lines(lines, squares)
    lines
  end

  def lines
    @lines.dup.map(&:dup)
  end
end

board = Board.new
p board.winner?
p board.full?

=begin
class Game
  def initialize
    @human =
    @computer =
    @board =
  end

  def play
    play_all_rounds
    display_game_winner(scores)
    break unless play_again?
  end

  private

  def play_all_rounds
    loop do
      reset_board
      reset_player_signs

      play_round

      display_board
      update_score
      display_score

      break if win_game?
      display_round_winner
      any_key_to_continue('Press any key to start next round...')
    end
  end

  def play_round
    loop do
      display_board

      human.mark_square    if human.initiative
      computer.mark_square if computer.initiative

      pass_initiative

      break if board.is_winner? || board.is_full?
    end
  end
end

class Player

end
=end
