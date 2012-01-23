#!/usr/bin/perl -w
use strict;
use File::Spec;
use Bio::SeqIO;
use Getopt::Long;


my $home = $ENV{'HOME'};
my $jobdir = File::Spec->catfile($home,'jobs');
my $input  = File::Spec->catfile($home,'input');
my $outdir = File::Spec->catfile($home,'output');
my $tmpdir = File::Spec->catfile($home, 'tmp');
my $prefix = 'fsta';
my $qsize = 1000;
my ($query,$dbin,$params,$exe);
$exe = 'fasta36_t'; # default
$params = '-E 1e-3 -m 8C -H ';
GetOptions(
	   'i|q|query:s' => \$query,
	   'd|db:s'      => \$dbin,
	   'p|params:s'  => \$params,
	   's|size:i'    => \$qsize,
	   'e|exe:s'     => \$exe,
	   'indir|input:s'  => \$input,
	   'o|out|outdir:s' => \$outdir,
	   'j|job|jobdir:s' => \$jobdir,
	   't|tmp|tmpdir:s' => \$tmpdir,
	   );
die( "need a dbname\n" ) unless (defined $dbin );
my $db = File::Spec->rel2abs($dbin);
warn("db is $db\n");
die( "need an inputfile\n" ) unless defined $query && -e $query;
die( "need some params\n" ) unless defined $params;

for my $dir( $jobdir,$input,$outdir,$tmpdir ) {
    mkdir $dir unless -d $dir;
}

$query = File::Spec->rel2abs($query);
my (undef,undef,$query_file) = File::Spec->splitpath($query);
my $uid = $query_file;
my $in = Bio::SeqIO->new(-file   => $query,
			 -format => "fasta");

my ($ct,$setct) = (0,0);
my $infile = File::Spec->catfile($input,"$uid.$setct.fa");
my $input_seqfh = Bio::SeqIO->new(-format => 'fasta',
				  -file   => ">$infile");
				  
my @infiles = ($infile);
my @infilenames = ("$uid.$setct.fa");

while( my $s = $in->next_seq ) {
	next if $s->seq =~ /^[Xx]+$/;
    $input_seqfh->write_seq($s);
    if( ++$ct >= $qsize ) {
	$input_seqfh->close();
	$setct++;
	$infile = File::Spec->catfile($input,"$uid.$setct.fa");
	$input_seqfh = Bio::SeqIO->new(-format => 'fasta',
				       -file   => ">$infile");
	push @infiles, $infile;
	push @infilenames, "$uid.$setct.fa";
	$ct = 0;
    }
}


for( my $i = 0; $i <= $setct; $i++ ) {
    my $jobfile = File::Spec->catfile($jobdir,"$uid.$i.sh");
    open my $fh => ">$jobfile" || die $!;
    chmod(0700,$jobfile);
    my $ofile = File::Spec->catfile($outdir,"$uid.$i.output");
    my $out   = File::Spec->catfile($tmpdir,"$uid.$i.out");
    my $ifile = $infiles[$i];#File::Spec->catfile($wkdir,$infilenames[$i]);
    
    print $fh ( "#!/bin/bash\n",
		'#PBS'." -N $prefix.$i\n",
		"source ~/.bash_profile\n",
		);

    print $fh "$exe $params $ifile \"$db\" > $ofile\n";    
}

__END__

=head1 NAME

submit_blast_simple.pl - a script for submitting BLAST jobs for parallel submission by splitting the input into chunks

=head1 SYNOPSIS

submit_blast_simple.pl -i peptides.fa -d blast_database -s 1000

submit_blast_simple.pl -i queryscaffolds.fa -d genome -s 1000 --params "-p blastn -e 1e-5 -m 8"

=head1 DESCRIPTION

Assumes you will be running NCBI blast (blastall) and the default
parameter options are:

 -p blastp -e 1e-3 -m 8

It will create the directories
 ~/jobs ~/output ~/input

The job files will be saved in ~/jobs and you will submit them like

 for job in jobs/*.sh
 do
  qsub jobs/$job
 done

The output will be written to ~/output. When your jobs are done you
can safely remove the job files and input files saved in ~/jobs and
~/input respectively.


=head1 FEEDBACK

jason.stajich [at] ucr.edu

=cut
