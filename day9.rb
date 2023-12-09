require_relative 'day'

History = Struct.new(:values) do
  def next_value
    consecutive_differences.reduce(0) do |memo, (line1, line2)| 
      memo = memo + line2.last
    end
  end
  
  def prev_value
    consecutive_differences.reduce(0) do |memo, (line1, line2)|
      memo = line2.first - memo
    end
  end
  
  private
  
  def consecutive_differences
    differences.reverse.each_cons(2)
  end
  
  def differences
    [values].tap do |results|
      until results.last.all?(&:zero?)
        results << reduce_to_differences(results.last)
      end
    end
  end
  
  def reduce_to_differences(input)
    input.each_cons(2).map { |a,b| b-a }
  end
end

class Day9 < Day
  
  def part_1
    #load_testfile # 2075724761
    result :next_value
  end
  
  def part_2
    #load_testfile # 1072
    result :prev_value
  end
  
  private
  
  def result(method)
    @file.each_line.sum do |line|
      History.new(line.split.map(&:to_i)).send method
    end
  end
  
  def load_testfile
    @file = <<~EOS
      0 3 6 9 12 15
      1 3 6 10 15 21
      10 13 16 21 30 45
    EOS
  end
end

Day9.run! if __FILE__ == $0