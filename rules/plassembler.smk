def get_input_r1(wildcards):
    return dictReads[wildcards.sample]["R1"]
def get_input_r2(wildcards):
    return dictReads[wildcards.sample]["R2"]
def get_input_lr(wildcards):
    return dictReads[wildcards.sample]["LR"]


rule plassembler:
    input:
        get_input_lr,
        get_input_r1,
        get_input_r2
    output:
        os.path.join(PLASSEMBLER,"{sample}"),
        os.path.join(PLASSEMBLER,"{sample}", "plassembler_plasmids.fasta")
    conda:
        os.path.join('..', 'envs','plassembler.yaml')
    threads:
        BigJobCpu
    resources:
        mem_mb=BigJobMem
    shell:
        """
        plassembler.py -l {input[0]} -o {output[0]} -s1 {input[1]} -s2 {input[1]} -m 1000 -t {threads} -c 2500000 
        """

rule aggr_plassembler:
    """Aggregate."""
    input:
        expand(os.path.join(PLASSEMBLER,"{sample}", "plassembler_plasmids.fasta"), sample = SAMPLES)
    output:
        os.path.join(LOGS, "aggr_plasembler.txt")
    threads:
        1
    resources:
        mem_mb=BigJobMem
    shell:
        """
        touch {output[0]}
        """