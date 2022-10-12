"""
The snakefile that runs the pipeline.
Manual launch example:

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
SmallJobMem = config["SmallJobMem"]
STAPH = config["Staph"]
# file holding mlst type scheme
MLST_DB = "mlst"

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
include: "rules/extract_fastas.smk"
# extract fastas then polish the assemblies
if MEDAKA_FLAG == True:
    include: "rules/polish.smk"
elif MEDAKA_FLAG == False:
    include: "rules/polish_no_medaka.smk"
include: "rules/extract_assembly_info.smk"
include: "rules/plassembler.smk"
# run if STAPH is true
if STAPH == True:
    include: "rules/mlst.smk"
    include: "rules/combine_mlst.smk"
    include: "rules/srst2.smk"

rule all:
    input:
        TargetFiles
