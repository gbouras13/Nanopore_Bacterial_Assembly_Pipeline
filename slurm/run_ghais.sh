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
#SBATCH -N 1                                                    # number of tasks (sequential job starts 1 task) (check this if your job unexpectedly uses 2 nodes)
#SBATCH -c 1                                                    # number of cores (sequential job calls a multi-thread program that uses 8 cores)
#SBATCH --time=08:00:00                                         # time allocation, which has the format (D-HH:MM), here set to 1 hou                                           # generic resource required (here requires 1 GPUs)
#SBATCH --mem=10GB                                              # specify memory required per node


SNK_DIR="/hpcfs/users/a1667917/Bacteria_Multiplex/Nanopore_Bacterial_Assembly_Pipeline"
PROF_DIR="/hpcfs/users/a1667917/snakemake_slurm_profile"

cd $SNK_DIR

module load Anaconda3/2020.07
conda activate snakemake_clean_env

snakemake -c 1 -s runner.smk --use-conda --profile $PROF_DIR/bact_assembly \
--config csv=/hpcfs/users/a1667917/Bacteria_Multiplex/Nanopore_Bacterial_Assembly_Pipeline/hpc_metadata.csv Output=/hpcfs/users/a1667917/Bacteria_Multiplex/Pipeline_Out Polypolish_Dir=/hpcfs/users/a1667917/Polypolish Genome_Size=2600000


#snakemake -c 1 -s runner.smk --use-conda --conda-create-envs-only --conda-frontend conda  \
#--config csv=/hpcfs/users/a1667917/Bacteria_Multiplex/Nanopore_Bacterial_Assembly_Pipeline/hpc_metadata.csv Output=/hpcfs/users/a1667917/Bacteria_Multiplex/Pipeline_Out Polypolish_Dir=/hpcfs/users/a1667917/Polypolish Genome_Size=2600000

conda deactivate