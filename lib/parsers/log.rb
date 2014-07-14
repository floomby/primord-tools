require 'json'
require 'date'

require 'parsers'

require 'pp'

module Parsers
    class Log < Parser
        attr_reader :header, :params, :events
        def initialize filename
            super
            
            @events = {}
            @lines.each do |line|
                case line[0]
                when 'h'
                    a = line.match /h;(\{.*\})/
                    @header = JSON.parse a[1]
                when 'p'
                    a = line.match /p;(\{.*\})/
                    @header = JSON.parse a[1]
                when 'b'
                when 'e'
                    a = line.match /e;([^;]+); ?([^;]+); ?([^;]+); ?([^;]+); ?([^;]+); ?([^;]+)/
                    if !a; abort 'arent I bad at regex' end
                    date = DateTime.parse a[2].gsub(/([0-9]{2}:){2}[0-9]{2}/){ |match| "#{match}.#{a[4]}" }
                    if @events[date].nil?; @events[date] = { :pts => [] } end
                    @events[date][:pts].push :freq => a[1].to_f, :amp => a[5].to_f
                else
                    abort "#{@filename}: unable to parse line: #{line}"
                end
            end
        end
    end # class Log
end # module Parsers
