#!/usr/bin/env ruby

if ARGV.length != 3
    puts "usage: ./events-between.rb <file> <start> <stop>"
end

lines = IO.readlines ARGV.shift

min = ARGV.shift.to_i
max = ARGV.shift.to_i

lines.each do |line|
    # take care of line endings
    line.chomp!.chomp!
    
    a = line.match /([^;]+);(?:([^;]+);([^;]+);([^;]+);)?/
    
    case a[1]
    when 'h'
        puts line
    when 'p'
        puts line
    when 'e'
        if min <= a[4].to_i and max >= a[4].to_i
            puts line
        end
    when 'b'
        if min <= a[4].to_i and max >= a[4].to_i
            puts line
        end        
    else
        abort "unable to parse line: #{line}"    
    end
end
