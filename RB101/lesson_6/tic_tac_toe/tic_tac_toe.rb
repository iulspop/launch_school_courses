require 'io/console'
load 'ascii_art.rb'

WIN_SCORE = 3

RULES_MESSAGE = <<-MSG
The rules are: 
    Two players, X and O, take turns marking the spaces in a 3×3 grid.

    The player who succeeds in placing three of their marks
    in a horizontal, vertical, or diagonal row wins the round.

    !!!IMPORTANT NOTE!!!
    THE COMPUTER IS SMART BUT YOU CAN WIN!

    The first to win three rounds wins the game!
MSG

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

def compute_openings
  openings = []
  8.times do |slice_index|
    3.times { |square_index| openings << [slice_index, square_index] }
  end
  openings
end

def horizontal_squares
  VALID_MOVES.dup.values
end

def vertical_squares
  vertical_squares = []
  3.times do |square_index|
    3.times { |row_index| vertical_squares << [row_index, square_index] }
  end
  vertical_squares
end

def diagonal_squares
  [[0, 0], [1, 1], [2, 2], [0, 2], [1, 1], [2, 0]]
end

def compute_moves
  [horizontal_squares,
   vertical_squares,
   diagonal_squares].flatten(1)
end

def map_openings_to_moves(openings, moves)
  openings.each_with_index.map { |opening, index| [opening, moves[index]] }.to_h
end

OPENING_TO_MOVE = map_openings_to_moves(compute_openings, compute_moves)

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

def welcome
  clear_screen

  puts 'Welcome to Tic Tac Toe game!', ''
  prompt RULES_MESSAGE, ''

  any_key_to_continue('Press any key to start playing...')
end

def assign_markers
  human_marker = ['X', 'O'].sample
  computer_marker = human_marker == 'X' ? 'O' : 'X'
  { human: human_marker, computer: computer_marker }
end

def setup_round
  [[
    ['', '', ''],
    ['', '', ''],
    ['', '', '']
  ],
   VALID_MOVES.dup,
   assign_markers,
   'X',
   nil]
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

def to_ascii_sqr(square)
  case square
  when 'X' then X_MARK
  when 'O' then O_MARK
  when ''  then EMPTY_SQUARE end
end

def to_ascii_board(board)
  ascii_board = board.map { |row| row.map { |square| to_ascii_sqr(square) } }
  ascii_board.map do |row|
    concat_row(row[0], row[1], row[2]) + HORIZONTAL_LINE
  end
end

def display_board(board)
  clear_screen
  puts to_ascii_board(board), ''
end

def display_moves(moves)
  display = ''
  VALID_MOVES.keys.each_with_index do |move, index|
    display << (moves.include?(move) ? move + ' ' : '  ')
    display << "\n" if (index + 1) % 3 == 0
  end
  puts display
end

def get_human_move(moves)
  player_move = ''

  prompt 'It your turn to mark a space.', ''
  loop do
    prompt 'To mark a square, select one of the following:'
    display_moves(moves)
    player_move = gets.chomp.downcase

    break if moves.include?(player_move)
    puts 'Oops, invalid move.'
  end

  VALID_MOVES[player_move]
end

def slices_with_opening(slices, marker)
  slices_with_index = []
  slices.each_with_index do |slice, index|
    slices_with_index << [slice, index] if slice.join.match(/#{marker}{2}/)
  end
  slices_with_index
end

def squares_opening(slices_with_opening)
  openings = []
  slices_with_opening.each do |(slice, slice_index)|
    slice.each_with_index do |square, square_index|
      openings << [slice_index, square_index] if square == ''
    end
  end
  openings
end

def map_to_move(openings)
  openings.map { |opening| OPENING_TO_MOVE[opening] }
end

def get_opening(board, marker)
  openings = squares_opening(slices_with_opening(board_slices(board), marker))
  openings.empty? ? nil : map_to_move(openings).sample
end

def get_smart_move(moves, board, marker)
  offence = get_opening(board, marker)
  defence = get_opening(board, marker == 'X' ? 'O' : 'X')
  offence || defence || moves.values.sample
end

def get_computer_move(moves, board, marker)
  prompt 'It\'s the computers turn.', ''
  any_key_to_continue 'Press any key for computer mark square...'
  get_smart_move(moves, board, marker)
end

def update_moves!(move, moves)
  moves.delete_if { |_k, v| v == move }
end

def update_board!(move, marker, board)
  board[move[0]][move[1]] = marker
end

def make_a_move(player, marker, moves, board)
  move = case player
         when "human"    then get_human_move(moves)
         when "computer" then get_computer_move(moves, board, marker) end
  update_moves!(move, moves)
  update_board!(move, marker, board)
end

def vertical_slice(index, array)
  array.each_with_object([]) { |horizontal, slice| slice << horizontal[index] }
end

def vertical_slices(array)
  slices = []
  array[0].size.times { |index| slices << vertical_slice(index, array) }
  slices
end

def horizontal_slices(array)
  array.each_with_object([]) { |horizontal, slices| slices << horizontal }
end

def diagonal_slice(array, reverse = false)
  diagonal = []
  array.each_with_index do |horizontal, index|
    diagonal << horizontal[reverse == true ? -index - 1 : index]
  end
  diagonal
end

def diagonal_slices(array)
  [diagonal_slice(array), diagonal_slice(array, true)]
end

def board_slices(board)
  [horizontal_slices(board),
   vertical_slices(board),
   diagonal_slices(board)].flatten(1)
end

def win?(board, marker)
  board_slices(board).any? { |slice| slice.join.match?(/#{marker}{3}/) }
end

def tie?(board)
  board.all? { |row| row.all? { |square| square.match?(/X|O/) } }
end

def get_round_winner(board, markers)
  return 'human'    if win?(board, markers[:human])
  return 'computer' if win?(board, markers[:computer])
  return 'tie'      if tie?(board)
end

def pass_initiative!(initiative)
  initiative == 'X' ? initiative.gsub!('X', 'O') : initiative.gsub!('O', 'X')
end

def display_score(scores)
  puts '', '==== SCORE ===='
  puts "Player: #{scores[:human]}   " \
       "Computer: #{scores[:computer]}", ''
end

def update_score(round_winner, scores)
  scores[:human]    += 1 if round_winner == 'human'
  scores[:computer] += 1 if round_winner == 'computer'
end

def display_round_winner(round_winner)
  case round_winner
  when 'human'    then prompt 'You won this round!', ''
  when 'computer' then prompt 'You lost this round!', ''
  when 'tie'      then prompt 'This round is a tie.', '' end
end

def win_game?(scores)
  scores.values.include?(WIN_SCORE)
end

def display_game_winner(scores)
  case WIN_SCORE
  when scores[:human]    then prompt 'You won the game!', ''
  when scores[:computer] then prompt 'You lost the game!', '' end
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

def goodbye
  clear_screen
  puts 'Thank you for playing. Good bye!'
end

welcome

loop do
  scores = { human: 0, computer: 0 }

  loop do
    board, moves, markers, initiative, round_winner = setup_round

    loop do
      display_board(board)

      case initiative
      when markers[:human]
        make_a_move("human", markers[:human], moves, board)

      when markers[:computer]
        make_a_move("computer", markers[:computer], moves, board)
      end

      round_winner = get_round_winner(board, markers)
      break if round_winner
      pass_initiative!(initiative)
    end

    display_board(board)
    update_score(round_winner, scores)
    display_score(scores)

    break if win_game?(scores)
    display_round_winner(round_winner)
    any_key_to_continue('Press any key to start next round...')
  end

  display_game_winner(scores)
  break unless play_again?
end

goodbye
