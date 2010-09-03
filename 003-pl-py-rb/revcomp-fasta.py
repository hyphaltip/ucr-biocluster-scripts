#!/usr/bin/python
import sys
import string
from math import ceil

# Author: Eddie Cao

def revcomp(seq):  
    t = string.maketrans('ATCGatcg', 'TAGCtagc')
    return seq.translate(t)[::-1]

# Simple Test
# print revcomp("ACCGGtTT")

FASTA_LINE_WIDTH = 75

if len(sys.argv) != 2:
	sys.stderr.write(
"""USAGE: %(p)s forward.fasta > reverse.fasta
       or
       %(p)s <(echo -e \">dna1\\nACCGGtTT\")

This program reverse compliments DNA FASTA files.
Processing very large files is possible because
of streaming the input and output, as opposed to
storing DNA in memory.
""" % dict(p=sys.argv[0]))
	sys.exit(1)

INPUT_FILENAME = sys.argv[1]

# Print a string on multiple lines. Each line is X characters or less.
def print_wrapped_to(x, long_ln):
	print '\n'.join([
		long_ln[(x*i):(x*(i+1))]
		for i in range(int(ceil(len(long_ln)/float(x))))
	])

# Read FASTA from filename that was given
f = file(INPUT_FILENAME)
seq = ''
for line in f:
	line = line.strip()
	if line.startswith('>'):
		if seq: print_wrapped_to(FASTA_LINE_WIDTH, revcomp(seq))
		print line
		seq = ''
	else:
		seq += line

if seq: print_wrapped_to(FASTA_LINE_WIDTH, revcomp(seq))

f.close()
