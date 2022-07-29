"""
The snakefile that runs the pipeline.
Manual launch example:

snakemake -c 1 -s runner.smk --use-conda --config Fastqs=/Users/a1667917/Documents/S_Nanopore_Bacteria_Seq/aggregated_fastqs/ Output=out/  --conda-create-envs-only --conda-frontend conda 
compute node
snakemake -c 1 -s runner.smk --use-conda --config Fastqs=/hpcfs/users/a1667917/Bacteria_Multiplex/aggregated_fastqs  Output=/hpcfs/users/a1667917/Bacteria_Multiplex/Pipeline_Out  --conda-create-envs-only --conda-frontend conda 


snakemake -c 16 -s runner.smk --use-conda --config csv=/Users/a1667917/Documents/S_Nanopore_Bacteria_Seq/metadata_ghais.csv Output=/Users/a1667917/Documents/S_Nanopore_Bacteria_Seq/Ghais_Output Polypolish_Dir=/Users/a1667917/Misc_Programs/Polypolish/target/release

 snakemake -c 16 -s runner.smk --use-conda  --conda-frontend conda  \
--config csv=c_accolens_metadata_local.csv Output=/Users/a1667917/Documents/Will/sequencing/C781_Pipeline_Assembly  Polypolish_Dir=/Users/a1667917/Misc_Programs/Polypolish/Polypolish/target/release  Medaka=False

"""

import os

### DEFAULT CONFIG FILE

configfile: os.path.join(  'config', 'config.yaml')


### DIRECTORIES

include: "rules/directories.smk"

# get if needed
CSV = config['csv']
OUTPUT = config['Output']
POLYPOLISH_BIN=config['Polypolish_Dir']
MEDAKA_FLAG = config['Medaka']
MIN_CHROM_LENGTH = config['min_chrom_length']
MIN_LENGTH = config['min_length']
MIN_QUALITY = config['min_quality']
BigJobMem = config["BigJobMem"]
BigJobCpu = config["BigJobCpu"]
STAPH = config["Staph"]

# Parse the samples and read files
include: "rules/samples.smk"
dictReads = parseSamples(CSV)
SAMPLES = list(dictReads.keys())
#print(SAMPLES)


# Import rules and functions
include: "rules/targets.smk"
include: "rules/qc.smk"
include: "rules/assemble.smk"
include: "rules/assembly_statistics.smk"
if MEDAKA_FLAG == True:
    include: "rules/polish.smk"
elif MEDAKA_FLAG == False:
    include: "rules/polish_no_medaka.smk"
include: "rules/extract_fastas.smk"
include: "rules/extract_assembly_info.smk"
include: "rules/extract_plasmid_coverage.smk"
include: "rules/annotate_chromosome.smk"

rule all:
    input:
        TargetFiles
