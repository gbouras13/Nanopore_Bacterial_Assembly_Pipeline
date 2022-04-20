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
TMP = os.path.join(OUTPUT, 'TMP')
ASSEMBLIES = os.path.join(TMP, 'ASSEMBLIES')
MEDAKA = os.path.join(TMP, 'MEDAKA')
BWA = os.path.join(TMP, 'BWA')
FASTP = os.path.join(TMP, 'FASTP')
POLYPOLISH = os.path.join(OUTPUT, 'POLYPOLISH')




