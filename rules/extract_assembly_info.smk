
rule extract_assembly_infor:
    input:
        os.path.join(ASSEMBLIES,"{sample}", "assembly_info.txt")
    output:
        os.path.join(ASSEMBLY_INFO,"{sample}_assembly_info.txt")
    threads:
        1
    resources:
        mem_mb=BigJobMem
    shell:
        """
        cp {input[0]} {output[0]}
        """

rule aggr_assembly_info:
    """Aggregate."""
    input:
        expand(os.path.join(ASSEMBLY_INFO,"{sample}_assembly_info.txt"), sample = SAMPLES)
    output:
        os.path.join(LOGS, "aggr_assembly_info.txt")
    threads:
        1
    resources:
        mem_mb=BigJobMem
    shell:
        """
        touch {output[0]}
        """