rule map_short_read_chromosome:
    input:
        os.path.join(FASTP,"{sample}_1.fastq.gz"),
        os.path.join(FASTP,"{sample}_2.fastq.gz"),
        expand(os.path.join(CHROMOSOME,"{sample}.fasta"), sample = SAMPLES)
    output:
        os.path.join(COVERAGE_TMP,"{sample}.bam")
    threads:
        BigJobCpu
    conda:
        os.path.join('..', 'envs','coverage.yaml')
    resources:
        mem_mb=BigJobMem
    shell:
        """
        bwa mem {input[2]} {input[0]} {input[1} | samtools view -bS -@ {threads} > {output[0]}
        """

#https://github.com/rrwick/Small-plasmid-Nanopore/blob/main/scripts/depth_and_gc.py

rule depth_short_read_chromosome:
    input:
        os.path.join(COVERAGE_TMP,"{sample}.bam")
    output:
        os.path.join(FASTP,"{sample}_1.fastq.gz"),
        os.path.join(FASTP,"{sample}_2.fastq.gz")
    threads:
        BigJobCpu
    conda:
        os.path.join('..', 'envs','short_read_polish.yaml')
    resources:
        mem_mb=BigJobMem
    shell:
        """
        samtools depth  os.path.join(COVERAGE_TMP,"{sample}.bam")  |  awk '{sum+=$3} END { print "Average = ",sum/NR}' > 
        """

rule bwa_index:
    input:
        os.path.join(MEDAKA,"{sample}", "consensus.fasta")
    output:
        os.path.join(MEDAKA,"{sample}", "consensus.fasta.bwt")
    threads:
        BigJobCpu
    conda:
        os.path.join('..', 'envs','short_read_polish.yaml')
    resources:
        mem_mb=BigJobMem
    shell:
        """
        bwa index {input}
        """

rule bwa_mem:
    input:
        os.path.join(MEDAKA,"{sample}", "consensus.fasta"),
        os.path.join(FASTP,"{sample}_1.fastq.gz"),
        os.path.join(FASTP,"{sample}_2.fastq.gz"),
        os.path.join(MEDAKA,"{sample}", "consensus.fasta.bwt")
    output:
        os.path.join(BWA,"{sample}_1.sam"),
        os.path.join(BWA,"{sample}_2.sam")
    threads:
        BigJobCpu
    conda:
        os.path.join('..', 'envs','short_read_polish.yaml')
    resources:
        mem_mb=BigJobMem
    shell:
        """
        bwa mem -t {threads} -a {input[0]} {input[1]} > {output[0]}
        bwa mem -t {threads} -a {input[0]} {input[2]} > {output[1]}
        """
rule polypolish:
    input:
        os.path.join(MEDAKA,"{sample}", "consensus.fasta"),
        os.path.join(BWA,"{sample}_1.sam"),
        os.path.join(BWA,"{sample}_2.sam")
    output:
        os.path.join(POLYPOLISH_OUT,"{sample}.fasta")
    threads:
        BigJobCpu
    params:
        os.path.join(POLYPOLISH_BIN, "polypolish")
    resources:
        mem_mb=BigJobMem
    shell:
        """
        {params[0]} {input[0]} {input[1]} {input[2]} > {output[0]}
        """

rule aggr_polish:
    input:
        expand(os.path.join(POLYPOLISH_OUT,"{sample}.fasta"), sample = SAMPLES )
    output:
        os.path.join(LOGS, "aggr_polish.txt")
    threads:
        1
    resources:
        mem_mb=BigJobMem
    shell:
        """
        touch {output[0]}
        """

