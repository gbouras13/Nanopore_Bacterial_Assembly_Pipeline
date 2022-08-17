

rule srst2:
    """Run srst2."""
    input:
        os.path.join(FASTP,"{sample}_1.fastq.gz")
    output:
        os.path.join(SRST2,"{sample}__mlst__Staphylococcus_aureus__results.txt") 
    params:
        os.path.join(SRST2,"{sample}"),
        os.path.join( MLST_DB, 'Staphylococcus_aureus.fasta'),
        os.path.join( MLST_DB, 'profiles_csv')
    conda:
        os.path.join('..', 'envs','srst2.yaml')
    threads:
        BigJobCpu
    resources:
        mem_mb=BigJobMem
    shell:
        """
        srst2 --input_se {input[0]} --output {params[0]} --log --mlst_db {params[1]} --mlst_definitions {params[2]} --threads {threads} --mlst_delimiter _  
        """


rule combine_srst2:
    input:
        srst2s = expand(os.path.join(SRST2,"{sample}__mlst__Staphylococcus_aureus__results.txt"), sample = SAMPLES)
    output:
        out = os.path.join(SRST2,"total_srst2.csv")
    conda:
        os.path.join('..', 'envs','scripts.yaml')
    params:
        saureus = os.path.join(MLST_DB, 'saureus.txt')
    threads:
        1
    resources:
        mem_mb=SmallJobMem
    script:
        '../scripts/combine_srst2.py'


rule aggr_srst2:
    """Aggregate."""
    input:
        expand(os.path.join(SRST2,"{sample}__mlst__Staphylococcus_aureus__results.txt") , sample = SAMPLES),
        os.path.join(SRST2,"total_srst2.csv")
    output:
        os.path.join(LOGS, "aggr_srst2.txt")
    threads:
        1
    resources:
        mem_mb=BigJobMem
    shell:
        """
        touch {output[0]}
        """

