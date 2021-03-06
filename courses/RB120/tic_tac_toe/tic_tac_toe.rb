require 'io/console'

module TicTacToe
  module AsciiArt
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
  end

  module Messages
    RULES = <<-MSG
The rules are: 
    Two players, X and O, take turns marking the spaces in a 3×3 grid.

    The player who succeeds in placing three of their marks
    in a horizontal, vertical, or diagonal row wins the round.

    !!!IMPORTANT NOTE!!!
    THE COMPUTER IS SMART BUT YOU CAN WIN!

    The first to win three rounds wins the game!
  MSG
  end

  module Displayable
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

    def []=(index, mark)
      squares[index].update_mark(mark)
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
    include Displayable
    include AsciiArt

    MOVES_QWERTY = {
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

    MOVES_NUMPAD = {
      '1' => [0, 0],
      '2' => [0, 1],
      '3' => [0, 2],
      '4' => [1, 0],
      '5' => [1, 1],
      '6' => [1, 2],
      '7' => [2, 0],
      '8' => [2, 1],
      '9' => [2, 2]
    }

    attr_reader :moves, :reference_moves

    def initialize(shortcut_type)
      squares = []
      9.times { squares << Square.new }
      create_lines(squares)

      @moves = shortcut_type == 'qwerty' ? MOVES_QWERTY.dup : MOVES_NUMPAD.dup
      @reference_moves = moves.dup
    end

    def display
      clear_screen
      puts ascii_board, ''
    end

    def display_moves
      display = ''
      reference_moves.keys.each_with_index do |move, index|
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
      all_lines.any? { |line| winning_mark = line.winner? }
      winning_mark
    end

    def full?
      lines[:horizontal].all?(&:full?)
    end

    def mark_square(position, mark)
      row_index, column_index = position
      lines[:horizontal][row_index][column_index] = mark
    end

    def delete_used_move(position)
      row_index, column_index = position
      moves.delete_if { |_, value| value == [row_index, column_index] }
    end

    def get_smart_move(player_mark)
      offence = get_opening(player_mark)
      defence = get_opening(player_mark == 'X' ? 'O' : 'X')
      offence || defence || moves.values.sample
    end

    private

    attr_reader :lines

    def add_horizontal_lines(squares)
      lines[:horizontal] =
        [Line.new(squares[0], squares[1], squares[2]),
         Line.new(squares[3], squares[4], squares[5]),
         Line.new(squares[6], squares[7], squares[8])]
    end

    def add_vertical_lines(squares)
      lines[:vertical] =
        [Line.new(squares[0], squares[3], squares[6]),
         Line.new(squares[1], squares[4], squares[7]),
         Line.new(squares[2], squares[5], squares[8])]
    end

    def add_diagonal_lines(squares)
      lines[:diagonal] =
        [Line.new(squares[0], squares[4], squares[8]),
         Line.new(squares[2], squares[4], squares[6])]
    end

    def create_lines(squares)
      @lines = {}
      add_horizontal_lines(squares)
      add_vertical_lines(squares)
      add_diagonal_lines(squares)
    end

    def all_lines
      lines.values.flatten
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

    def to_ascii_board
      lines[:horizontal].map do |line|
        line.squares.map { |square| to_ascii_sqr(square.mark) }
      end
    end

    def concat_ascii_board
      to_ascii_board.map do |row|
        concat_row(row[0], row[1], row[2]) + HORIZONTAL_LINE
      end
    end

    def ascii_board
      concat_ascii_board
    end

    def lines_with_opening(player_mark)
      all_lines.each_with_object([]) do |line, lines_with_opening|
        row_as_string = line.squares.map(&:mark).join
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
      lines[:horizontal].each_with_index do |line, row_index|
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
    include Displayable

    attr_reader :mark, :initiative, :score

    def initialize
      @score = 0
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
      self.initiative = mark == 'X'
    end

    def choose_square(board)
      player_move = prompt_to_choose(board)
      board.reference_moves[player_move]
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
      self.initiative = mark == 'X'
    end
  end

  class Game
    include Displayable
    include Messages
    WIN_SCORE = 3

    def initialize
      @human = Human.new
      @computer = Computer.new
    end

    def play_game
      display_welcome_message
      prompt_choose_shortcut
      loop do
        play_all_rounds
        display_game_winner
        break unless play_again?
      end
      display_goodbye_message
    end

    private

    attr_accessor :board, :shortcut_type

    attr_reader :human, :computer

    def display_welcome_message
      clear_screen

      puts 'Welcome to Tic Tac Toe game!', ''
      prompt RULES, ''

      any_key_to_continue('Press any key to start playing...')
    end

    def prompt_choose_shortcut
      loop do
        prompt 'Would you like QWERTY shortcuts or numpad shortcuts? (q or n)'
        answer = gets.chomp.downcase
        break self.shortcut_type = 'qwerty' if ['q'].include?(answer)
        break self.shortcut_type = 'numpad' if ['n'].include?(answer)
        clear_screen
        puts 'Oops. Please enter "q" or "n".'
      end
    end

    def play_all_rounds
      loop do
        reset_board
        reset_player_marks

        round_winner = play_round

        display_round_info(round_winner)
        break if win_game?
        display_round_winner(round_winner)
        any_key_to_continue('Press any key to start next round...')
      end
    end

    def reset_board
      self.board = Board.new(shortcut_type)
    end

    def reset_player_marks
      human.pick_mark
      computer.pick_mark(human.mark)
    end

    def play_round
      loop do
        board.display

        play_turn

        winner = board.winner?(human.mark, computer.mark)
        break winner if winner != 'tie' || board.full?
      end
    end

    def play_turn
      human.initiative ? play_move(human) : play_move(computer)
      pass_initiative
    end

    def play_move(player)
      position = player.choose_square(board)
      board.mark_square(position, player.mark)
      board.delete_used_move(position)
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

    def display_round_info(round_winner)
      board.display
      update_score(round_winner)
      display_score
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
        prompt 'Play again? (y/n)'
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
end

TicTacToe::Game.new.play_game
