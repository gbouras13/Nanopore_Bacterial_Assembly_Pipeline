

rule combine_srst:
    input:
        srsts = expand(os.path.join(SRST2,"{sample}__mlst__Staphylococcus_aureus__results.txt"), sample = SAMPLES)
    output:
        out = os.path.join(MLST,"total_srst2.csv")
    conda:
        os.path.join('..', 'envs','scripts.yaml')
    params:
        saureus = os.path.join(MLST_DB, 'saureus.txt')
    resources:
        mem_mb=SmallJobMem,
        time=5,
        th=1
    script:
        '../scripts/combine_srst2.py'


rule aggr_srst2_combine:
    """Aggregate."""
    input:
        os.path.join(MLST,"total_srst2.csv")
    output:
        os.path.join(LOGS, "aggr_srst2_combine.txt")
    resources:
        mem_mb=SmallJobMem,
        time=2,
        th=1
    shell:
        """
        touch {output[0]}
        """