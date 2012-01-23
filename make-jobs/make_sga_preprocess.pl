#!/usr/bin/perl 
use warnings;
use strict;
use File::Spec;
my $dir = shift || die $!;
$dir = File::Spec->rel2abs($dir);
my %set;
opendir(DIR,$dir)|| die "$dir: $!";
for my $file ( readdir(DIR) ) {
  next unless $file =~ /(\S+)\.(fastq|fq)/;
  my $stem = $1;
  if( $stem =~ /(\S+)_p(?:air)?([12])$/ ) {
	$set{$1}->{$2} = $file;
  } elsif( $stem =~ /(\S+)_([12])$/) {
	$set{$1}->{$2} = $file;
  } elsif( $stem =~ /(\S+)_([fr])$/) {
	my $ba = $1;
	my $to = $2;
	$to =~ tr/fr/12/;
	$set{$ba}->{$to} = $file;	
  } else {
	$set{$stem}->{0} = $file;
  }
}

for my $set ( keys %set ) {
open( my $outfh => ">$set.preprocess.sh") || die $!;
 print $outfh "#PBS -N $set -l nodes=1:ppn=1\n";
 print $outfh "#PBS -d $dir\n";
 if( exists $set{$set}->{0} )  {
   printf $outfh "sga preprocess -o %s.pp.fastq --pe-mode 0 --quality-trim=20 -f 5 %s\n",$set,$set{$set}->{0};
 } else {
  printf $outfh "sga preprocess -o %s.pp.fastq --pe-mode 1 --quality-trim=20 -f 5 %s %s\n",$set,$set{$set}->{1},$set{$set}->{2};
 }
}
