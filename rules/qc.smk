def get_input_fastqs(wildcards):
    return dictReads[wildcards.sample]["LR"]

# rule filtlong:
#     input:
#         get_input_fastqs
#     output:
#         os.path.join(TMP,"{sample}_filt.fastq.gz")
#     conda:
#         os.path.join('..', 'envs','qc.yaml')
#     resources:
#         mem_mb=BigJobMem,
#         time=30,
#         th=1
#     params:
#         MIN_QUALITY
#     shell:
#         """
#         filtlong --min_mean_q {params[0]}  {input[0]} | gzip > {output[0]}
#         """

rule rasusa:
    input:
        get_input_fastqs
    output:
        os.path.join(QC,"{sample}_filt_ras.fastq.gz")
    conda:
        os.path.join('..', 'envs','rasusa.yaml')
    resources:
        mem_mb=SmallJobMem,
        time=30,
        th=1
    params:
        MIN_CHROM_LENGTH
    shell:
        """
        rasusa -i {input[0]} --coverage 100 --genome-size {params[0]} -o {output[0]}
        """

rule porechop:
    input:
        os.path.join(QC,"{sample}_filt_ras.fastq.gz")
    output:
        os.path.join(QC,"{sample}_filt_trim.fastq.gz")
    conda:
        os.path.join('..', 'envs','qc.yaml')
    resources:
        mem_mb=BigJobMem,
        th=BigJobCpu,
        time=120
    shell:
        """
        porechop -i {input[0]}  -o {output[0]} -t {resources.th}
        """

rule aggr_qc:
    input:
        expand(os.path.join(QC,"{sample}_filt_trim.fastq.gz"), sample = SAMPLES)
    output:
        os.path.join(LOGS, "aggr_qc.txt")
    resources:
        mem_mb=SmallJobMem,
        time=2,
        th=1
    shell:
        """
        touch {output[0]}
        """
