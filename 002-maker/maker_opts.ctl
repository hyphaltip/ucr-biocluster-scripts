#-----Genome (Required for De-Novo Annotation)
genome: afrC_sca.fa #genome sequence file in fasta format

#-----Re-annotation Options (Only Maker derived GFF3)
genome_gff: #re-annotate genome based on this gff3 file
est_pass:0 #use ests in genome_gff: 1 = yes, 0 = no
altest_pass:0 #use alternate organism ests in genome_gff: 1 = yes, 0 = no
protein_pass:0 #use proteins in genome_gff: 1 = yes, 0 = no
rm_pass:0 #use repeats in genome_gff: 1 = yes, 0 = no
model_pass:1 #use gene models in genome_gff: 1 = yes, 0 = no
pred_pass:0 #use ab-initio predictions in genome_gff: 1 = yes, 0 = no
other_pass:0 #passthrough everything else in genome_gff: 1 = yes, 0 = no

#-----EST Evidence (you should provide a value for at least one)
est: /home_stajichlab/agioti/RNA_data/PASA_afr_raw.assemblies.fasta #non-redundant set of assembled ESTs in fasta format (classic EST analysis)
est_reads: #unassembled nextgen mRNASeq in fasta format (not fully implemented)
altest: /home_stajichlab/agioti/RNA_data/neurospora_crassa_or74a__finished__10_transcripts.fasta #EST/cDNA sequence file in fasta format from an alternate organism
est_gff: #EST evidence from an external gff3 file
altest_gff: #Alternate organism EST evidence from a seperate gff3 file

#-----Protein Homology Evidence (you should provide a value for at least one)
protein:  /home_stajichlab/agioti/Proteins/SordClust0.9 #protein sequence file in fasta format
protein_gff:  #protein homology evidence from an external gff3 file

#-----Repeat Masking (leave values blank to skip)
model_org:Fungi#model organism for RepBase masking in RepeatMasker
repeat_protein:/opt/maker/data/te_proteins.fasta #a database of transposable element proteins in fasta format
rmlib: #an organism specific repeat library in fasta format
rm_gff: #repeat elements from an external gff3 file

#-----Gene Prediction Options
organism_type:eukaryotic #eukaryotic or prokaryotic. Default is eukaryotic
predictor:snap, augustus, genemark, est2genome #prediction methods for annotations (seperate multiple values by ',')
unmask:1 #Also run ab-initio methods on unmasked sequence, 1 = yes, 0 = no
snaphmm: /home_stajichlab/agioti/Models/SNAP/neurospora_crassa_7.length.hmm #SNAP HMM model 
gmhmm: /home_stajichlab/agioti/Models/GeneMarkS/afr-mod #GeneMark HMM model
augustus_species: neurospora_crassa #Augustus gene prediction model
fgenesh_par_file: #Fgenesh parameter file
model_gff: #gene models from an external gff3 file (annotation pass-through)
pred_gff: #ab-initio predictions from an external gff3 file

#-----Other Annotation Type Options (features maker doesn't recognize)
other_gff: #features to pass-through to final output from an extenal gff3 file

#-----External Application Specific Options
alt_peptide:C #amino acid used to replace non standard amino acids in blast databases
cpus:1 #max number of cpus to use in BLAST and RepeatMasker

#-----Maker Specific Options
evaluate:0 #run Evaluator on all annotations, 1 = yes, 0 = no
max_dna_len:1000000 #length for dividing up contigs into chunks (larger values increase memory usage)
min_contig:100 #all contigs from the input genome file below this size will be skipped
min_protein:10 #all gene annotations must produce a protein of at least this many amino acids in length
softmask:1 #use soft-masked rather than hard-masked seg filtering for wublast
split_hit:800 #length for the splitting of hits (expected max intron size for evidence alignments)
pred_flank:200 #length of sequence surrounding EST and protein evidence used to extend gene predictions
single_exon:1 #consider single exon EST evidence when generating annotations, 1 = yes, 0 = no
single_length:250 #min length required for single exon ESTs if 'single_exon is enabled'
keep_preds:0 #Add non-overlapping ab-inito gene prediction to final annotation set, 1 = yes, 0 = no
map_forward:0 #try to map names and attributes forward from gff3 annotations, 1 = yes, 0 = no
retry:1 #number of times to retry a contig if there is a failure for some reason
clean_try:0 #removeall data from previous run before retrying, 1 = yes, 0 = no
clean_up:0 #removes theVoid directory with individual analysis files, 1 = yes, 0 = no
TMP: /scratch/maker-alex/#specify a directory other than the system default temporary directory for temporary files

#-----EVALUATOR Control Options
side_thre:5
eva_window_size:70
eva_split_hit:1
eva_hspmax:100
eva_gspmax:100
enable_fathom:0
