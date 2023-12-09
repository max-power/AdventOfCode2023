Dir.glob("day[0-9]*.rb").each { require_relative _1 }

class AOC
    def self.run!
        puts "Advent of Code 2023 ".ljust(80, '–')
        Day.subclasses.sort_by(&:name).each(&:run!)
    end
end

at_exit { AOC.run! }