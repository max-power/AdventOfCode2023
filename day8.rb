require_relative 'day'

class Network
    attr_reader :step_count
    
    def initialize(nodes, start: 'AAA', target: 'ZZZ')
        @nodes, @start, @target = nodes, start, target
        reset_count
    end
    
    def reset_count
        @step_count, @current = 0, @start
    end
    
    def navigate(instructions)
        reset_count
        until finished? do
            @current = next_node(instructions.next)
            @step_count += 1
        end
        self
    end
    
    def next_node(direction)
        @nodes[@current][direction]
    end
    
    def finished?
        @current == @target
    end
end


class Network_Part2
    
    attr_reader :step_count, :nodes, :current_nodes
    
    def initialize(nodes)
        @nodes = nodes
        @step_count = 0
        @current_nodes = starting_points
    end
    
    def starting_points
        @nodes.select { |name, node| name.end_with?('A') }.keys
    end

    def finished?
        current_nodes.all? { |node| node.end_with?('Z') }
    end

    def navigate(instruction)
        #current_nodes.reduce(:lcm)
        until finished? do
            puts "#{step_count} : #{current_nodes.inspect}"
            @current_nodes = @current_nodes.map { |key| @nodes[key][instruction.next] }
            @step_count += 1
        end
    end
end

class Day8 < Day
    def part_1
        #load_testfile # 18113

        instructions, nodes = prepare
        
        Network.new(nodes).navigate(instructions).step_count
    end
    
    def part_1_golf
        #load_testfile
        
        instructions, nodes = prepare
        current, step_count = 'AAA', 0
        
        until current == 'ZZZ' do
            current = nodes[current][instructions.next]
            step_count += 1
        end

        step_count
    end
    
    def p_art_2
        load_test_file2

        instructions, nodes = prepare
        
        network = Network_Part2.new(nodes)
        network.navigate(instructions)
        network.step_count
    end
    
    private
    
    def prepare
        instructions, lookup = @file.split(/\R\R/)
        
        instructions = instructions.chars.map {|i| i=='L' ? 0 : 1}.cycle
        
        network = lookup.each_line.each_with_object({}) do |line, memo|
            key, *values = line.scan(/\w+/)
            memo[key] = values
        end
        
        [instructions, network]
    end
    
    def load_testfile
        @file = <<~EOS
            LLR

            AAA = (BBB, BBB)
            BBB = (AAA, ZZZ)
            ZZZ = (ZZZ, ZZZ)
        EOS
    end
    
    def load_test_file2
        @file = <<~EOS
            LR

            11A = (11B, XXX)
            11B = (XXX, 11Z)
            11Z = (11B, XXX)
            22A = (22B, XXX)
            22B = (22C, 22C)
            22C = (22Z, 22Z)
            22Z = (22B, 22B)
            XXX = (XXX, XXX)
        EOS
    end
    
end

Day8.run! if __FILE__ == $0