

rule mlst:
    """Run mlst."""
    input:
        os.path.join(CHROMOSOME,"{sample}.fasta")
    output:
        os.path.join(MLST,"{sample}.csv")
    conda:
        os.path.join('..', 'envs','mlst.yaml')
    threads:
        1
    resources:
        mem_mb=SmallJobMem,
        time=10
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
    threads:
        1
    resources:
        mem_mb=SmallJobMem,
        time=2
    shell:
        """
        touch {output[0]}
        """

