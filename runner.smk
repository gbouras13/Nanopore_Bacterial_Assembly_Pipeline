"""
The snakefile that runs the pipeline.
Manual launch example:

snakemake -c 1 -s runner.smk --use-conda --config Fastqs=/Users/a1667917/Documents/S_Nanopore_Bacteria_Seq/aggregated_fastqs/ Output=out/  --conda-create-envs-only --conda-frontend conda 
compute node
snakemake -c 1 -s runner.smk --use-conda --config Fastqs=/hpcfs/users/a1667917/Bacteria_Multiplex/aggregated_fastqs  Output=/hpcfs/users/a1667917/Bacteria_Multiplex/Pipeline_Out  --conda-create-envs-only --conda-frontend conda 

snakemake -c 16 -s runner.smk --use-conda --config csv=sample_list.csv Output=out/ Polypolish_Dir=

snakemake -c 16 -s runner.smk --use-conda --config csv=/Users/a1667917/Documents/S_Nanopore_Bacteria_Seq/metadata_ghais.csv Output=/Users/a1667917/Documents/S_Nanopore_Bacteria_Seq/Ghais_Output 

"""

import os

### DEFAULT CONFIG FILE

BigJobMem = 32000
BigJobCpu = 64

### DIRECTORIES

include: "rules/directories.smk"

# get if needed
CSV = config['csv']
OUTPUT = config['Output']
POLYPOLISH=config['Polypolish_Dir']

# Parse the samples and read files
include: "rules/samples.smk"
dictReads = parseSamples(CSV)
SAMPLES = list(dictReads.keys())
#print(SAMPLES)


# Import rules and functions
include: "rules/targets.smk"
include: "rules/assemble.smk"

rule all:
    input:
        TargetFiles
