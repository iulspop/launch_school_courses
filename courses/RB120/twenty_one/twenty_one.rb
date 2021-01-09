=begin
The goal of twenty-one is to get as close to hand worth 21 as possible.
There are two participants, the dealer and the player. They are both dealt two cards from a deck. The player can see their card and one of the dealer's cards.
The player is given the option to hit or stay. If they hit, they draw a card. If the total is greater than 21, they lose. If not, they're given a choice again. Once the player stays, the dealer also hits or stays with the same rules.
Finally the player with the closest value to 21 wins the round, or if the hands are equal, then its a tie. The first to win five rounds wins.

Card
  @rank
  @suit
  -------
  init(rank, suit)
  rank
  to_s

Deck
  @cards = array of cards
  --------
  init deck
  shuffle
  draw_card

Hand
  @cards = array of cards
  -------
  << card
  total
  compare !!!!? comparable?
  to_s

Participant
  @hand = Hand.new
  -------
  play_turn

  private


Dealer

Player

TwentyOneGame
  @dealer
  @player
  @deck
  @score
  -------

pieces

card
card
card

hand => total

hand draws card from deck

hand is displayed (option hidden)

=end
require_relative 'ascii_cards'
class Card
  include AsciiCardable

  attr_reader :rank

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def ==(other_card)
    rank == other_card.rank
  end

  def to_s
    ascii_card
  end

  private

  attr_reader :suit
end

class Deck
  SUITS = ['Hearts', 'Diamonds', 'Clubs', 'Spades']
  CARDS = [2, 3, 4, 5, 6, 7, 8, 9, 10, 'Jack', 'Queen', 'King', 'Ace']

  def initialize(shuffle: false)
    @cards = CARDS.product(SUITS).each_with_object([]) do |(rank, suit), cards|
      cards << Card.new(rank, suit)
    end

    @cards = @cards.shuffle if shuffle
  end

  def draw
    cards.pop
  end

  private

  attr_reader :cards
end

class Hand
  HAND_TARGET_VALUE = 21

  def initialize
    @cards = []
  end

  def <<(card)
    cards << card
    nil
  end

  def total
    total = 0
    cards.each do |card|
      rank = card.rank
      if %w(King Queen Jack).include? rank
        total += 10
      elsif rank.is_a? Integer
        total += rank
      end
    end
    total += adjust_aces_value(total)
  end

  def to_s
    concat_hand + values_and_total
  end

  private

  attr_reader :cards

  def adjust_aces_value(total)
    value = 0
    aces_count = cards.count { |card| card.rank == 'Ace' }
    value += aces_count * 11
    aces_count.times { value -= 10 if total + value > HAND_TARGET_VALUE }
    value
  end

  def concat_card(card1, card2)
    empty_space = AsciiCardable::EMPTY_SPACE
    lines = card1.split("\n").zip(empty_space.split("\n"), card2.split("\n"))

    lines.map do |(line, empty_line, line2)|
      line + empty_line + line2
    end.join("\n")
  end

  def concat_hand
    cards.map(&:to_s).reduce { |concat, card| concat_card(concat, card) }
  end

  def values_and_total(hide_value = false)
    values = "\n"
    cards.each_with_index do |card, index|
      if index == cards.length - 1 && hide_value
        return values << '?'.center(11) + ' =   ?'
      else
        values << card.rank.to_s.center(11)
        values << '  +  ' if index != cards.length - 1
      end
    end
    values + ' =  ' + total.to_s
  end
end


class Player
  def initialize(deck)
    @hand = Hand.new
    hand << deck.draw
    hand << deck.draw
  end

  def play_turn(deck)
    choice = get_player_input
    hand << deck.draw if choice == 'hit'
  end

  private

  attr_reader :hand
end

class Dealer

end

class Game
  def initialize
    @deck   = nil
    @player = nil
    @dealer = nil
    @score  = nil
  end

  def play
    # welcome
    game_loop
    # goodbye
  end

  private

  attr_accessor :deck, :player, :dealer, :score

  def game_loop
    loop do
    reset_score

    round_loop
    # display_game_winner(scores)
    # break unless play_again?
    end
  end

  def reset_score
    score  = Score.new
  end

  def round_loop
    loop do
      setup_round
      round_winner = play_round
      # after_round
    end
  end

  def setup_round
    deck   = Deck.new
    player = Player.new
    dealer = Dealer.new
  end

  def play_round
    round_winner = player.play_turn
    # round_winner ||= dealer.play_turn
    # round_winner ||= determine_round_winner
  end

  def after_round(round_winner)
    # display_hands
    # score.update(round_winner)
    # display_score

    # break if win_game?
    # display_round_winner
    # any_key_to_continue('Press any key to start next round...')
  end
end
