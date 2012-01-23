#!/usr/bin/perl 
use warnings;
use strict;
use File::Spec;
my $dir = shift || die $!;
my $group = shift || "HEG4";
$dir = File::Spec->rel2abs($dir);
my %set;
opendir(DIR,$dir)|| die "$dir: $!";
for my $file ( readdir(DIR) ) {
  next unless $file =~ /(\S+)\.fastq/;
  my $stem = $1;
  if( $stem =~ /(\S+)_p(?:air)?([12])$/ ) {
	$set{$1}->{$2} = $file;
  } else {
	$set{$stem}->{0} = $file;
  }
}

for my $set ( keys %set ) {
open( my $outfh => ">$set.mosaikbuild.sh") || die $!;
 print $outfh "#PBS -N $set.build -l nodes=1:ppn=1\n";
 print $outfh "#PBS -d $dir\n";
 print $outfh "export MOSAIK_TMP=\$HOME/bigdata/tmp\n";
 if( exists $set{$set}->{0} )  {
   printf $outfh "MosaikBuild -cn UCR -ds Rice$group -id $set -ln $set -mfl 100 -sam $group -st illumina -out %s.dat -q %s\n",$set,$set{$set}->{0};
 } else {
   printf $outfh "MosaikBuild -cn UCR -ds Rice$group -id $set -ln $set -mfl 100 -sam $group -st illumina -out %s.dat -q %s -q2 %s\n",$set,$set{$set}->{1},$set{$set}->{2};
 }
}
