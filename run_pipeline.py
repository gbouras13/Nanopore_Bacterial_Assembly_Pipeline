import argparse
import os
from argparse import RawTextHelpFormatter
import subprocess as sp



def get_input():
    parser = argparse.ArgumentParser(description='snakemake pipeline to characterise insertion sequences in bacterial genomes', formatter_class=RawTextHelpFormatter)
    parser.add_argument('-f', '--fasta', action="store", help='Directory of Assemblies',  required=True)
    parser.add_argument('-o', '--outdir', action="store", help='Output directory', default=os.path.join(os.getcwd(), "output/") )
    parser.add_argument('-c', '--cores', action='store', help='number of cores' ,  required=True) 
    parser.add_argument('-p', '--profile', action='store', help='snakemake profile location' )
    args = parser.parse_args()
    return args

args = get_input()


assemblies = "Assemblies="+str(args.fasta)
output = "Output="+str(args.outdir)

# make the profile optional

if args.profile is None:
    sp.call(["snakemake", "-c", args.cores, "-s", "runner.smk", "--use-conda", "--config", assemblies, output ])
    sp.call(["snakemake", "-c", args.cores, "-s", "runner2.smk", "--use-conda", "--config", assemblies, output ])
else:
    sp.call(["snakemake", "-c", args.cores, "-s", "runner.smk", "--use-conda", "--config", assemblies, output, "--profile", args.profile ])
    sp.call(["snakemake", "-c", args.cores, "-s", "runner2.smk", "--use-conda", "--config", assemblies, output, "--profile", args.profile ])

