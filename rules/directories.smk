"""
Database and output locations for Hecatomb
Ensures consistent variable names and file locations for the pipeline.
"""


### OUTPUT DIRECTORY
if config['Output'] is None:
    OUTPUT = 'Assemblies_Output'
else:
    OUTPUT = config['Output']


### OUTPUT DIRs
LOGS = os.path.join(OUTPUT, 'LOGS')
DELETE = os.path.join(OUTPUT, 'DELETE_LOGS')
TMP = os.path.join(OUTPUT, 'TMP')
PLASSEMBLER = os.path.join(OUTPUT, 'PLASSEMBLER')
PLASSEMBLER_FASTAS = os.path.join(OUTPUT, 'PLASSEMBLER_FASTAS')
PLASSEMBLER_SUMMARIES = os.path.join(OUTPUT, 'PLASSEMBLER_SUMMARIES')
COVERAGE_TMP = os.path.join(TMP, 'COVERAGE')
ASSEMBLIES = os.path.join(TMP, 'ASSEMBLIES')
MEDAKA = os.path.join(TMP, 'MEDAKA')
BWA = os.path.join(TMP, 'BWA')
BWA_ROUND2 = os.path.join(TMP, 'BWA_ROUND2')
FASTP = os.path.join(TMP, 'FASTP')
POLYPOLISH_OUT_RD_1 = os.path.join(OUTPUT, 'POLYPOLISH_OUT_RD_1')
POLYPOLISH_OUT_RD_2 = os.path.join(OUTPUT, 'POLYPOLISH_OUT_RD_2')
POLCA_TMP = os.path.join(TMP, 'POLCA_TMP')
DNAAPLER = os.path.join(OUTPUT, 'DNAAPLER')
SUMMARY_OUT = os.path.join(OUTPUT, 'SUMMARY')
CHROMOSOME_PRE_POLISH = os.path.join(TMP, 'CHROMOSOME_PRE_POLISH')
CHROMOSOME_POST_POLISHING = os.path.join(OUTPUT, 'CHROMOSOME_POST_POLISHING')
PLASMIDS = os.path.join(TMP, 'PLASMIDS')
ASSEMBLY_INFO = os.path.join(OUTPUT, 'ASSEMBLY_INFO')
PLASMID_COVERAGE = os.path.join(OUTPUT, 'ASSEMBLY_INFO')
MLST = os.path.join(OUTPUT, 'MLST')
SRST2 = os.path.join(OUTPUT, 'SRST2')

# needs to be created before fastqc is run
SUMMARIES = os.path.join(TMP, 'SUMMARIES')
if not os.path.exists(SUMMARIES):
    os.makedirs(SUMMARIES)






