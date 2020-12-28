=begin
The goal of twenty-one is to get as close to hand worth 21 as possible.
There are two participants, the dealer and the player. They are both dealt two cards from a deck. The player can see their card and one of the dealer's cards.
The player is given the option to hit or stay. If they hit, they draw a card. If the total is greater than 21, they lose. If not, they're given a choice again. Once the player stays, the dealer also hits or stays with the same rules.
Finally the player with the closest value to 21 wins the round, or if the hands are equal, then its a tie. The first to win five rounds wins.

Card
  has a value & suit

Deck
  has cards
  --------

Hand
  has cards
  --------
  draw card from deck
  calc hand value

Participant

Dealer
  has a hand
  -------

Player
  has a hand
  -------

=end

class Deck

end