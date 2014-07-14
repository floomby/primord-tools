#!/usr/bin/env ruby

require 'pp'
require 'json'
require 'csv'

$:.unshift File.join (File.dirname __FILE__), 'lib'

require 'parsers/pylog'
require 'analyzers/pylog'
require 'parsers/bgdist'
require 'analyzers/bgdist'

puts "filename,mu,threshold"
ARGV.each do |fn|
    p = Parsers::Bgdist.new fn
    a = Analyzers::Bgdist.new p, {}
    v = a.dist
    puts "#{p.filename},#{v[:mu]},#{v[:thr]}"
end
