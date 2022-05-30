#!/usr/bin/env python3

from Bio import SeqIO

def parse_fastas( input_fasta, chromosome_fasta, plasmid_fasta):
    # read in the fasta
    with open(chromosome_fasta, 'w') as fa:
        for dna_record in SeqIO.parse(input_fasta, "fasta"):
            if dna_record.id == "contig_1":
                SeqIO.write(dna_record, fa, 'fasta')
    with open(plasmid_fasta, 'w') as fa:
        for dna_record in SeqIO.parse(input_fasta, "fasta"):
            if dna_record.id != "contig_1":
                SeqIO.write(dna_record, fa, 'fasta')
            
parse_fastas(snakemake.input[0],snakemake.output[0], snakemake.output[1])



        
