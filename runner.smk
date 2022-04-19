"""
The snakefile that runs the pipeline.
Manual launch example:

snakemake -c 1 -s runner.smk --use-conda --config Fastqs=/Users/a1667917/Documents/S_Nanopore_Bacteria_Seq/aggregated_fastqs/ Output=out/  --conda-create-envs-only --conda-frontend conda 
compute node
snakemake -c 16 -s runner.smk --use-conda --config Fastqs=Fastas/ Output=out/ 
"""

import os

### DEFAULT CONFIG FILE

BigJobMem = 32000
BigJobCpu = 64

### DIRECTORIES

include: "rules/directories.smk"

# get if needed
FASTQS = config['Fastqs']
OUTPUT = config['Output']

# Parse the samples and read files
include: "rules/samples.smk"
sampleAssemblies = parseSamples(FASTQS)
SAMPLES = sampleAssemblies.keys()
print(SAMPLES)

# Import rules and functions
include: "rules/targets.smk"
include: "rules/assemble.smk"

rule all:
    input:
        TargetFiles
