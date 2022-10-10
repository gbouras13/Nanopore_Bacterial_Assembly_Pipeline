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
        directory(os.path.join(PLASSEMBLER,"{sample}")),
        os.path.join(PLASSEMBLER,"{sample}", "plassembler_plasmids.fasta"),
        os.path.join(PLASSEMBLER,"{sample}", "plassembler_copy_number_summary.tsv")
    conda:
        os.path.join('..', 'envs','plassembler.yaml')
    resources:
        mem_mb=BigJobMem,
        time=300,
        th=BigJobCpu
    shell:
        """
        plassembler.py -l {input[0]} -o {output[0]} -s1 {input[1]} -s2 {input[1]} -m 1000 -t {resources.th} -c 2500000 -f
        """

rule plassembler_move_fastas:
    input:
        os.path.join(PLASSEMBLER,"{sample}", "plassembler_plasmids.fasta")
    output:
        os.path.join(PLASSEMBLER_FASTAS, "{sample}.fasta")
    resources:
        mem_mb=SmallJobMem,
        time=2,
        th=1
    shell:
        """
        cp {input[0]} {output[0]}
        """
        
rule plassembler_move_summaries:
    input:
        os.path.join(PLASSEMBLER,"{sample}", "plassembler_copy_number_summary.tsv")
    output:
        os.path.join(PLASSEMBLER_SUMMARIES, "{sample}.tsv")
    resources:
        mem_mb=SmallJobMem,
        time=2
    shell:
        """
        cp {input[0]} {output[0]}
        """

rule aggr_plassembler:
    """Aggregate."""
    input:
        expand(os.path.join(PLASSEMBLER_FASTAS, "{sample}.fasta"), sample = SAMPLES),
        expand(os.path.join(PLASSEMBLER_SUMMARIES, "{sample}.tsv"), sample = SAMPLES)
    output:
        os.path.join(LOGS, "aggr_plasembler.txt")
    resources:
        mem_mb=SmallJobMem,
        time=2
    shell:
        """
        touch {output[0]}
        """
