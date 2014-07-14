require 'parsers/log'

require 'pp'

# TODO - there are optimizations that should be made because
#   javascript dates do not handle nanoseconds, only miliseconds
#   The correct approach is to use two timelines, one for the macro scale
#   and one for detailed data down to the nanosecond

# TODO - optimize thing seriously, both computational and memory usage

class DataSet
    attr_reader :header, :cats
    def initialize files
        parsed = files.collect { |file| Parsers::Log.new file }
        @cats = @cat_dates = {}
        @clumps = {}
        
        (1..4).each { |c| @cats[c] = [] }
        
        parsed.each do |p|
            p.events.each do |k, v|
                @cats[p.sensor] << ({ :date => k }.merge v)
            end
        end
        
        @cats.each do |k, v|
            @cat_dates[k] = v.collect { |h| h[:date] }
            @cat_dates[k].sort!
        end
        
        @header = {}
        @header[:time_max] = (((1..4).collect { |c| @cat_dates[c].max }).reject { |x| x.nil? }).max.strftime '%Q'
        @header[:time_min] = (((1..4).collect { |c| @cat_dates[c].min }).reject { |x| x.nil? }).min.strftime '%Q'
        @header[:categories] = [1, 4]
        
        def self.resolution res
            date_clumps = {}
            @cat_dates.each do |cat, dates|
                date_clumps[cat] = []
                while !dates.empty? do
                    date_clumps[cat] << (dates.select { |d| ((d.strftime '%N').to_i - (dates[0].strftime '%N').to_i) < res })
                    dates = dates.reject { |d| ((d.strftime '%N').to_i - (dates[0].strftime '%N').to_i) < res }
                end
            end
            date_clumps
        end
    end
end # class DataSet
 
