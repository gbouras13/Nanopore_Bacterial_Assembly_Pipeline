rule prokka:
    """Run prokka."""
    input:
        os.path.join(CHROMOSOME,"{sample}.fasta"), sample = SAMPLES)
    output:
        os.path.join(PROKKA,"{sample}","{sample}.gff"),
        os.path.join(PROKKA,"{sample}","{sample}.ffn")
    conda:
        os.path.join('..', 'envs','prokka.yaml')
    params:
        os.path.join(PROKKA, "{sample}")
    threads:
        BigJobCpu
    resources:
        mem_mb=BigJobMem
    shell:
        """
        prokka --outdir {params[0]}  --prefix {wildcards.sample} {input[0]} --force
        """

rule move_gff:
    input:
        os.path.join(PROKKA,"{sample}","{sample}.gff" )
    output:
        os.path.join(CHROMOSOME_GFFS,"{sample}.gff" )
    threads:
        1
    resources:
        mem_mb=BigJobMem
    shell:
        """
        cp {input[0]} {output[0]} 
        """

rule roary:  
    input:
        expand(os.path.join(CHROMOSOME_GFFS,"{sample}.gff" ), sample = SAMPLES)
    output:
        os.path.join(ROARY,"gene_presence_absence.csv" )
    conda:
        os.path.join('..', 'envs','roary.yaml')
    params:
        ROARY
    threads:
        BigJobCpu
    resources:
        mem_mb=BigJobMem
    shell:
        """
        roary -e -n --mafft -p {threads} –f {params[0]} {input[0]}
        """

rule aggr_prokka:
    """Aggregate."""
    input:
        os.path.join(ROARY,"gene_presence_absence.csv" )
    output:
        os.path.join(LOGS, "aggr_prokka.txt")
    threads:
        1
    resources:
        mem_mb=BigJobMem
    shell:
        """
        touch {output[0]}
        """