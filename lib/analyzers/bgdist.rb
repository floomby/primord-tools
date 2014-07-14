require 'analyzers'
require 'pp'

class Fixnum
    def factorial; (1..self).reduce(:*) || 1 end
end # class Fixnum

class Optimize
    attr_reader :at
    @@dirs = (-1..1).to_a.product (-1..1).to_a
    
    def initialize p, d, over, start, deltas
        @deltas = deltas
        @over = over
        @p = p
        @d = d
        @at = start
        
        @at.collect! { |x| x.to_f }
        @deltas.collect! { |x| x.to_f }

        def self.sqrd *args
            ( (@over.collect {|x| ((args[0].call x) - (args[1].call x)) ** 2 }).reduce :+ )
        end
        
        def self.estimate_grad at
            vals = {}
            @@dirs.each { |x| vals[x] = sqrd (@p.curry[at[0] + x[0] * @deltas[0]][at[1] + x[1] * @deltas[1]]), @d }
            vals
        end

        def self.do_itr
            m = nil
            while m != [0, 0]
                m = [0, 0]
                v = estimate_grad @at
                @@dirs.each { |k| if v[k] < v[[0,0]]; m = k; break; end }
                (0..1).each { |i| @at[i] += @deltas[i] * m[i] }
                if @at[1].to_i <= 0; raise 'failed to converge' end
                #pp @at
            end
        end
        
        
        #2.times do
        #    do_itr
        #    @deltas.collect! { |x| x / 2 }
        #end
        #
        #@at.collect! { |x| x.to_f }
        #@deltas.collect! { |x| x.to_f }
        
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
            while !@parsed.data['N_avg_amp_sf'][@thr].nil? and @parsed.data['N_avg_amp_sf'][@thr] < 0.5
                @thr += 1
            end
            
            @distr = {}
            @distr[:thr] = @parsed.data['avg_amp_sf'][@thr] || 'NA'
            @distr[:lambda] = 'NA'
            @distr[:scale] = 'NA'
            def self.dist
                if (@parsed.data['N_avg_amp_sf'].reduce :+) < 10
                    $stderr.puts "#{@parsed.filename}: failed to converge"
                    @distr[:mu] = 'NA'
                    return @distr
                end
                
                p = lambda { |l,s,k|  (k > @thr) ? l ** k * Math::E ** -l / k.factorial * s : 0 }
                d = lambda { |k| v = @parsed.data['N_avg_amp_sf'][k]; v }
                begin
                    a = Optimize.new p, d, (0..@parsed.data['N_avg_amp_sf'].length - 1),
                        [5, 1000 + (@parsed.data['N_avg_amp_sf'].reduce :+) ** 0.5],
                        [1, (@parsed.data['N_avg_amp_sf'].reduce :+)]
                rescue StandardError => e
                    $stderr.puts "#{@parsed.filename}: failed to converge"
                    @distr[:mu] = 'NA'
                    return @distr
                end
                @distr[:lambda] = a.at[0]
                @distr[:scale] = a.at[1]
                @distr[:mu] = a.at[0] * a.at[1] / (@parsed.data['avg_amp_sf'][1] - @parsed.data['avg_amp_sf'][0])
                @distr
            end
        end
    end # class Bgdist
end # module Analyzers
