#!/usr/bin/python

import re
import sys

if len(sys.argv) != 4:
    sys.exit("usage: ./events-between.py <file> <start> <stop>")

f = open(sys.argv[1])
for line in f.readlines():
    line = line.strip()
    if line[0] == 'h' or line[0] == 'p':
        print line
    elif line[0] == 'e' or line[0] == 'b':
        m = re.match(r'(?:[^;]+;){3}([^;]+);', line)
        if int(sys.argv[2]) <= int(m.group(1)) and int(sys.argv[3]) >= int(m.group(1)):
            print line
    else:
        sys.exit("unable to parse line %s" % line)
f.close()
