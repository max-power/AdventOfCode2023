require_relative 'day'

Card = Data.define(:id, :winning_numbers, :selected_numbers) do
  def points
    matches? ? 2 ** (matches_count-1) : 0
  end

  def matches
    winning_numbers & selected_numbers
  end

  def matches?
    matches.any?
  end
  
  def matches_count
    matches.count
  end
  
  def inspect
    "Card(#{id})"
  end
end

class Day4 < Day
  def part_1
    cards.sum(&:points)
  end
  
  def part_2
    count_winning(cards).values.sum
  end
  
  private
  
  def cards
    @cards ||= @file.each_line.map do |line|
      id, number_sets   = line.split(':')
      winning, selected = number_sets.split('|').map { |set| set.scan(/\w+/).map(&:to_i) }
      id = id.gsub(/\D/, '').to_i
      Card.new(id, winning, selected)
    end
  end

  def count_winning(collection, counter=Hash.new(0))
    Array(collection).each_with_object(counter) do |card, counter|
      counter[card.id] += 1
      
      if card.matches?
        following_cards = cards[cards.index(card)+1, card.matches_count]
        following_cards.each do |c|
          count_winning(c, counter)
        end
      end
    end
  end
end


Day4.new.run!

# Day 4, Part 1: 24542
# Day 4, Part 2: 8736438


require 'tldr'
class Day4Test < TLDR
  def setup
    @inputs = <<~EOS
      Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
      Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
      Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
      Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
      Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
      Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
    EOS
  end
  
  def test_1
    card = Card.new([41,48,83,86,17], [83,86, 6,31,17,9,48,53])
        
    assert_equal [17, 48, 83, 86], card.matches.to_a.sort
    assert_equal 8, card.points
  end
  
  def test_2
    card = Card.new([13,32,20,16,61], [61,30,68,82,17,32,24,19])
  
    assert_equal 2, card.points
  end
  
  def test_3
    card = Card.new([1,21,53,59,44], [69,82,63,72,16,21,14,1])
    assert_equal 2, card.points
  end
  
  def test_5
    card = Card.new([87,83,26,28,32], [88,30,70,12,93,22,82,36])
    assert_equal 0, card.points
  end
end
