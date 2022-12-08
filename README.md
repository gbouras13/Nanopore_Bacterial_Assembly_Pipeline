# Nanopore_Bacterial_Assembly_Pipeline
Pipeline to assemble many bacterial assemblies from Nanopore data

If you want to use this, I'd recommend checking out [hybracter](https://github.com/gbouras13/hybracter), which is a cleaner and easier to use version of this pipeline.



* Designed for hybrid ONT/Illumina assemblies   
* Plasmids are assembled using plassembler https://github.com/gbouras13/plassembler
* s aureus strains are sequence typed with mlst and srst2 using the chromosome and short reads respectively
* Otherwise the pipeline mostly follows https://github.com/rrwick/Perfect-bacterial-genome-tutorial with some small changes
* The main pipeline for generating a polished chromosome goes:

qc (filtlong, rasusa, porechop) -> flye -> medaka -> polypolish -> rotate chromosome to begin with dnaA using dnaapler -> polypolish round 2 -> polca


