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

  # it 'to_s returns ASCII art for card'
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
    _(hand << Card.new('Ace', 'Spades')).must_nil nil
  end

  it 'calculates hand total for numeric ranked cards' do
    hand = Hand.new
    hand << Card.new(1, 'Spades')
    hand << Card.new(5, 'Spades')
    hand << Card.new(9, 'Spades')
    _(hand.total).must_equal 15
  end
end