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
  compare
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

class Card
  attr_reader :rank

  def initialize(rank, suit)
    @rank = rank
  end

  def ==(other_card)
    rank == other_card.rank
  end
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

  def draw_card
    cards.pop
  end

  private

  attr_reader :cards
end