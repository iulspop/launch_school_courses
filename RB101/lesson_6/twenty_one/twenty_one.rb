require 'io/console'
load 'ascii_art.rb'

WIN_SCORE = 5
MAX_TOTAL = 21
DEALER_HIT = 17

RULES_MESSAGE = <<-MSG
GAME RULES:
There's a dealer and you, the player.
Both participants are initially dealt 2 cards.
The player can see their 2 cards, but can only see one of the dealer's cards.

The goal of #{MAX_TOTAL} is to try to get as close to #{MAX_TOTAL} as possible,
without going over. If you go over #{MAX_TOTAL}, it's a "bust" and you lose.

The player goes first, and can decide to either "hit" or "stay".
A hit means the player will ask for another card.
A stay means the turn passes to the dealer.

Then dealer plays. Finally, the round winner is determined.

THE FIRST TO WIN FIVE ROUNDS WINS THE GAME!
MSG

BEJ_MESSAGE = <<-MSG
# This program uses Bej's cards
# https://ascii.co.uk/art/cards
MSG

SUITS = ['Hearts', 'Diamonds', 'Clubs', 'Spades']
CARDS = [2, 3, 4, 5, 6, 7, 8, 9, 10, 'Jack', 'Queen', 'King', 'Ace']

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

  puts "Let\'s play #{MAX_TOTAL}!", ''
  prompt RULES_MESSAGE, ''
  puts BEJ_MESSAGE, ''

  any_key_to_continue('Press any key to start playing...')
end

def create_deck
  CARDS.product(SUITS).shuffle
end

def draw_card(deck, hand)
  hand << deck.pop
end

def get_hands(deck)
  hands = { dealer: [], player: [] }
  2.times do
    draw_card(deck, hands[:dealer])
    draw_card(deck, hands[:player])
  end
  hands
end

def calc_aces_value(total, hand)
  value = 0

  aces_count = hand.count { |(name, _)| name == 'Ace' }
  value += aces_count * 11
  aces_count.times { value -= 10 if total + value > MAX_TOTAL }

  value
end

def calc_hand_total(hand)
  total = 0

  hand.each do |(value, _)|
    if %w(King Queen Jack).include? value
      total += 10
    elsif value.is_a? Integer
      total += value
    end
  end

  total += calc_aces_value(total, hand)
end

def calc_totals(hands)
  totals = { dealer: 0, player: 0 }

  hands.each do |participant, hand|
    totals[participant] = calc_hand_total(hand)
  end

  totals
end

def setup_round
  deck = create_deck
  hands = get_hands(deck)
  [deck, hands, calc_totals(hands)]
end

def concat_card(card1, card2)
  lines = card1.split("\n").zip(EMPTY_SPACE.split("\n"), card2.split("\n"))

  lines.map do |(line, empty_line, line2)|
    line + empty_line + line2
  end.join("\n")
end

def concat_hand(hand)
  hand.reduce { |concat, card| concat_card(concat, card) }
end

def get_card_index(value)
  CARDS.index value
end

def to_ascii_card((value, suit))
  DECK[suit][get_card_index(value)]
end

def to_ascii_hand(hand, hide_card = false)
  ascii_hand = hand.map.with_index do |card, index|
    if index == hand.length - 1 && hide_card then MYSTERY_CARD
    else to_ascii_card(card) end
  end
  concat_hand(ascii_hand)
end

def values_and_total(hand, total, hide_value = false)
  values = ''
  hand.each_with_index do |(value, _), index|
    if index == hand.length - 1 && hide_value
      return values << '?'.center(11) + ' =   ?'
    else
      values << value.to_s.center(11)
      values << '  +  ' if index != hand.length - 1
    end
  end
  values + ' =   ' + total.to_s
end

def display_hand(participant, hand, total, reveal)
  hide = participant == :dealer && reveal == false ? true : false
  puts "====== #{participant.upcase}'S HAND ======"
  puts to_ascii_hand(hand, hide), ''
  puts values_and_total(hand, total, hide), '', ''
end

def display_hands(hands, totals, reveal = false)
  clear_screen
  hands.each do |participant, hand|
    display_hand(participant, hand, totals[participant], reveal)
  end
end

def hit_or_stay?
  choice = ''

  prompt "It's your turn."
  loop do
    prompt 'Hit or Stay? (h or s)'
    choice = gets.chomp.downcase

    break if %w(h s hit stay).include?(choice)
    puts 'Oops, invalid move.'
  end

  choice.chr
end

def dealer_hit_or_stay?(total)
  total < DEALER_HIT ? 'h' : 's'
end

def get_choice(player, hands, totals)
  if player == :player
    display_hands(hands, totals)
    hit_or_stay?
  else
    dealer_hit_or_stay?(totals[player])
  end
end

def update_totals!(hands, totals)
  new_totals = calc_totals(hands)
  new_totals.each { |participant, total| totals[participant] = total }
end

def play_turn(player, deck, hands, totals)
  loop do
    choice = get_choice(player, hands, totals)
    round_winner = player == :player ? 'dealer' : 'player'

    if choice == 'h'
      draw_card(deck, hands[player])
      update_totals!(hands, totals)
      return round_winner if totals[player] > MAX_TOTAL
    else
      break
    end
  end
end

def display_score(scores)
  puts '===== SCORE ====='
  puts "Player: #{scores[:player]}   " \
       "Dealer: #{scores[:dealer]}", ''
end

def update_score!(round_winner, scores)
  scores[:player] += 1 if round_winner == 'player'
  scores[:dealer] += 1 if round_winner == 'dealer'
end

def calc_round_winner(totals)
  if totals[:player] > totals[:dealer]
    'player'
  elsif totals[:player] < totals[:dealer]
    'dealer'
  else 'tie' end
end

def display_round_winner(round_winner)
  case round_winner
  when 'player' then prompt 'You won this round!', ''
  when 'dealer' then prompt 'You lost this round!', ''
  when 'tie'    then prompt 'This round is a tie.', '' end
end

def win_game?(scores)
  scores.values.include?(WIN_SCORE)
end

def display_game_winner(scores)
  case WIN_SCORE
  when scores[:player] then prompt 'You won the game!', ''
  when scores[:dealer] then prompt 'You lost the game!', '' end
end

def play_again?
  loop do
    prompt 'Play again? (y or n)'
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
  scores = { player: 0, dealer: 0 }

  loop do
    deck, hands, totals = setup_round

    round_winner = play_turn(:player, deck, hands, totals)
    round_winner ||= play_turn(:dealer, deck, hands, totals)
    round_winner ||= calc_round_winner(totals)

    display_hands(hands, totals, true)
    update_score!(round_winner, scores)
    display_score(scores)

    break if win_game?(scores)
    display_round_winner(round_winner)
    any_key_to_continue('Press any key to start next round...')
  end

  display_game_winner(scores)
  break unless play_again?
end

goodbye
