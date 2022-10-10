

rule combine_mlst:
    input:
        mlsts = expand(os.path.join(MLST,"{sample}.csv"), sample = SAMPLES)
    output:
        out = os.path.join(MLST,"total_mlst.csv")
    conda:
        os.path.join('..', 'envs','scripts.yaml')
    params:
        saureus = os.path.join(MLST_DB, 'saureus.txt')
    resources:
        mem_mb=SmallJobMem,
        time=5,
        th=1
    script:
        '../scripts/combine_mlst.py'


rule aggr_mlst_combine:
    """Aggregate."""
    input:
        os.path.join(MLST,"total_mlst.csv")
    output:
        os.path.join(LOGS, "aggr_mlst_combine.txt")
    resources:
        mem_mb=SmallJobMem,
        time=2,
        th=1
    shell:
        """
        touch {output[0]}
        """