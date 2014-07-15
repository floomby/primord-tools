#!/usr/bin/env ruby

require 'open3'
require 'csv'

#`/usr/lib/R/bin/R --slave --no-restore --file=./plot-fitted-bg.R --args ../stuff/Faraday_Cage_bkg_dist/a3_bkg_dist_20140625_180001.csv 6.9375 696.0586520466848`

#exit

lines = IO.readlines ARGV.shift

lines[1..-1].each do |line|
    a = (CSV.parse line)[0]
    if a[-1] == 'NA'; next end
    stdin, stdout, stderr = Open3.popen3 "/usr/lib/R/bin/R --slave --no-restore --file=./plot-fitted-bg.R --args ../stuff/Faraday_Cage_bkg_dist/#{a[0]} #{a[-2]} #{a[-1]}"
    sleep 4
    stdin.puts ""
end
