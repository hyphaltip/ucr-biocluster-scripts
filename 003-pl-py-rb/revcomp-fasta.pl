#!/usr/bin/perl

# Author: Tyler Backman

sub revcomp {
  my $dna = shift; 
  my $revcomp = reverse($dna);
  $revcomp =~ tr/ACGTacgt/TGCAtgca/;
  return $revcomp;
}

use warnings;
use strict;

my $FASTA_LINE_WIDTH = 75;
if (@ARGV != 1) {
  print "USAGE: $0 forward.fasta > reverse.fasta\n" .
        "       or\n" .
        "       $0 <(echo -e \">dna1\\nACCGGtTT\")\n" .
        "\n" .
        "This program reverse compliments DNA FASTA files.\n" .
        "Processing very large files is possible because\n" .
        "of streaming the input and output, as opposed to\n" .
        "storing DNA in memory.\n";
  exit();
}

## Simple Test
#print revcomp("ACCGGtTT") . "\n";

# Print a string on multiple lines. Each line is X characters or less.
sub print_wrapped_to {
  my $x = shift;
  my $long_line = shift;
  my $line_out = "";

  my $length = length($long_line);
  my $count = 0;
  
  while (($x*$count) < $length)
  {
    my $temp = substr($long_line, ($x*$count), $x);
    $count++;
    print $temp . "\n";
  }
}

my $inFasta = $ARGV[0];
open(INFASTA, "< $inFasta");

my $sequence = "";

while(my $thisLine = <INFASTA>) {
    chomp($thisLine);
    if($thisLine =~ m/^>(.*)/) {
        if($sequence ne "") {
	    print print_wrapped_to($FASTA_LINE_WIDTH,revcomp($sequence)) 
        }
	$sequence = "";
        print ">$1\n";
    } else {
        $sequence = $sequence . $thisLine;
    }
}

# reverse complement sequence here
if($sequence ne "") {
  print print_wrapped_to($FASTA_LINE_WIDTH,revcomp($sequence)) 
}
close(INFASTA);
