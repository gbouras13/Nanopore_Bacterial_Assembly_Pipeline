
rule extract_plasmid_copy_number:
    input:
        os.path.join(ASSEMBLIES,"{sample}", "assembly_info.txt")
    output:
        os.path.join(PLASMID_COVERAGE,"{sample}_plasmid_copy_number.csv")
    conda:
        os.path.join('..', 'envs','scripts.yaml')
    threads:
        1
    resources:
        mem_mb=BigJobMem
    script:
        '../scripts/extract_plasmid_coverage.py'

rule aggr_plasmid_coverage_info:
    """Aggregate."""
    input:
        expand(os.path.join(PLASMID_COVERAGE,"{sample}_plasmid_copy_number.csv"), sample = SAMPLES)
    output:
        os.path.join(LOGS, "aggr_plas_copy.txt")
    threads:
        1
    resources:
        mem_mb=BigJobMem
    shell:
        """
        touch {output[0]}
        """