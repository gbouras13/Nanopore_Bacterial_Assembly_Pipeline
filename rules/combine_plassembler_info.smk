
rule combine_plassembler_info:
    input:
        summaries = expand(os.path.join(PLASSEMBLER_SUMMARIES, "{sample}.tsv"), sample = SAMPLES)
    output:
        os.path.join(SUMMARY_OUT,"plassembler_assembly_info.txt")
    conda:
        os.path.join('..', 'envs','scripts.yaml')
    resources:
        mem_mb=SmallJobMem,
        time=5,
        th=1
    script:
        """
        '../scripts/combine_plassembler_info.py'
        """


rule aggr_combine_plassembler_info:
    """Aggregate."""
    input:
        os.path.join(SUMMARY_OUT,"plassembler_assembly_info.txt")
    output:
        os.path.join(LOGS, "aggr_combine_plassembler_info.txt")
    resources:
        mem_mb=SmallJobMem,
        time=2,
        th=1
    shell:
        """
        touch {output[0]}
        """