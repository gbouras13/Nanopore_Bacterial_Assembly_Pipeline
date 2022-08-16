"""
All target output files are declared here
"""

# for the prokka annotations
prok_file = os.path.join(LOGS, "aggr_prokka.txt")
phis_file = os.path.join(LOGS, "aggr_phispy.txt")

if STAPH == True:
    prok_file = os.path.join(LOGS, "aggr_prokka_staph.txt")

# Preprocessing files
TargetFiles = [
    os.path.join(LOGS, "aggr_assemble.txt"),
    os.path.join(LOGS, "aggr_polish.txt"),
    os.path.join(LOGS, "aggr_stats.txt"),
    os.path.join(LOGS, "aggr_chr_plas.txt"),
    os.path.join(LOGS, "aggr_assembly_info.txt"),
    os.path.join(LOGS, "aggr_plas_copy.txt"),
    os.path.join(LOGS, "aggr_plasembler.txt"),
    prok_file,
    phis_file,
    os.path.join(LOGS, "aggr_mlst.txt"),
    os.path.join(LOGS, "aggr_mlst_combine.txt")
]
