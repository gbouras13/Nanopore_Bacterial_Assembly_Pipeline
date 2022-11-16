#!/usr/bin/env python3

import pandas as pd

def summarise_contigs(summary_list, output):
    # read into list       
    summaries = []
    l =summary_list

    for a in l:
        tmp_summary = pd.read_csv(a, delimiter= '\t', index_col=False, header=0)
        # remove first row (from the file)
        summaries.append(tmp_summary)

    # make into combined dataframe
    total_summary_df = pd.concat(summaries,  ignore_index=True)
    total_summary_df.to_csv(output, sep=",", index=False)
        

summarise_contigs(snakemake.input.summaries, snakemake.output.out)




