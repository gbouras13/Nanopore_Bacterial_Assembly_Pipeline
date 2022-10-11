rule assemble:
    input:
        os.path.join(TMP,"{sample}_filt_trim.fastq.gz")
    output:
        directory(os.path.join(ASSEMBLIES,"{sample}")),
        os.path.join(ASSEMBLIES,"{sample}", "assembly.fasta"),
        os.path.join(ASSEMBLIES,"{sample}", "assembly_info.txt")
    conda:
        os.path.join('..', 'envs','assemble.yaml')
    resources:
        mem_mb=BigJobMem,
        time=300,
        th=BigJobCpu
    params:
        MIN_CHROM_LENGTH
    shell:
        """
        flye --nano-hq {input[0]} -t {resources.th} --asm-coverage 50 --genome-size {params[0]} --out-dir {output[0]}
        """

rule aggr_assemble:
    input:
        expand(os.path.join(ASSEMBLIES,"{sample}", "assembly.fasta"), sample = SAMPLES),
        expand(os.path.join(ASSEMBLIES,"{sample}", "assembly_info.txt"), sample = SAMPLES)
    output:
        os.path.join(LOGS, "aggr_assemble.txt")
    resources:
        mem_mb=SmallJobMem,
        time=2,
        th=1
    shell:
        """
        touch {output[0]}
        """
