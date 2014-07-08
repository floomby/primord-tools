require 'date'

module Parsers
    class Parser
        attr_reader :sensor, :filename, :date, :nice_name
        def initialize filename
            @filename = File.basename filename
            @lines = IO.readlines filename
            # if the name is nice we can do nice things
            a = @filename.match /a([0-9]+)[a-zA-Z_]+([0-9]+(?:_[0-9]+)?)/
            @nice_name = !!a
            if @nice_name
                @sensor = a[1].to_i
                @date = DateTime.parse a[2]
            end
        end
    end # class Parser
end # module Parsers
