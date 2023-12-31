require_relative 'timer'

class Day
    def self.run!
        new.run!
    end
    
    def initialize(filename=nil)
        @file = File.read(filename || default_filename)
    end
    
    def day_number
        self.class.name.scan(/\d+/).first
    end

    def default_filename
        "day#{day_number}.txt"
    end

    def print_result(day, part, result, time=nil)
        puts "Day #{day}, Part #{part}: #{result} | Run time: #{time} msec" 
    end
    
    def run!(pattern = /part_/)
        public_methods.grep(pattern).sort.each do |method_name|
            part_number = method_name.to_s.split('_').last
            result = nil
            run_time = Timer.time_it { 
                result = public_send(method_name)
            }
            print_result(day_number, part_number, result, run_time)
        end
    end
end
