"""
All target output files are declared here
"""

if STAPH == True:
    mlst_files = [ os.path.join(LOGS, "aggr_mlst.txt"),
        os.path.join(LOGS, "aggr_mlst_combine.txt"),
        os.path.join(LOGS, "aggr_srst2.txt")]
else:
    mlst_files = []

# Preprocessing files
TargetFiles = [
    os.path.join(LOGS, "aggr_assemble.txt"),
    os.path.join(LOGS, "aggr_polish.txt"),
    os.path.join(LOGS, "aggr_stats.txt"),
    os.path.join(LOGS, "aggr_chr_plas.txt"),
    os.path.join(LOGS, "aggr_assembly_info.txt"),
    os.path.join(LOGS, "aggr_plasembler.txt"),
    os.path.join(LOGS, "aggr_srst2_combine.txt"),
    os.path.join(LOGS, "aggr_combine_plassembler_info.txt"),
    mlst_files
]
