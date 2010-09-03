#!/usr/bin/perl

sub revcomp {
  my $dna = shift;
  my $revcomp = reverse($dna);
  $revcomp =~ tr/ACGTacgt/TGCAtgca/;
  return $revcomp;
}

# Simple Test
print revcomp("ACCGGtTT") . "\n";
