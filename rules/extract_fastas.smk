
rule extract_chromosome_plasmids:
    input:
        os.path.join(ASSEMBLIES,"{sample}", "assembly.fasta")
    output:
        os.path.join(CHROMOSOME,"{sample}.fasta"),
        os.path.join(PLASMIDS,"{sample}.fasta")
    params:
        MIN_CHROM_LENGTH
    conda:
        os.path.join('..', 'envs','scripts.yaml')
    resources:
        mem_mb=SmallJobMem,
        time=5,
        th=1
    script:
        '../scripts/extract_chromosome_plasmid.py'


rule aggr_chromosome_plasmid:
    """Aggregate."""
    input:
        expand(os.path.join(PLASMIDS,"{sample}.fasta"), sample = SAMPLES),
        expand(os.path.join(CHROMOSOME,"{sample}.fasta"), sample = SAMPLES)
    output:
        os.path.join(LOGS, "aggr_chr_plas.txt")
    resources:
        mem_mb=SmallJobMem,
        time=2,
        th=1
    shell:
        """
        touch {output[0]}
        """