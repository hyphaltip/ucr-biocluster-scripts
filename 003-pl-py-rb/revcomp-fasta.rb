#!/usr/bin/ruby

# Author: Alex Levchuk

def revcomp(dna)
  dna.tr('ATCGatcg', 'TAGCtagc').reverse
end

## Simple Test
#puts revcomp("ACCGGtTT")

FASTA_LINE_WIDTH = 75

if ARGV.size != 1
  STDERR.puts ["USAGE: #{__FILE__} forward.fasta > reverse.fasta",
              "       or",
              "       #{__FILE__} <(echo -e \">dna1\\nACCGGtTT\")",
              "",
              "This program reverse compliments DNA FASTA files.",
              "Processing very large files is possible because",
              "of streaming the input and output, as opposed to",
              "storing DNA in memory."].join("\n")
  exit
end

INPUT_FILENAME = ARGV[0]

# Print a string on multiple lines. Each line is X characters or less.
def print_wrapped_to(x, long_ln)
  (long_ln.size / x + 1).times {|i| puts long_ln.slice((i*x)..((i+1)*x -1))}
end

# Read FASTA from filename that was given
seq = ""
File.open(INPUT_FILENAME) do |f|
  while line_in = f.gets
    line_in.chomp!
  
    if line_in =~ /^>/
      # Print (to STDOUT) the Reverse complement of the current sequence
      print_wrapped_to(FASTA_LINE_WIDTH, revcomp(seq)) unless seq.empty?
  
      # Print next header
      puts(line_in)
  
      seq = ""
    else
      # Aggregate FASTA lines into 1 sequence
      seq = seq + line_in
    end
  end
end

# Print Reverse complement of the last sequence
print_wrapped_to(FASTA_LINE_WIDTH, revcomp(seq))
