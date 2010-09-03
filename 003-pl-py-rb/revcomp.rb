#!/usr/bin/ruby

def revcomp(dna)
  dna.tr('ATCGatcg', 'TAGCtagc').reverse
end

# Simple Test
puts revcomp("ACCGGtTT")
