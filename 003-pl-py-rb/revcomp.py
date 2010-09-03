#!/usr/bin/python
import string

def revcomp(seq): 
    t = string.maketrans('ATCGatcg', 'TAGCtagc')
    return seq.translate(t)[::-1]

# Simple Test
print revcomp("ACCGGtTT")
