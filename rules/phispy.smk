

rule phispy:
    """Run phispy."""
    input:
        os.path.join(PROKKA,"{sample}","{sample}.gbk")
    output:
        os.path.join(PHISPY,"{sample}", "prophage_coordinates.tsv"),
        os.path.join(PHISPY,"{sample}", "phage.fasta")
    conda:
        os.path.join('..', 'envs','phispy.yaml')
    params:
        os.path.join(PHISPY,"{sample}")
    threads:
        BigJobCpu
    resources:
        mem_mb=BigJobMem
    shell:
        """
        phispy {input[0]} --output_choice 512 -o {params[0]} --phage_genes 0
        """

# rule collate_phsipy_output:
#     """move phispy output."""
#     input:
#         os.path.join(PHISPY,"{sample}", "phage.fasta")
#     output:
#         os.path.join(PHISPY,"{sample}", "phage.fastas")
#     conda:
#         os.path.join('..', 'envs','phispy.yaml')
#     params:
#         os.path.join(PHISPY,"{sample}")
#     threads:
#         BigJobCpu
#     resources:
#         mem_mb=BigJobMem
#     shell:
#         """
#         phispy {input[0]} --output_choice 512 -o {params[0]} --phage_genes 0
#         """

rule aggr_phispy:
    """Aggregate."""
    input:
        expand(os.path.join(PHISPY,"{sample}", "prophage_coordinates.tsv"), sample = SAMPLES)
    output:
        os.path.join(LOGS, "aggr_phispy.txt")
    threads:
        1
    resources:
        mem_mb=BigJobMem
    shell:
        """
        touch {output[0]}
        """

