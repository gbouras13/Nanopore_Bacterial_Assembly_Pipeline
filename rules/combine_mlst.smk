

rule combine_mlst:
    input:
        mlsts = expand(os.path.join(MLST,"{sample}.csv"), sample = SAMPLES)
    output:
        out = os.path.join(MLST,"total_mlst.csv")
    conda:
        os.path.join('..', 'envs','scripts.yaml')
    params:
        saureus = os.path.join(  '..', 'mlst', 'saureus.txt')
    threads:
        1
    resources:
        mem_mb=SmallJobMem
    script:
        '../scripts/combine_mlst.py'


rule aggr_mlst_combine:
    """Aggregate."""
    input:
        os.path.join(MLST,"total_mlst.csv")
    output:
        os.path.join(LOGS, "aggr_mlst_combine.txt")
    threads:
        1
    resources:
        mem_mb=SmallJobMem
    shell:
        """
        touch {output[0]}
        """