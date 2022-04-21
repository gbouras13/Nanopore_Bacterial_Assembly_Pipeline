
rule extract_summary_assembly_stats:
    input:
        os.path.join(ASSEMBLIES,"{sample}", "assembly_info.txt")
    output:
        os.path.join(SUMMARIES,"{sample}_clean_assembly_info.csv"),
        os.path.join(SUMMARIES,"{sample}_summary.csv")
    params:
        GENOME_SIZE
    conda:
        os.path.join('..', 'envs','scripts.yaml')
    threads:
        1
    resources:
        mem_mb=BigJobMem
    script:
        '../scripts/extract_summary_assembly_stats.py'

rule aggr_statistics:
    """Aggregate."""
    input:
        expand(os.path.join(SUMMARIES,"{sample}_clean_assembly_info.csv"), sample = SAMPLES),
        expand(os.path.join(SUMMARIES,"{sample}_summary.csv"), sample = SAMPLES)
    output:
        os.path.join(LOGS, "aggr_stats.txt")
    threads:
        1
    resources:
        mem_mb=BigJobMem
    shell:
        """
        touch {output[0]}
        """