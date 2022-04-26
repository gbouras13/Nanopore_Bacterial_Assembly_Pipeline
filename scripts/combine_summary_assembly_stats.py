#!/usr/bin/env python3

import pandas as pd

def summarise_contigs(summary_list, output):
    # read gff        

    colnames=['Sample', 'total_contigs', 'max_contig_size', 'complete_assembly', 'plasmid_count'] 

    summaries = []
    l =summary_list

    for a in l:
        tmp_gff = pd.read_csv(a, delimiter= ',', index_col=False, header=None, names=colnames)
        # remove first row (from the file)
        #tmp_gff = tmp_gff.iloc[1: , :]
        summary_list.append(tmp_gff)

    # make into combined dataframe
    total_summary_df = pd.concat(summaries,  ignore_index=True)
    total_summary_df.to_csv(output, sep=",", index=False)
        

summarise_contigs(snakemake.input.summaries, snakemake.output.out)




