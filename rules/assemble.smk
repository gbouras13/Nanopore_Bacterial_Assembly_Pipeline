#### if you want to only look at the unmapped READS
#### I have decided to look at them all for now

rule prokka:
    """Run prokka."""
    input:
        os.path.join(FASTQS, "{sample}.fastq.gz")
    output:
        os.path.join(OUTPUT,"{sample}"),
        os.path.join(OUTPUT,"{sample}", "assembly.fasta")
    conda:
        os.path.join('..', 'envs','assemble.yaml')
    threads:
        BigJobCpu
    resources:
        mem_mb=BigJobMem
    shell:
        """
        flye --nano-raw {input[0]} -t {threads} --genome-size 4m  --asm-coverage 50 --out-dir {output[0]}
        """

#### aggregation rule

rule aggr_assemble:
    """Aggregate."""
    input:
        expand(os.path.join(OUTPUT,"{sample}", "assembly.fasta"), sample = SAMPLES)
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
