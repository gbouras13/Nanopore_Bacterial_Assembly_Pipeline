# Nanopore_Bacterial_Assembly_Pipeline
Pipeline to assemble many bacterial assemblies from Nanopore data

* Designed for hybrid ONT/Illumina assemblies   
* Assembly using Flye followed by polishing with Medaka and Polypolish
* Plasmids are then assembled using plassembler https://github.com/gbouras13/plassembler
* For s aureus strains, these are sequence typed with mlst (tseeman) and srst2 using the chromosome and short reads respectively
* Adding the rotation script from https://github.com/rrwick/Perfect-bacterial-genome-tutorial

