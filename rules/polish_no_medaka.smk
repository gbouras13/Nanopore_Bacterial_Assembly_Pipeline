def get_input_r1(wildcards):
    return dictReads[wildcards.sample]["R1"]
def get_input_r2(wildcards):
    return dictReads[wildcards.sample]["R2"]


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
        os.path.join(ASSEMBLIES,"{sample}", "assembly.fasta")
    output:
        os.path.join(ASSEMBLIES,"{sample}", "assembly.fasta.bwt")
    threads:
        BigJobCpu
    conda:
        os.path.join('..', 'envs','short_read_polish.yaml')
    resources:
        mem_mb=BigJobMem,
        time=60
    shell:
        """
        bwa index {input}
        """

rule bwa_mem:
    input:
        os.path.join(ASSEMBLIES,"{sample}", "assembly.fasta"),
        os.path.join(FASTP,"{sample}_1.fastq.gz"),
        os.path.join(FASTP,"{sample}_2.fastq.gz"),
        os.path.join(ASSEMBLIES,"{sample}", "assembly.fasta.bwt")
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
        os.path.join(ASSEMBLIES,"{sample}", "assembly.fasta"),
        os.path.join(BWA,"{sample}_1.sam"),
        os.path.join(BWA,"{sample}_2.sam")
    output:
        os.path.join(POLYPOLISH_OUT,"{sample}.fasta")
    threads:
        BigJobCpu
    params:
        os.path.join(POLYPOLISH_BIN, "polypolish")
    resources:
        mem_mb=BigJobMem,
        time=180,
        th=BigJobCpu
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
        mem_mb=SmallJobMem,
        time=2,
        th=1
    shell:
        """
        touch {output[0]}
        """

