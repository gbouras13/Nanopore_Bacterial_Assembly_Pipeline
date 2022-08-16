#!/usr/bin/env python3

import pandas as pd

# function to read the csv
def read_mlst_csv(csv):
    colnames=['Sample', 'organism', 'ST', 'arcC', 'aroE', 'glpF', 'gmk', 'pta', 'tpy', 'yqiL'] 
    df = pd.read_csv(csv, delimiter= ',', index_col=False, header=None, names=colnames)
    # strip the other text off and remove > and ~
    df['arcC'] = df['arcC'].replace("arcC", "").str.strip("()").replace("?", "").replace("~", "")
    df['aroE'] = df['aroE'].replace("aroE", "").str.strip("()").replace("?", "").replace("~", "")
    df['glpF'] = df['glpF'].replace("glpF", "").str.strip("()").replace("?", "").replace("~", "")
    df['gmk'] = df['gmk'].replace("gmk", "").str.strip("()").replace("?", "").replace("~", "")
    df['pta'] = df['pta'].replace("pta", "").str.strip("()").replace("?", "").replace("~", "")
    df['tpy'] = df['tpy'].replace("tpy", "").str.strip("()").replace("?", "").replace("~", "")
    df['yqiL'] = df['yqiL'].replace("yqiL", "").str.strip("()").replace("?", "").replace("~", "")
    # drop organism and ST
    df = df.drop(['organism', 'ST'])
    return df


#/hpcfs/users/a1667917/Staph_Final_Assemblies/Complete_Assembly_Output/CHROMOSOME/SAV_17.fasta,saureus,-,arcC(~12),aroE(4),glpF(1),gmk(599?),pta(12),tpi(1),yqiL(3)


def summarise_contigs(summary_list, output, saureus):
    # read into list       
    summaries = []
    l =summary_list

    for a in l:
        tmp_summary = read_mlst_csv(a)
        summaries.append(tmp_summary)

    # make into combined dataframe
    total_summary_df = pd.concat(summaries,  ignore_index=True)

    # merge s aureus into the summary df
    colnames=['ST', 'arcC', 'aroE', 'glpF', 'gmk', 'pta', 'tpy', 'yqiL', 'clonal_complex'] 
    saureus_df = pd.read_csv(saureus, delimiter= '\t', index_col=False, header=None, names=colnames)
    total_summary_df['ST']=total_summary_df[['arcC', 'aroE', 'glpF', 'gmk', 'pta', 'tpy', 'yqiL']].merge(saureus_df,how='left').ST
    total_summary_df['clonal_complex']=total_summary_df[['arcC', 'aroE', 'glpF', 'gmk', 'pta', 'tpy', 'yqiL']].merge(saureus_df,how='left').clonal_complex
    total_summary_df = total_summary_df.fillna('Novel')
    total_summary_df.to_csv(output, sep=",", index=False)

     
summarise_contigs(snakemake.input.mlsts, snakemake.output.out, snakemake.params.saureus)




