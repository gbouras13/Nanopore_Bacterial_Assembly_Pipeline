#!/usr/bin/env python3

import pandas as pd

def summarise_contigs(assembly_info, genome_size, sample, assembly_cleaned_out, summary_out ):
    # read gff        

    colnames=['seq_name', 'length', 'cov', 'circ', 'repeat', 'mult', 'alt_group', 'graph_path'] 
    assembly_df = pd.read_csv(assembly_info, delimiter= '\t', index_col=False, header=None, names=colnames)
    #assembly_df = pd.read_csv('assembly_info.txt', delimiter= '\t', index_col=False, header=None, names=colnames)

    # remove first row (from the file)
    assembly_df = assembly_df.iloc[1: , :]

    # sample = 'C183'
    # add sample
    assembly_df['sample'] = sample

    # move sample to front 
    cols = assembly_df.columns.tolist()
    cols = cols[-1:] + cols[:-1]
    assembly_df = assembly_df[cols]

    assembly_df.to_csv(assembly_cleaned_out, sep=",", index=False, header=False)

    # Convert length to int
    assembly_df['length'] = assembly_df['length'].astype('int')

    # count contigs
    total_contigs = len(assembly_df.index)
    # get max contig size
    # need to convert to integer first
    max_contig = assembly_df["length"].max()
    print(max_contig)

    # covnert to int
    max_contig = int(max_contig)
    genome_size = int(genome_size)
    

    #expected genome size
    #genome_size = 2600000

    # determine whether complete assembly based on size of largest contig 
    complete_assembly = True

    if max_contig < genome_size:
        complete_assembly = False

    # determine plasmid count
    plasmid_count = 0

    if complete_assembly == True:
        plasmid_count = total_contigs - 1 

    d = {'Sample': [sample], 'total_contigs': [total_contigs], 'max_contig_size': [max_contig], 'complete_assembly': [complete_assembly], 'plasmid_count': [plasmid_count]}

    summary_df = pd.DataFrame(data=d)

    summary_df.to_csv(summary_out, sep=",", index=False)

        

summarise_contigs(snakemake.input[0], snakemake.params[0], snakemake.wildcards.sample,  snakemake.output[0], snakemake.output[1])




