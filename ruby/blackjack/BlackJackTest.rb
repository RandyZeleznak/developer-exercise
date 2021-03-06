
require 'minitest/autorun'
require './blackjack.rb'

#-------------------------------------------------------------------
#REZ(16.08) - BlackJackTest is test file to run against blackjack.rb
#-------------------------------------------------------------------


class GameTest < Minitest::Test
  def setup
      @deck = Deck.new
  end
  
   #----------------------------------------------------
   #REZ(16.08) - test_hand_value_is_correctly_calculated
   #		is to test that a given hand sums up the 
   #		card values correctly from the Deck
   #----------------------------------------------------
   def test_hand_value_is_correctly_calculated
     @deck = Deck.new
     @deck = [Card.new(:clubs,:four, 4), Card.new(:diamonds,:ten,10)]
     assert_equal @deck.value, 14
   end
  
   def player_is_determined_winner
     @deck.player_hand=[Card.new(:clubs,:ace, 11), Card.new(:diamonds,:ten,10)]
     @deck.dealer_hand[Card.new(:clubs,:ten, 10), Card.new(:hearts,:ten,10)]
     assert_equal determine_winner(@deck.player_hand.value, @deck.dealer_hand.value), :player
   end
   def dealer_is_determined_winner
     @deck.player_hand.value(20)
     @deck.dealer_hand.value(21)
     assert_equal determine_winner(@deck.player_hand.value, @deck.dealer_hand.value), :dealer
   end
end

#REZ(16/08) - Changed "Test::Unit::TestCase" to "Minitest::Test"
class CardTest < Minitest::Test
  def setup
    @card = Card.new(:hearts, :ten, 10)
  end
  
  def test_card_suite_is_correct  
    assert_equal @card.suite, :hearts
  end

  def test_card_name_is_correct   
    assert_equal @card.name, :ten
  end
  def test_card_value_is_correct
    assert_equal @card.value, 10
  end
end



#REZ(16/08) - Changed "Test::Unit::TestCase" to "Minitest::Test"
class DeckTest < Minitest::Test
  def setup
    @deck = Deck.new
  end
  
  def test_new_deck_has_52_playable_cards
    assert_equal @deck.playable_cards.size, 52
  end
  
  #REZ(16/08) 	- added "!" to "change @deck.playable_cards.include?"
  #		assertion so that it asserts not included
  #-------------------------------------------------------------------------
  def test_dealt_card_should_not_be_included_in_playable_cards
    card = @deck.deal_card
    assert(!@deck.playable_cards.include?(card))		#REZ(16/08)
  end

  def test_shuffled_deck_has_52_playable_cards
    @deck.shuffle
    assert_equal @deck.playable_cards.size, 52
  end
  
 
end




 

