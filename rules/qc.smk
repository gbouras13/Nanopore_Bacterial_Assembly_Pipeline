def get_input_fastqs(wildcards):
    return dictReads[wildcards.sample]["LR"]

rule filtlong:
    input:
        get_input_fastqs
    output:
        os.path.join(TMP,"{sample}_filt.fastq.gz")
    threads:
        1
    conda:
        os.path.join('..', 'envs','qc.yaml')
    resources:
        mem_mb=BigJobMem,
        time=120,
        th=1
    params:
        MIN_LENGTH, 
        MIN_QUALITY
    shell:
        """
        filtlong --min_length {params[0]} --min_mean_q {params[1]}  {input[0]} | gzip > {output[0]}
        """

rule porechop:
    input:
        os.path.join(TMP,"{sample}_filt.fastq.gz")
    output:
        os.path.join(TMP,"{sample}_filt_trim.fastq.gz")
    threads:
        BigJobCpu
    conda:
        os.path.join('..', 'envs','qc.yaml')
    resources:
        mem_mb=BigJobMem,
        th=BigJobCpu
    shell:
        """
        porechop -i {input[0]}  -o {output[0]} -t {threads}
        """

rule aggr_qc:
    input:
        expand(os.path.join(TMP,"{sample}_filt_trim.fastq.gz"), sample = SAMPLES)
    output:
        os.path.join(LOGS, "aggr_qc.txt")
    threads:
        1
    resources:
        mem_mb=SmallJobMem,
        time=2,
        th=1
    shell:
        """
        touch {output[0]}
        """
