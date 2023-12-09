require_relative 'day'

Race = Data.define(:race_length, :winning_distance) do
    def distance_traveled(duration_of_press)
        (race_length - duration_of_press) * duration_of_press
    end
    
    def number_of_winning_combinations
        (1..race_length).count { |x| distance_traveled(x) > winning_distance }
    end
end


class Day6 < Day
    def part_1
        lengths, distances = @file.each_line.map { |line| line.split(/\s+/)[1..-1].map(&:to_i) }
        lengths.zip(distances).map { |l,d| race_combinations(l,d) }.inject(:*)
    end
    
    def part_2
        length, distance = @file.each_line.map { |line| line.split(/\s+/)[1..-1].join.to_i }
        race_combinations(length, distance)
    end
    
    private 

    def race_combinations(race_length, winning_distance)
        Race.new(race_length, winning_distance).number_of_winning_combinations
    end
end


Day6.run! if __FILE__ == $0

# Day6 - Part1: 625968
# Day6 - Part2: 43663323