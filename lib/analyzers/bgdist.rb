require 'analyzers'
require 'pp'

class Fixnum
    def factorial; (1..self).reduce(:*) || 1 end
end # class Fixnum

class Optimize
    attr_reader :at
    def initialize p, d, over, start, deltas
        @deltas = deltas
        @over = over
        @p = p
        @d = d
        @at = start

        @at.collect! { |x| x.to_i }
        @deltas.collect! { |x| x.to_i }
        #@dyn_prog = {}
        
        def self.sqrd *args
            #@dyn_prog[args] ||= ( (@over.collect {|x| ((args[0].call x) - (args[1].call x)) ** 2 }).reduce :+ )
            ( (@over.collect {|x| ((args[0].call x) - (args[1].call x)) ** 2 }).reduce :+ )
        end
        
        def self.estimate_grad at
            vals = {}
            ((-1..1).to_a.product (-1..1).to_a).each { |x| vals[x] = sqrd lambda { |t| @p.call at[0] + x[0] * @deltas[0], at[1] + x[1] * @deltas[1], t }, @d }
            vals
        end

        def self.do_itr
            m = nil
            while m != [0, 0]
                m = [0, 0]
                v = estimate_grad @at
                ((-1..1).to_a.product (-1..1).to_a).each { |k| a = v[[0,0]]; if v[k] < a; a = v[k]; m = k; end }
                @at.each_with_index { |a, i| @at[i] = a + @deltas[i] * m[i] }
                if @at[1].to_i <= 0; raise 'failed to converge' end
            end
        end
        
        do_itr
        
        @at.collect! { |x| x.to_f }
        @deltas.collect! { |x| x.to_f }

        
        5.times do
            do_itr
            @deltas.collect! { |x| x / 2 }
        end
    end
end # class Optimize

module Analyzers
    class Bgdist < Analyzer
        def initialize parsed, todo
            super
            
            @thr = 0
            idx = 0
            while @parsed.data['N_avg_amp_sf'][@thr] < 0.5
                @thr += 1
            end
            
            @distr = {}
            @distr[:thr] = @parsed.data['avg_amp_sf'][@thr]
            def self.dist
                if (@parsed.data['N_avg_amp_sf'].reduce :+) < 10
                    $stderr.puts "#{@parsed.filename}: failed to converge"
                    @distr[:mu] = NA
                    return @distr
                end
                
                p = lambda { |l,s,k|  (k > @thr) ? l ** k * Math::E ** -l / k.factorial * s : 0 }
                d = lambda { |k| v = @parsed.data['N_avg_amp_sf'][k]; v }
                begin
                    a = Optimize.new p, d, (0..@parsed.data['N_avg_amp_sf'].length - 1),
                        [5, 1000 * Math.log(@parsed.data['N_avg_amp_sf'].reduce :+)],
                        [1, 10 + 50 * Math.log((@parsed.data['N_avg_amp_sf'].reduce :+) * 2)]
                rescue StandardError => e
                    $stderr.puts "#{@parsed.filename}: failed to converge"
                    @distr[:mu] = NA
                    return @distr
                end
                #@distr[:lambda] = a.at[0]
                #@distr[:scale] = a.at[1]
                @distr[:mu] = (a.at.reduce :*)/(@parsed.data['avg_amp_sf'][0..1].reverse.reduce :-)
                @distr
            end
        end
    end # class Bgdist
end # module Analyzers
