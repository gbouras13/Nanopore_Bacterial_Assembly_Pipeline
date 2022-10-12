def get_input_r1(wildcards):
    return dictReads[wildcards.sample]["R1"]
def get_input_r2(wildcards):
    return dictReads[wildcards.sample]["R2"]
def get_input_fastqs(wildcards):
    return dictReads[wildcards.sample]["LR"]



rule medaka:
    input:
        os.path.join(CHROMOSOME,"{sample}.fasta"),
        get_input_fastqs
    output:
        directory(os.path.join(MEDAKA,"{sample}")),
        os.path.join(MEDAKA,"{sample}", "consensus.fasta")
    threads:
        BigJobCpu
    conda:
        os.path.join('..', 'envs','medaka.yaml')
    resources:
        mem_mb=BigJobMem,
        time=300,
        th=BigJobCpu
    shell:
        """
        export HOME=/hpcfs/users/a1667917
        medaka_consensus -i {input[1]} -d {input[0]} -o {output[0]} -m r941_min_sup_g507  -t {threads}
        """

rule fastp:
    input:
        get_input_r1,
        get_input_r2
    output:
        os.path.join(FASTP,"{sample}_1.fastq.gz"),
        os.path.join(FASTP,"{sample}_2.fastq.gz")
    threads:
        BigJobCpu
    conda:
        os.path.join('..', 'envs','short_read_polish.yaml')
    resources:
        mem_mb=BigJobMem,
        time=120,
        th=BigJobCpu
    shell:
        """
        fastp --in1 {input[0]} --in2 {input[1]} --out1 {output[0]} --out2 {output[1]} 
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
        mem_mb=BigJobMem,
        th=BigJobCpu
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
        mem_mb=BigJobMem,
        time=300,
        th=BigJobCpu
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
        os.path.join(POLYPOLISH_OUT_RD_1,"{sample}.fasta")
    threads:
        8
    conda:
        os.path.join('..', 'envs','polypolish.yaml')
    resources:
        mem_mb=SmallJobMem,
        time=60,
        th=8
    shell:
        """
        polypolish {input[0]} {input[1]} {input[2]} > {output[0]}
        """

rule dnaapler:
    input:
        os.path.join(POLYPOLISH_OUT_RD_1, "{sample}.fasta")
    output:
        os.path.join(DNAAPLER, "{sample}", "{sample}_reoriented.fasta")
    threads:
        BigJobCpu
    conda:
        os.path.join('..', 'envs','dnaapler.yaml')
    params:
        os.path.join(DNAAPLER, "{sample}")
    resources:
        mem_mb=BigJobMem,
        time=120,
        th=8
    shell:
        """
        dnaapler.py -c {input[0]} -o {params[0]} -p {wildcards.sample} -t {resources.th} -f
        """

rule bwa_index_round_2:
    input:
        os.path.join(DNAAPLER, "{sample}", "{sample}_reoriented.fasta")
    output:
        os.path.join(DNAAPLER, "{sample}", "{sample}_reoriented.fasta.bwt")
    threads:
        BigJobCpu
    conda:
        os.path.join('..', 'envs','short_read_polish.yaml')
    resources:
        mem_mb=BigJobMem,
        th=BigJobCpu
    shell:
        """
        bwa index {input}
        """

rule bwa_mem_round_2:
    input:
        os.path.join(DNAAPLER, "{sample}", "{sample}_reoriented.fasta"),
        os.path.join(FASTP,"{sample}_1.fastq.gz"),
        os.path.join(FASTP,"{sample}_2.fastq.gz"),
        os.path.join(DNAAPLER, "{sample}", "{sample}_reoriented.fasta.bwt")
    output:
        os.path.join(BWA_ROUND2,"{sample}_1.sam"),
        os.path.join(BWA_ROUND2,"{sample}_2.sam")
    threads:
        BigJobCpu
    conda:
        os.path.join('..', 'envs','short_read_polish.yaml')
    resources:
        mem_mb=BigJobMem,
        time=300,
        th=BigJobCpu
    shell:
        """
        bwa mem -t {threads} -a {input[0]} {input[1]} > {output[0]}
        bwa mem -t {threads} -a {input[0]} {input[2]} > {output[1]}
        """


rule polypolish_round_2:
    input:
        os.path.join(DNAAPLER, "{sample}", "{sample}_reoriented.fasta"),
        os.path.join(BWA_ROUND2,"{sample}_1.sam"),
        os.path.join(BWA_ROUND2,"{sample}_2.sam")
    output:
        os.path.join(POLYPOLISH_OUT_RD_2,"{sample}.fasta")
    threads:
        BigJobCpu
    conda:
        os.path.join('..', 'envs','polypolish.yaml')
    resources:
        mem_mb=BigJobMem,
        time=120,
        th=BigJobCpu
    shell:
        """
        polypolish {input[0]} {input[1]} {input[2]} > {output[0]}
        """

rule aggr_polish:
    input:
        expand(os.path.join(POLYPOLISH_OUT_RD_2,"{sample}.fasta"), sample = SAMPLES )
    output:
        os.path.join(LOGS, "aggr_polish.txt")
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