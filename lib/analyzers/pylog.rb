require 'analyzers.rb'
require 'pp'

# supported analysis
## freq_spikes - bg noise frequency spike finding

THRESHOLD = 0.0001

require 'descriptive_statistics'
require 'distribution'

module Analyzers
    class Pylog < Analyzer
        def initialize parsed, todo
            super
            
            def self.freq_spikes
                @parsed.bg_entries.each do |entry|
                    x = entry[:freqs].collect { |h| h['average'] }
                    y = entry[:freqs].collect { |h| h['frequency'] }
                    
                    s = x.standard_deviation
                    v = s * s
                    m = x.mean
                    
                    x.each_with_index do |pt, idx|
                        p = Distribution::Normal.pdf (pt - m)/s
                        if p < THRESHOLD
                            puts y[idx]
                        end
                    end
                    puts ""
                end
            end
            
            
        end
    end # class Pylog
end # module Analyzers
