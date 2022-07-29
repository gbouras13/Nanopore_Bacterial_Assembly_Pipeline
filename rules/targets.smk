"""
All target output files are declared here
"""

# for the prokka annotations
prok_file = os.path.join(LOGS, "aggr_prokka.txt")

if STAPH == true:
    prok_file = os.path.join(LOGS, "aggr_prokka_staph.txt")

# Preprocessing files
TargetFiles = [
    os.path.join(LOGS, "aggr_assemble.txt"),
    os.path.join(LOGS, "aggr_polish.txt"),
    os.path.join(LOGS, "aggr_stats.txt"),
    os.path.join(LOGS, "aggr_chr_plas.txt"),
    os.path.join(LOGS, "aggr_assembly_info.txt"),
    os.path.join(LOGS, "aggr_plas_copy.txt"),
    prok_file
]
