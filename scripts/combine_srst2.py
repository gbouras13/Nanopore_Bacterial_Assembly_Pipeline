#!/usr/bin/env python3

import pandas as pd

# function to read the csv
def read_srst2_tsv(tsv):
    colnames=['Sample', 'ST', 'arcC', 'aroE', 'glpF', 'gmk', 'pta', 'tpi', 'yqiL', 'mismatches', 'uncertainty', 'depth', 'maxMAF'] 
    df = pd.read_csv(tsv, delimiter= '\t', index_col=False, header=True, names=colnames)
    # strip the * off the alleles with mismatches
    # https://stackoverflow.com/questions/68076116/python-replace-multiple-values-from-all-columns-in-dataframe-pandas
    df = df.replace({'*':'', "?": ""}, regex=True)
    return df




def summarise_contigs(summary_list, output, saureus):
    # read into list       
    summaries = []
    l =summary_list

    for a in l:
        tmp_summary = read_srst2_tsv(a)
        summaries.append(tmp_summary)

    # make into combined dataframe
    total_summary_df = pd.concat(summaries,  ignore_index=True)

    # merge s aureus into the summary df
    colnames=['ST', 'arcC', 'aroE', 'glpF', 'gmk', 'pta', 'tpi', 'yqiL', 'clonal_complex'] 
    saureus_df = pd.read_csv(saureus, delimiter= '\t', index_col=False, header=None, names=colnames)
    print(total_summary_df)
    # convert the locus to string for merge 
    saureus_df[['arcC', 'aroE', 'glpF', 'gmk', 'pta', 'tpi', 'yqiL']] = saureus_df[['arcC', 'aroE', 'glpF', 'gmk', 'pta', 'tpi', 'yqiL']].astype(str)
    # convert the total_summary_df 
    #total_summary_df['ST']=pd.merge(total_summary_df, saureus_df, how="left", on=['arcC', 'aroE', 'glpF', 'gmk', 'pta', 'tpi', 'yqiL']).ST
    total_summary_df['clonal_complex']=pd.merge(total_summary_df, saureus_df, how="left", on=['arcC', 'aroE', 'glpF', 'gmk', 'pta', 'tpi', 'yqiL']).clonal_complex
    total_summary_df = total_summary_df.fillna('Novel')
    total_summary_df.to_csv(output, sep=",", index=False)

     
summarise_contigs(snakemake.input.srst2s, snakemake.output.out, snakemake.params.saureus)




