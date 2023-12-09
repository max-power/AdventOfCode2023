class Day
    def initialize(input=nil)
        @file = File.read(input || input_filename)
    end
    
    def day_number
        self.class.name.scan(/\d+/).first
    end

    def input_filename
        "day#{day_number}.txt"
    end

    def print_result(day, part, result)
        puts "Day #{day}, Part #{part}: #{result}"
    end
    
    def run!
        # puts "–" * 80
        public_methods.grep(/part_/).sort.each do |method_name|
            part_number = method_name.to_s.split('_').last
            print_result(day_number, part_number, public_send(method_name))
        end
    end
end