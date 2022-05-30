
rule extract_chromosome_plasmids:
    input:
        os.path.join(ASSEMBLIES,"{sample}", "assembly.fasta")
    output:
        os.path.join(CHROMOSOME,"{sample}.fasta"),
        os.path.join(PLASMIDS,"{sample}.fasta")
    params:
        MIN_CHROM_LENGTH
        os.path.join('..', 'envs','scripts.yaml')
    threads:
        1
    resources:
        mem_mb=BigJobMem
    script:
        '../scripts/extract_chromosome_plasmid.py'


rule aggr_chromosome_plasmid:
    """Aggregate."""
    input:
        expand(os.path.join(PLASMIDS,"{sample}.fasta"), sample = SAMPLES),
        expand(os.path.join(CHROMOSOME,"{sample}.fasta"), sample = SAMPLES)
    output:
        os.path.join(LOGS, "aggr_chr_plas.txt")
    threads:
        1
    resources:
        mem_mb=BigJobMem
    shell:
        """
        touch {output[0]}
        """