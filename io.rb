module Aef
  module SugarIO
    MODE_SYMBOLS = [:read, :write, :truncate, :append, :binary, :text].freeze
  
    def parse_mode_symbols(modes)
      mode_string = ''
  
      if modes.include?(:binary) and modes.include?(:text)
        raise ArgumentError, ':binary and :text are mutually exclusive'
      else
        mode_string += 'b' if modes.include?(:binary)
        mode_string += 't' if modes.include?(:text)
      end
  
      if modes.include?(:write)
        
        if modes.include?(:truncate) and modes.include?(:append)
          raise ArgumentError, ':truncate and :append are mutually exclusive'
        end
        
        if modes.include?(:read)
          if modes.include?(:append)
            mode_string += 'a+' 
          else
            mode_string += 'w+'
          end
        else
          if modes.include?(:append)
            mode_string += 'a'
          else
            mode_string += 'w'
          end
        end
      else
        if modes.include?(:truncate)
          raise ArgumentError, ':truncate is only valid in conjunction with :write'
        end
        
        if modes.include?(:append)
          raise ArgumentError, ':append is only valid in conjunction with :write'
        end
      
        mode_string += 'r'
      end
    end
  
    def self.open(descriptor, *modes)
      mode_string = parse_mode_symbols(modes)
      
      puts "Descriptor: #{descriptor}"
      puts "Modes: #{modes}"
      puts "Mode-String: #{mode_string}"
      
      if modes.all?{|element| element.is_a?(Symbol)}
        open_old(descriptor, mode_string)
      end
  
      open_old(descriptor, *modes)
    end
  end
end
