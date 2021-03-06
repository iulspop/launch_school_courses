require 'minitest/autorun'
require_relative 'twenty_one'

describe 'Card class' do
  it 'rank getter returns card rank' do
    ace = Card.new('Ace', 'Spades')
    _(ace.rank).must_equal 'Ace'
  end

  it '== compares rank' do
    ace = Card.new('Ace', 'Spades')
    ace2 = Card.new('Ace', 'Spades')
    _(ace == ace2).must_equal true

    queen = Card.new('Queen', 'Spades')
    _(ace == queen).must_equal false
  end

  it 'to_s returns ASCII art for card' do
    _(Card.new('Ace', 'Spades').to_s).must_equal(
' _________ 
|A        |
|@   *    |
|   / \   |
|  /_@_\  |
|    !    |
|   ~ ~  @|
|        V|
 ~~~~~~~~~ ')
  end

  it 'to_s returns ASCII art for card' do
    _(Card.new(2, 'Hearts').to_s).must_equal(
' _________ 
|2        |
|#        |
|    #    |
|         |
|    #    |
|        #|
|        Z|
 ~~~~~~~~~ ')
  end
end

describe 'Deck class' do
  it 'can draw from deck' do
    deck = Deck.new
    _(deck.draw.is_a? Card).must_equal true
  end

  it 'draw stills works when init Deck with shuffle' do
    deck = Deck.new(shuffle: true)
    _(deck.draw.is_a? Card).must_equal true
  end
end

describe 'Hand class' do
  it 'adds cards to hand using <<' do
    hand = Hand.new
    _(hand << Card.new('Ace', 'Spades')).must_be_nil nil
  end

  it 'calculates hand total for numeric ranked cards' do
    hand = Hand.new
    hand << Card.new(1, 'Spades')
    hand << Card.new(5, 'Spades')
    hand << Card.new(9, 'Spades')
    _(hand.total).must_equal 15
  end

  it 'Jack, Queen and King cards are worth 10' do
    hand = Hand.new
    hand << Card.new('Jack', 'Spades')
    hand << Card.new('Queen', 'Spades')
    hand << Card.new('King', 'Spades')
    _(hand.total).must_equal 30
  end

  it 'Ace cards are worth 11 when total less than 22' do
    hand = Hand.new
    hand << Card.new('Ace', 'Spades')
    hand << Card.new(5, 'Spades')
    hand << Card.new(5, 'Spades')
    _(hand.total).must_equal 21
  end

  it 'Ace cards are worth 1 when total more than 21' do
    hand = Hand.new
    hand << Card.new('Ace', 'Spades')
    hand << Card.new('Ace', 'Spades')
    hand << Card.new('Ace', 'Spades')
    hand << Card.new('King', 'Spades')
    _(hand.total).must_equal 13
  end

  it 'to_s returns ASCII representation of hand with score underneath' do
    hand = Hand.new
    hand << Card.new(5, 'Diamonds')
    hand << Card.new('Jack', 'Clubs')
    hand << Card.new('King', 'Spades')
    _(hand.to_s).must_equal(
' _________       _________       _________ 
|5        |     |J /~~|_  |     |K |/|\|  |
|O        |     |+ | o`,  |     |@ \- -/  |
|  O   O  |     |  | -|   |     | ! |-|   |
|    O    |     | =~)+(_= |     |  % I %  |
|  O   O  |     |   |- |  |     |   |-| ! |
|        O|     |  `.o | +|     |  /- -\ @|
|        S|     |  ~|__/ P|     |  |\|/| X|
 ~~~~~~~~~       ~~~~~~~~~       ~~~~~~~~~ 
     5       +     Jack      +     King     =  25'
    )
  end
end