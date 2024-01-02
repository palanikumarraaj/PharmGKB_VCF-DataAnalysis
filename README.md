# PharmGKB_VCF-DataAnalysis
PharmGKB DB usage in VCF files

- This script uses R with VCF file specific preparation of VCF required
- VCF should contains lines from #CHROM as starting
- Formation of certain VCF format can be done in linux terminal or also by manual removal

## Usage

Step 1:

> cat input-properVCF-file.vcf | grep -v "##" > Prepared.vcf

- This can also be done by removing all lines that has ## as starting in the VCF file

Step 2:

> Rscript PharmGKB_VCF_analysis.R Prepared.vcf output-file-name

- The Rscript will take the input VCF file and generate .csv file as output
- The CSV output file has same prefix as the input VCF file
- output-file-name can be given by user to make .csv file output

## Conditions

- Make sure VCF file is annotated properly for getting ID. The complete script depends on ID column data.
- Make sure VCF format is proper with starting line is from #CHROM line as usually present.
- Make sure to provide input file name properly with extension and provide output file name alone


## Columns available in .csv file

- The same model output file is also present for reference.

```sh
Clinical.Annotation.ID	Gene	Level.of.Evidence	Score	Phenotype.Category	Drug	Phenotype	CHROM	POS	QUAL	INFO	REF	ALT	Annotation.Text
```

## Note

- PharmGKB is downloaded and used for this analysis on August 2023.
- Feel free to update the script or DB for your usage
