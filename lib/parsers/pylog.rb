require 'pp'
require 'parsers'

module Parsers
    class Pylog < Parser
        attr_reader :bg_entries
        def initialize filename
            super
            @line_idx = 0
            
            @bg_entries = []
            
            def self.background col_names
                freqs = []
                while !(@lines[@line_idx] =~ /^ *$/) do
                    freqs << Hash[col_names.zip (@lines[@line_idx].scan /[^ ]+/).map { |x| x.to_f }]
                    @line_idx += 1
                end
                
                a = nil
                until (a = @lines[@line_idx].match /[a-zA-Z ]+:(.*)/) do
                    @line_idx += 1
                end
                @bg_entries << { date: (DateTime.parse a[1]), freqs: freqs }
            end
            
            while @line_idx < @lines.length
                a = @lines[@line_idx].match /^([a-z]+), *([a-z]+), *([a-z]+), *([a-z]+), *([a-z]+), *([a-z]+) *$/
                if a
                    @line_idx += 1
                    background a[1..-1]
                end
                @line_idx += 1
            end
            
            #pp @bg_entries
        end
    end # class Pylog
end # module Parsers
