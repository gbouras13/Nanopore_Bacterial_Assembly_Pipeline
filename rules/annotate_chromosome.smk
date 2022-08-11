rule prokka_staph:
    """Run prokka."""
    input:
        os.path.join(CHROMOSOME,"{sample}.fasta")
    output:
        os.path.join(PROKKA,"{sample}_staph","{sample}.gff"),
        os.path.join(PROKKA,"{sample}_staph","{sample}.ffn"),
        os.path.join(PROKKA,"{sample}_staph","{sample}.gbk")
    conda:
        os.path.join('..', 'envs','prokka.yaml')
    params:
        os.path.join(PROKKA, "{sample}_staph")
    threads:
        BigJobCpu
    resources:
        mem_mb=BigJobMem
    shell:
        """
        prokka --cpus {threads} --genus Staphylococcus --usegenus --outdir {params[0]} --prefix {wildcards.sample} {input[0]} --force
        """

rule prokka_general:
    """Run prokka."""
    input:
        os.path.join(CHROMOSOME,"{sample}.fasta")
    output:
        os.path.join(PROKKA,"{sample}","{sample}.gff"),
        os.path.join(PROKKA,"{sample}","{sample}.ffn")
        os.path.join(PROKKA,"{sample}","{sample}.gbk")
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
        prokka --cpus {threads} --outdir {params[0]} --prefix {wildcards.sample} {input[0]} --force
        """

rule move_gff:
    input:
        os.path.join(PROKKA,"{sample}","{sample}.gff")
    output:
        os.path.join(CHROMOSOME_GFFS,"{sample}.gff")
    threads:
        1
    resources:
        mem_mb=BigJobMem
    shell:
        """
        cp {input[0]} {output[0]} 
        """

rule move_gff_staph:
    input:
        os.path.join(PROKKA,"{sample}_staph","{sample}.gff")
    output:
        os.path.join(CHROMOSOME_GFFS,"{sample}_staph.gff")
    threads:
        1
    resources:
        mem_mb=BigJobMem
    shell:
        """
        cp {input[0]} {output[0]} 
        """


rule aggr_prokka:
    """Aggregate."""
    input:
        expand(os.path.join(CHROMOSOME_GFFS,"{sample}.gff" ), sample = SAMPLES),
        expand(os.path.join(PROKKA,"{sample}","{sample}.gbk"), sample = SAMPLES)
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

rule aggr_prokka_staph:
    """Aggregate."""
    input:
        expand(os.path.join(CHROMOSOME_GFFS,"{sample}_staph.gff" ), sample = SAMPLES),
        expand(os.path.join(PROKKA,"{sample}_staph","{sample}.gbk"), sample = SAMPLES)
    output:
        os.path.join(LOGS, "aggr_prokka_staph.txt")
    threads:
        1
    resources:
        mem_mb=BigJobMem
    shell:
        """
        touch {output[0]}
        """
