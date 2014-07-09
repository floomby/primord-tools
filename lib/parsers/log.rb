require 'parsers'
require 'json'

module Parsers
    class Log < Parser
        attr_reader :header, :params
        def initialize filename
            super
            
            @lines.each do |line|
                case line[0]
                when 'h'
                    a = line.match /h;\({.*})/
                    @header = JSON.parse a[1]
                when 'p'
                    a = line.match /p;\({.*})/
                    @header = JSON.parse a[1]
                when 'b'
                when 'e'
                else
                    abort "#{@filename}: unable to parse line: #{line}"
                end
            end
        end
    end # class Log
end # module Parsers
