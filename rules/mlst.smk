

rule mlst:
    """Run mlst."""
    input:
        os.path.join(CHROMOSOME_POST_POLISHING,"{sample}.fasta")
    output:
        os.path.join(MLST,"{sample}.csv")
    conda:
        os.path.join('..', 'envs','mlst.yaml')
    resources:
        mem_mb=SmallJobMem,
        time=10,
        th=1
    shell:
        """
        mlst --scheme saureus --nopath  --csv {input[0]} > {output[0]}
        """

rule aggr_mlst:
    """Aggregate."""
    input:
        expand(os.path.join(MLST,"{sample}.csv"), sample = SAMPLES)
    output:
        os.path.join(LOGS, "aggr_mlst.txt")
    resources:
        mem_mb=SmallJobMem,
        time=2,
        th=1
    shell:
        """
        touch {output[0]}
        """

