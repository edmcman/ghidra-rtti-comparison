#!/usr/bin/env python

import re
import fileinput
import sys

thing = sys.argv[1]
regexnum = int(sys.argv[2])

regexes = [
    r"groundTruth\(([^,]*), .*, %s, .*\)." % thing,
    r"finalMethodProperty\((.*), %s, certain\)." % thing
]

regex = re.compile(regexes[regexnum])

for line in fileinput.input(sys.argv[3:]):
    m = re.match (regex, line)
    if m is not None:
        print(m.group(1))
