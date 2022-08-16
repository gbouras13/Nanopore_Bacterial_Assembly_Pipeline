"""
Function for parsing the 'Assemblies' config and identifying samples and read files
"""

from itertools import chain

def samplesFromDirectory(dir):
    """Parse samples from a directory"""
    outDict = {}
    # https://stackoverflow.com/questions/11860476/how-to-unnest-a-nested-list
    samples= glob_wildcards(os.path.join(dir,'{sample}.fastq.gz'))
    samples2 = chain(*samples)
    for sample in samples2:
        outDict[sample] = {}
        fastq = os.path.join(dir,f'{sample}.fastq.gz')
        if os.path.isfile(fastq):
            outDict[sample]['fastq'] = fastq
        else:
            sys.stderr.write("\n"
                             "    FATAL: Error globbing files."
                             f"    {fastq} \n"
                             "    does not exist. Ensure consistent formatting and file extensions."
                             "\n")
            sys.exit(1)
    return outDict

def samplesFromCsv(csvFile):
    """Read samples and files from a CSV"""
    outDict = {}
    with open(csvFile,'r') as csv:
        for line in csv:
            l = line.strip().split(',')
            if len(l) == 4:
                outDict[l[0]] = {}
                if os.path.isfile(l[1]) and os.path.isfile(l[2]) and os.path.isfile(l[3]):
                    outDict[l[0]]['LR'] = l[1]
                    outDict[l[0]]['R1'] = l[2]
                    outDict[l[0]]['R2'] = l[3]
                else:
                    sys.stderr.write("\n"
                                     f"    FATAL: Error parsing {csvFile}. One of \n"
                                     f"    {l[1]} or \n"
                                     f"    {l[2]} or \n"
                                     f"    {l[3]} \n"
                                     "    does not exist. Check formatting, and that \n" 
                                     "    file names and file paths are correct.\n"
                                     "\n")
                    sys.exit(1)
    return outDict

def parseSamples(csvfile):
    # for reading from directory
    #if os.path.isdir(readFileDir):
    #   sampleDict = samplesFromDirectory(readFileDir)
    if os.path.isfile(csvfile):
        sampleDict = samplesFromCsv(csvfile)
    else:
        sys.stderr.write("\n"
                         f"    FATAL: {csvfile} is neither a file nor directory.\n"
                         "\n")
        sys.exit(1)
    if len(sampleDict.keys()) == 0:
        sys.stderr.write("\n"
                         "    FATAL: We could not detect any samples at all.\n"
                         "\n")
        sys.exit(1)
    return sampleDict


