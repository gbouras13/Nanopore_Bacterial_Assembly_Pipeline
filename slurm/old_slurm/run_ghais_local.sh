#!/bin/bash -l


SNK_DIR="/Users/a1667917/Documents/Ghais/S_Aureus_Polished/Nanopore_Bacterial_Assembly_Pipeline"

cd $SNK_DIR


snakemake -c 16 -s runner.smk --use-conda  \
--config csv=ghais_local_metadata.csv Output=/Users/a1667917/Documents/Ghais/S_Aureus_Polished/Assembly_Output Polypolish_Dir=/Users/a1667917/Misc_Programs/Polypolish/target/release


