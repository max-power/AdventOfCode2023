require_relative 'day'

class Day3 < Day
    def part_1
        #@file.each_line do |l|
            #puts l
        #end

#        @file.scan(/\d+/).map(&:to_i).inspect
    end
    
    def part_2
        load_testfile
    end
    
    private
    
    def load_testfile
        @file = <<~EOS
            467..114..
            ...*......
            ..35..633.
            ......#...
            617*......
            .....+.58.
            ..592.....
            ......755.
            ...$.*....
            .664.598..
        EOS
    end
end

Day3.run! if __FILE__ == $0
