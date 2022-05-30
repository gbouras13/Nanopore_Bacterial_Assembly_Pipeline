#!/usr/bin/env python3

from Bio import SeqIO

# get chromosome if length > 2.5 million

def parse_fastas( input_fasta, chromosome_fasta, plasmid_fasta, min_chrom_length):
    # read in the fasta
    with open(chromosome_fasta, 'w') as fa:
        for dna_record in SeqIO.parse(input_fasta, "fasta"):
            if len(dna_record.seq) > min_chrom_length:
                SeqIO.write(dna_record, fa, 'fasta')
    with open(plasmid_fasta, 'w') as fa:
        for dna_record in SeqIO.parse(input_fasta, "fasta"):
            if len(dna_record.seq) < min_chrom_length:
                SeqIO.write(dna_record, fa, 'fasta')
            
parse_fastas(snakemake.input[0],snakemake.output[0], snakemake.output[1], snakemake.params[0])



        
