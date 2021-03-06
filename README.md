## TAGSeq analyis
**Author: TASLIMA HAQUE**
**Last Modified: March 4,2021**

This pipe is designed for 3-tag RNASeq analyis on stampede2.This will provide the count matrix
for all samples from raw fastq files. You need your raw files, reference genome
file, corresponding gene annotation file and featureCounts installed in your
directory.

You will find the following folders ordered by number to run the whole pipe.

00-qual-report  01-qual-filter  02-mapping  03-map-filter  04-Count

Shell scripts start with make-* is to make param file for samples.

**00-qual-report:**
It will provide the quality reports of individual samples running by FastQC.
You need to run this once again after quality filter of raw reads to check
your filtering parameters and redo filter if needed.

"make-qr-param.sh" will generate param file for quality report
```
$ sh make-qr-param.sh </raw-fastq-path/> </output-path/>
```
QualReport.sh will run the "Qual-File.param" file in batch

```
$ sh QualReport.sh
```

**01-qual-filter**
This step will filter raw reads using cutadapt. Please use your own set of
parameters depending on which adapter you have in which strand and other options
such as trimming few bases from the beginning of your sequence (we have degerated
primer at the very beginning of forward read so usually trim first 9 bases; looking
into your k-mer profile you may need to trim few more), length of polyA or polyT,
minimum read length to keep and many more. Sometimes all the tags for cutadapt don't
work together therefore, I have pipe to run all of them in a single task. Add/Remove
pipe as per your required params.

"make-cutadapt-param.sh" will generate param file
```
$ sh make-cutadapt-param.sh </raw-fastq-path/> </output-path/>
```
Cutadapt.sh will run "cutadapt.param" file in batch

```
$ sh Cutadapt.sh
```

**02-mapping**
Here I have used bwa mem algorithm to map filtered reads against reference genome.
You need to build index for your reference genome before running this mapping step.

```
$ bwa index <fasta_reference> # you can run it in logging node, it doesn't take much time
```
Set -t (number of cpu) as per your need and don't forget to use -M tag of bwa mem.

"make-bwa-param.sh" will make param file for samples

```
$ make-bwa-param.sh </filtered-fastq-path/> </output-path/> </reference/>
```

"BWA.sh" will run the param "bwa.param" in batch

```
$ sh BWA.sh
```

**03-map-filter**
This step will filter out ambiguious alignments using mapping quality.I have modified
my sample name here in line 32.Change as per your sample file name to get the sample
ID field from your map file.

"make-samtool-filter.sh" will generate param file to filter mapped reads using mapping quality

```
$ make-samtool-filter.sh in/dir out/dir
```

"SamtoolFilter.sh" will run the "filter.param" param file in batch

```
$ sh SamtoolFilter.sh
```

**04-Count**
I have used FeatureCounts to count read per gene.You have to install this program and point
the installation directory correctly in line 12.You will find the source code here:

http://subread.sourceforge.net/

To run Featurecount you also need your gene annotation file.

At this step and depending on your annotation file set your -t and -g field.Please check
the options of featureCounts before running. This steo will take all the samples together
and the output will be a matrix where column represent your samples and row represents gene/
transcripts.


"make-featurecount.sh" will generate a single line param file for all the samples

```
$ sh make-featurecount.sh in/dir out/dir annotation/file
```

"FeatureCounts.sh" will run the param file, "featureCounts.param". Keep in mind that it is a single job.
So, set your sbatch option accordingly

```
sh FeatureCounts.sh
```

If you have any query for the pipe please contact me : **taslima@utexas.edu**
