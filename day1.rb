require_relative 'day'

class Day1 < Day
  NUMBERWORDS = %w(one two three four five six seven eight nine)

  def part_1(pattern = /\d/)
    @file.each_line.sum do |line| 
        create_number line.scan(pattern).flatten.map(&method(:replace_numberword))
    end
  end
  
  def part_2
      part_1(/(?=(#{NUMBERWORDS.join('|')}|[0-9]))/)
  end
  
  private

  def create_number(input)
      input.values_at(0,-1).join.to_i
  end
  
  def replace_numberword(word)
      NUMBERWORDS.index(word) + 1
  rescue
      word
  end
  
  private
  
  def load_testfile
     @file = <<~EOS
         two1nine
         eightwothree
         abcone2threexyz
         xtwone3four
         4nineeightseven2
         zoneight234
         7pqrstsixteen
     EOS
  end
end

Day1.run! if __FILE__ == $0