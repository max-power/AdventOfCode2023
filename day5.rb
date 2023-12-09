require_relative 'day'

Map = Struct.new(:target_start, :source_start, :length) do
    attr_reader :source, :target
    def initialize(target_start, source_start, length)
        super
        @source = (source_start..source_start+length)
        @target = (target_start..target_start+length)
    end
    
    def cover?(n)
        @source.cover? n
    end
    
    def self.from_string(str)
        Map.new(*str.scan(/\d+/).map(&:to_i))
    end
    
    def inspect
        "Map#{deconstruct}"
    end
    
    def table
        #@table ||= @source.zip(@target).to_h
    end
    
    def destination(seed)
        return seed unless @source.cover?(seed)
        @target.begin - @source.begin + seed
#        table[seed]
#        table.fetch(seed, seed)
    end
end

class GardenMap
    ORDER = %w(seed soil fertilizer water light temperature humidity location).each_cons(2).map do |a,b|
       "#{a}-to-#{b}"
    end

    def initialize(name, maps)
        @name = name
        @maps = maps
    end

    def lookup(source)
        #this works correct, but slow
        # big_table = @maps.map(&:table).reduce({}, :merge!).sort_by{|k,v|k}.to_h
        # result    = big_table.fetch(source, source)
        #
        # print_lookup result
        # return result
          # this doen't return cirreect reesult
        result=@maps.sort_by{|m|m.target.first}.reduce(source) do |memo, map|
            map.destination(memo)
        end

        print_lookup result
    end
    
    private
    
    def print_lookup(result)
#        puts "#{map_name_ljust} #{result}"
        result
    end
    
    def map_name_ljust(spacer=26)
        "#{@name} ".ljust(spacer, '–')
    end
end


class Day5 < Day
    def part_1
        load_testfile
        seeds, maps = parse_data(@file)
        seeds.map { lookup_location(maps, _1) }.min
    end
    
    private
    
    def lookup_location(maps, seed)
#        puts
#        puts "Seed ".upcase.ljust(26, '=') + " #{seed}"
        GardenMap::ORDER.reduce(seed) do |memo, name|
            maps[name].lookup(memo)
        end
    end
    
    
    def parse_data(data)
        seeds, *sections = data.split(/\R\R/)
        seeds = seeds.scan(/\d+/).map(&:to_i)
        maps = sections.each_with_object({}) do |section, memo|
            title, numbers = section.split(' map:')
            maps = numbers.strip.split(/\R/).map { |x| Map.from_string(x) }
            memo[title] = GardenMap.new(title, maps)
        end
        [seeds, maps]
    end

    def load_testfile
        @file = <<~EOS
            seeds: 79 14 55 13

            seed-to-soil map:
            50 98 2
            52 50 48

            soil-to-fertilizer map:
            0 15 37
            37 52 2
            39 0 15

            fertilizer-to-water map:
            49 53 8
            0 11 42
            42 0 7
            57 7 4

            water-to-light map:
            88 18 7
            18 25 70

            light-to-temperature map:
            45 77 23
            81 45 19
            68 64 13

            temperature-to-humidity map:
            0 69 1
            1 0 69

            humidity-to-location map:
            60 56 37
            56 93 4
        EOS
    end
end

Day5.run! if __FILE__ == $0