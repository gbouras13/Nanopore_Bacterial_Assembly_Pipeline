"""
The snakefile that runs the pipeline.
Manual launch example:

snakemake -c 1 -s runner.smk --use-conda --config Fastqs=Fastas/  --conda-create-envs-only --conda-frontend conda
compute node
snakemake -c 16 -s runner.smk --use-conda --config Fastqs=Fastas/ Output=out/ 
"""


### DEFAULT CONFIG FILE
configfile: os.path.join(workflow.basedir,  'config', 'config.yaml')

BigJobMem = config["BigJobMem"]
BigJobCpu = config["BigJobCpu"]

### DIRECTORIES

include: "rules/directories.smk"

# get if needed
FASTQS = config['Fastqs']
OUTPUT = config['Output']

# Parse the samples and read files
include: "rules/samples.smk"
sampleAssemblies = parseSamples(FASTQS)
SAMPLES = sampleAssemblies.keys()

# Import rules and functions
include: "rules/targets.smk"
include: "rules/assemble.smk"

# # if empty remove samples

# include: "rules/empty_files.smk"
# include: "rules/non_empty_files.smk"

# sampleAssemblies_not_empty = parseSamplesNonEmpty(TMP)
# SAMPLES_not_empty = sampleAssemblies_not_empty.keys()
# sampleAssemblies_empty = parseSamplesEmpty(TMP)
# SAMPLES_empty = sampleAssemblies_empty.keys()

# writeEmptyCsv(SAMPLES_empty, RESULTS)

# include: "rules/cluster.smk"
# include: "rules/collate.smk"
# include: "rules/summarise.smk"

rule all:
    input:
        TargetFiles
