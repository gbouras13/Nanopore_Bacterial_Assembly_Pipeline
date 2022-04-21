def get_input_fastqs(wildcards):
    return dictReads[wildcards.sample]["LR"]

rule assemble:
    input:
        get_input_fastqs
    output:
        directory(os.path.join(ASSEMBLIES,"{sample}")),
        os.path.join(ASSEMBLIES,"{sample}", "assembly.fasta"),
        os.path.join(ASSEMBLIES,"{sample}", "assembly_info.txt")
    threads:
        BigJobCpu
    conda:
        os.path.join('..', 'envs','assemble.yaml')
    resources:
        mem_mb=BigJobMem
    shell:
        """
        flye --nano-raw {input[0]} -t {threads} --genome-size 4m  --asm-coverage 50 --out-dir {output[0]}
        """

rule aggr_assemble:
    input:
        expand(os.path.join(ASSEMBLIES,"{sample}", "assembly.fasta"), sample = SAMPLES),
        expand(os.path.join(ASSEMBLIES,"{sample}", "assembly_info.txt"), sample = SAMPLES)
    output:
        os.path.join(LOGS, "aggr_assemble.txt")
    threads:
        1
    resources:
        mem_mb=BigJobMem
    shell:
        """
        touch {output[0]}
        """
