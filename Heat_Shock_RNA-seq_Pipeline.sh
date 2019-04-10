# Author Will Schreiner
# This Pipeline was used to analyze RNA expression in HS in C. elegans
# Make sure you have the following programs installed: STAR, samtools, featureCounts,

# First Build the genome with STAR

STAR --runThreadN 8 --runMode genomeGenerate --genomeDir ~/genomes/c_elegans_235 --genomeFastaFiles ~/genomes/Caenorhabditis_elegans.WBcel235.dna.toplevel.fa 
--sjdbGTFfile ~/genomes/Caenorhabditis_elegans.WBcel235.88.gtf

# Align reads with STAR, sortoutput CTR_1,2,3 and HS_1,2,3 were renamed Sample1,2,3..etc for simplicity
# If you do the same for your samples you can likley run this code as is, just change the path for the files


for fn in Sample{1..6}
do
STAR  --runThreadN 8 --genomeDir ~/genomes/c_elegans_235  --genomeLoad NoSharedMemory   --readFilesIn ~/scratch/a_new_chronic/${fn}-R1.fastq  ~/scratch/a_new_chronic/${fn}-R2.fastq  --outFileNamePrefix ~/scratch/nuevo/att_1/${fn}  --outReadsUnmapped Fastx   --outFilterScoreMinOverLread 0.5   --outFilterMatchNminOverLread 0.5   --outFilterMismatchNmax 5  --outFilterMismatchNoverLmax 0.05   --alignIntronMax 5000
done

cd ~/scratch/nuevo/att_1

module load samtools



for s in Sample{1..6}Aligned.out.sam
do
    samtools sort ${s} > ${s}.sorted.bam
done

for s in Sample{1..6}Aligned.out.sam.sorted.bam
do
    samtools index ${s}
done

# Get the reads using featureCounts

featureCounts -p -s 2 -T 8 -O -B -a ~/annotations/c_elegans_annotations/Caenorhabditis_elegans.WBcel235.88.gtf -o feature_counts_s2_all_bam.txt ~/scratch/nuevo/att_1/*.sorted.bam
