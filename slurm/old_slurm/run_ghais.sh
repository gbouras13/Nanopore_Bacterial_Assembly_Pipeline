#!/bin/bash -l

#SBATCH --job-name=bact_assembly
#SBATCH --mail-user=george.bouras@adelaide.edu.au
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH --err="bact_assembly_snk.err"
#SBATCH --output="bact_assembly_snk.out"

# Resources allocation request parameters
#SBATCH -p batch
#SBATCH -N 1                                  
#SBATCH -c 1                                           
#SBATCH --time=2-23:00:00                                                                          
#SBATCH --mem=1GB                                             


SNK_DIR="/hpcfs/users/a1667917/Bacteria_Multiplex/Nanopore_Bacterial_Assembly_Pipeline"
PROF_DIR="/hpcfs/users/a1667917/snakemake_slurm_profile"

cd $SNK_DIR

module load Anaconda3/2020.07
conda activate snakemake_clean_env



# needs snakemake minimal 6.13. Don't know why, Snakemake 7 breaks with a strange error about the output files not existing and an sacct error



snakemake -c 1 -s runner.smk --use-conda --conda-frontend conda --profile $PROF_DIR/bact_assembly \
--config csv=ghais_hpc_metadata.csv Output=/hpcfs/users/a1667917/Ghais/S_Aureus_Polished/Assembly_Output Polypolish_Dir=/hpcfs/users/a1667917/Polypolish min_chrom_length=2400000


# snakemake -c 1 -s runner.smk --use-conda --conda-create-envs-only --conda-frontend conda  \
# --config csv=ghais_hpc_metadata.csv Output=/hpcfs/users/a1667917/Ghais/S_Aureus_Polished/Assembly_Output Polypolish_Dir=/hpcfs/users/a1667917/Polypolish  min_chrom_length=2400000


conda deactivate
