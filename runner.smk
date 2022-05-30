"""
The snakefile that runs the pipeline.
Manual launch example:

snakemake -c 1 -s runner.smk --use-conda --config Fastqs=/Users/a1667917/Documents/S_Nanopore_Bacteria_Seq/aggregated_fastqs/ Output=out/  --conda-create-envs-only --conda-frontend conda 
compute node
snakemake -c 1 -s runner.smk --use-conda --config Fastqs=/hpcfs/users/a1667917/Bacteria_Multiplex/aggregated_fastqs  Output=/hpcfs/users/a1667917/Bacteria_Multiplex/Pipeline_Out  --conda-create-envs-only --conda-frontend conda 


snakemake -c 16 -s runner.smk --use-conda --config csv=/Users/a1667917/Documents/S_Nanopore_Bacteria_Seq/metadata_ghais.csv Output=/Users/a1667917/Documents/S_Nanopore_Bacteria_Seq/Ghais_Output Polypolish_Dir=/Users/a1667917/Misc_Programs/Polypolish/target/release

snakemake -c 1 -s runner.smk --use-conda --config csv=/Users/a1667917/Documents/S_Nanopore_Bacteria_Seq/metadata_ghais.csv \
 Output=/Users/a1667917/Documents/S_Nanopore_Bacteria_Seq/Ghais_Output Polypolish_Dir=/Users/a1667917/Misc_Programs/Polypolish/target/release 

 snakemake -c 16 -s runner.smk --use-conda --config csv=/Users/a1667917/Documents/S_Nanopore_Bacteria_Seq/metadata_ghais.csv \
 Output=/Users/a1667917/Documents/S_Nanopore_Bacteria_Seq/Ghais_Output Polypolish_Dir=/Users/a1667917/Misc_Programs/Polypolish/target/release  --conda-create-envs-only --conda-frontend conda 

snakemake -c 1 -s runner.smk --use-conda  --conda-frontend conda  \
--config csv=/hpcfs/users/a1667917/Bacteria_Multiplex/Nanopore_Bacterial_Assembly_Pipeline/hpc_metadata.csv Output=/hpcfs/users/a1667917/Bacteria_Multiplex/Pipeline_Out Polypolish_Dir=/hpcfs/users/a1667917/Polypolish 


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
POLYPOLISH_BIN=config['Polypolish_Dir']
MIN_CHROM_LENGTH=config['min_chrom_length']

# Parse the samples and read files
include: "rules/samples.smk"
dictReads = parseSamples(CSV)
SAMPLES = list(dictReads.keys())
#print(SAMPLES)


# Import rules and functions
include: "rules/targets.smk"
include: "rules/assemble.smk"
include: "rules/assembly_statistics.smk"
include: "rules/polish.smk"
include: "rules/extract_fastas.smk"
include: "rules/extract_assembly_info.smk"

rule all:
    input:
        TargetFiles
