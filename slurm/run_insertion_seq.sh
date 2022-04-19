#!/bin/bash -l

#SBATCH --job-name=s_aureus_insertion
#SBATCH --mail-user=george.bouras@adelaide.edu.au
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH --err="s_aureus_insertion.err"
#SBATCH --output="s_aureus_insertion.out"

# Resources allocation request parameters
#SBATCH -p batch
#SBATCH -N 1              	                                # number of tasks (sequential job starts 1 task) (check this if your job unexpectedly uses 2 nodes)
#SBATCH -c 1              	                                # number of cores (sequential job calls a multi-thread program that uses 8 cores)
#SBATCH --time=06:00:00                                         # time allocation, which has the format (D-HH:MM), here set to 1 hou                                           # generic resource required (here requires 1 GPUs)
#SBATCH --mem=16GB                                              # specify memory required per node


SNK_DIR="/hpcfs/users/a1667917/s_aureus/S_Aureus_Pipeline"
PROF_DIR="/hpcfs/users/a1667917/snakemake_slurm_profile"

cd $SNK_DIR

module load Anaconda3/2020.07
conda activate snakemake_clean_env

# snakemake -c 1 -s runner.smk --use-conda --config Assemblies=/hpcfs/users/a1667917/s_aureus/total_fastas  Output=/hpcfs/users/a1667917/s_aureus/Insertion_Seqs_Out  --conda-create-envs-only --conda-frontend conda
#snakemake -c 1 -s runner.smk --use-conda --config Assemblies=/hpcfs/users/a1667917/s_aureus/total_fastas  Output=/hpcfs/users/a1667917/s_aureus/Insertion_Seqs_Out --profile $PROF_DIR/s_aureus

python3 run_pipeline.py -c 1 -f /hpcfs/users/a1667917/s_aureus/total_fastas/ -o /hpcfs/users/a1667917/s_aureus/Insertion_Seqs_Out -p $PROF_DIR/s_aureus

conda deactivate
