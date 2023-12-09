require_relative 'day'

CubeGame = Data.define(:id, :color_groups) do
    def self.parse(line, regex=/(\d+)\s*(\w+)/)
        id, groups = line.split(':')
        groups = groups.scan(regex).map {|v,k| {k => v.to_i} }

        new(id[/\d+/].to_i, groups)
    end
    
    def rejectable?(target)
        max_seen_colors.any? { |color,count| count > target[color.to_sym] }
    end
    
    def max_seen_colors
        color_groups.each_with_object(Hash.new(0)) do |game, memo|
            game.each do |color, count|
                memo[color] = [memo[color], count.to_i].max
            end
        end
    end
end

class Day2 < Day
    def part_1
        #load_testfile # 2204
        target = { red: 12, green: 13, blue: 14 }
        games.reject { |game| game.rejectable?(target) }.sum(&:id)
    end
    
    def part_2
        #load_testfile # 71036
        games.sum { |game| game.max_seen_colors.values.inject(:*) }
    end

    private
    
    def games
        @file.each_line.map do |line|
            CubeGame.parse(line)
        end
    end

    def load_testfile
        @file = <<~EOS
          Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
          Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
          Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
          Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
          Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
        EOS
    end
end


Day2.run! if __FILE__ == $0