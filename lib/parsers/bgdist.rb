require 'parsers'
require 'csv'
require 'pp'

module Parsers
    class Bgdist < Parser
        attr_reader :data
        def initialize filename
            super
            
            colnames = (CSV.parse @lines[0]).flatten.reject {|x| x.nil?}
            colnames.collect! { |x| x.gsub /amp$/, 'amp_sf' }
            
            data = (CSV.parse @lines[1..-2].join).collect do |row|
                Hash[colnames.zip (row.reject {|x| x.nil?}).collect {|x| x.to_f}]
            end
            
            @data = data.reduce({}) {|h,pairs| pairs.each {|k,v| (h[k] ||= []) << v}; h}
        end
    end # class Bgdist
end # module Parsers

