require 'minitest/autorun'

  
 #-----------------------------------------------------------------------------
 #REZ(16.08) - Class CARD defines the card tht is to be used in the class DECK.
 #-----------------------------------------------------------------------------
class Card 
  attr_accessor :suite, :name, :value

  def initialize(suite, name, value)
    @suite, @name, @value = suite, name, value
  end
  
  def value
    return 10 if ["J","Q","K"].include?(@value)
    return 11 if @value == "A"
    return @value
  end
  
  def to_s
    "#{@name}-#{@suite}"
  end
end


#---------------------------------------------------------------------------------
#REZ(16.08) - Class DECK defines the deck of cards that is to be used in the game.
#---------------------------------------------------------------------------------
class Deck
  attr_accessor :playable_cards
  SUITES = [:hearts, :diamonds, :spades, :clubs]
  NAME_VALUES = {
    :two   => 2,
    :three => 3,
    :four  => 4,
    :five  => 5,
    :six   => 6,
    :seven => 7,
    :eight => 8,
    :nine  => 9,
    :ten   => 10,
    :jack  => 10,
    :queen => 10,
    :king  => 10,
    :ace   => 11}								#REZ(16/08) - changed :ace => [11,1] to :ace => 11. Not sure how to handle
    										#		this scenario and need to investigate, Handles the :ace
    										#		situation in Hand.value method.

  def initialize
    shuffle
  end

  #-------------------------------------------------------------------
  #REZ(16.08) - Method DEAL_CARD deals a card randomly from the deck 
  #		and then deletes it from playable_cards.
  #-------------------------------------------------------------------
  def deal_card
    random = rand(@playable_cards.size)
    @playable_cards.delete_at(random)
  end

  #-------------------------------------------------------------------
  #REZ(16.08) - Method SHUFFLE creates the 52 cards by suit and value 
  #		within the suit.
  #-------------------------------------------------------------------
  def shuffle
    @playable_cards = []
    SUITES.each do |suite|
      NAME_VALUES.each do |name, value|
        @playable_cards << Card.new(suite, name, value)
      end    
    end
    puts "PLAYABLE CARDS"
  end
end


#------------------------------------------------------------------------------
#REZ(16.08) - Class HAND collects the cards that constitute what the player and
#		the dealer are using to play their hands.
#-------------------------------------------------------------------------------
class Hand
  attr_accessor :cards

  def initialize
    @cards = []
  end
  
  def hit!(deck)
    @cards << deck.deal_card
  end
  
  
    #----------------------------------------------------------------
    #REZ(16/08)	Method VALUE calculates the value of a hand of cards
    #         - Since I was not sure how to handle the single 
    #----------------------------------------------------------------
  def value         
    value =  0
    @cards.each do |card|
      value += card.value
    end
      if value > 21
        value = 0
        @cards.each do |card|
          if card.value == 11
            value += 1
          else
            value += card.value
          end
        end
      end
    value
  end
  
  #-------------------------------------------------------------
  #REZ (16/08)- Method PLAY_AS_DEALER deals cards to dealer
  #		until hand is 17 or greater after player stands.
  #-------------------------------------------------------------
  def play_as_dealer(deck)
    if value < 17
      hit!(deck)
      play_as_dealer(deck)
    else
      puts "Dealer Total is #{value}"
    end
  end
end

#---------------------------------------------------------------------
#REZ(16/08) - Game class creates a game between a player and a dealer
#---------------------------------------------------------------------
class Game

attr_accessor :player_hand, :dealer_hand

  #REZ(16/08) - Game is initialized by creating the Deck of Cards, the 
  #		players hand, and the dealers hand. It then deals two 
  #		cards to the player and the dealer. If the player get 
  #		21 points with 2 cards then they win BLACKJACK
  #-------------------------------------------------------------------
  def initialize
    puts "Dealing Gsme"
    @deck = Deck.new	
    @player_hand = Hand.new
    @dealer_hand = Hand.new
    2.times {@player_hand.hit!(@deck)}
    2.times {@dealer_hand.hit!(@deck)}
    
    if @player_hand.value == 21
      puts "BLACKJACK, You win!!"
      :player
    end
    if @dealer_hand.value == 21
      puts "Dealer has BLACKJACK"
      :dealer
    end
  end
  
  def hit
    @player_hand.hit!(@deck)
  end

#--------------------------------------------------------------  
#REZ(16/08) - Method Stand  When player stands, game play 
#		switches to deal cards only to the dealer.
#--------------------------------------------------------------
  def stand
    puts "Player Standing"
    @dealer_hand.play_as_dealer(@deck)
    puts "Dealer hand = #{@dealer_hand.value}"
    @winner = determine_winner(@player_hand.value, @dealer_hand.value)
  end
#------------------------------------------------------------------
#REZ(16/08) - Status used to display the status of 
#		the dealer hand, player hand and game.
#------------------------------------------------------------------
  def status
     
    {:player_cards => @player_hand.cards,
     :player_value => @player_hand.value,
     :dealer_cards => @dealer_hand.cards,
     :dealer_value => @dealer_hand.value,
     :winner => @winner}
       if @player_hand.value > 21 or @dealer_hand.value > 21
              @winner = determine_winner(@player_hand.value, @dealer_hand.value)       
              puts "BUSTED"
              puts "player-value = #{@player_hand.value}"
              puts "dealer-value = #{@dealer_hand.value}"
              puts "winner is #{@winner}"
       else
         #puts "player-cards = #{@player_hand.cards}"
         #puts "dealer-cards = #{@dealer_hand.cards}"
         puts "player-value = #{@player_hand.value}"
         puts "dealer-value = #{@dealer_hand.value}"   
       end
   end
    

#-------------------------------------------------------------------------
#REZ(16.08) - Method determine_winner determines the winner of the hand
#	    - based on the value of both player and dealer cards.
#	    - If either player or dealer value exceeds 21 program declares
#	    - that their hand is declared bust and the other is the winner.
#--------------------------------------------------------------------------
   def determine_winner(player_value, dealer_value)
     if player_value > 21 and dealer_value <= 21
       puts "Player Busts"
       return :dealer
     end
     if dealer_value > 21 and player_value <= 21
       puts "Dealer Busts"
       return :player
     end
     if player_value == dealer_value
       :push
     elsif player_value > dealer_value
       :player
     else
       :dealer
     end
   end
   
   def inspect
     status
   end
   
end






#game = Game.new
#answer = ''
#until answer == 'no'
#puts "Do you want to hit"
#answer = gets.chomp
#if answer == 'yes'
#game.hit
#puts " Player hand = "#{hand.value}"
#else
#game.stand
#end
#game.status
#end
