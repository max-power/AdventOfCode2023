require_relative 'day'

PlayingCard = Data.define(:symbol, :deck) do
    include Comparable

    def self.to_proc
        Proc.new { |v| new(v) }
    end

    def to_i
        deck.index(symbol)
    end
    
    def <=>(other)
        self.to_i <=> other.to_i
    end
    
    def inspect
        symbol
    end
end

class Hand
    include Comparable
    
    attr_reader :cards, :bid
    
    def initialize(cards, bid, deck)
        @cards = cards.map { PlayingCard.new(_1, deck) }
        @bid   = bid.to_i
    end

    def strength
        cards.tally
    end
    
    def joker_strength
        hash   = strength
        jokers = hash.delete('J')
        key    = hash.max_by { |key,count| count }[0]
        hash[key] += jokers
        hash
    end
    
    def type
        #strength.values.max
        strength.values.sort.reverse
    end

    def <=>(other)
#        puts "#{self.inspect} (#{self.type}) - #{other.inspect} (#{other.type})"
        result = type <=> other.type
        return result unless result==0
        return cards <=> other.cards
    end
    
    def inspect
        "Hand#{cards}"
    end
end

Deck = Data.define(:lookup) do
    def value_for(card)
        lookup.index(card)
    end
end



class Day7 < Day
    def part_1(deck = %w(2 3 4 5 6 7 8 9 T J Q K A))
        load_testfile # 6440
        hands(deck).sort.map.with_index(1) { |hand, rank| hand.bid * rank }.sum
    end
    
    def part_2(deck = %w(J 2 3 4 5 6 7 8 9 T Q K A))
        load_testfile # 5905
        hands(deck).sort.map.with_index(1) { |hand, rank| hand.bid * rank }.sum
    end
    
    def part_3
        #Deck.new %w(2 3 4 5 6 7 8 9 T J Q K A)
        #Deck.new %w(J 2 3 4 5 6 7 8 9 T Q K A)
        deck = Deck.new %w(J 2 3 4 5 6 7 8 9 T Q K A)
        deck.value_for('Q')
    end
    
    def part_4
        hands(%w(J 2 3 4 5 6 7 8 9 T Q K A)).sort.inspect
    end
    
    private
    
    def hands(deck)
        @file.each_line.map do |line|
           hand, bid = line.split
           Hand.new(hand.chars, bid, deck)
        end
    end

    def load_testfile
        @file = <<~EOS
            32T3K 765
            T55J5 684
            KK677 28
            KTJJT 220
            QQQJA 483
        EOS
    end
end

# Part 1: 250898830
# Part 2: 

Day7.run! if __FILE__ == $0