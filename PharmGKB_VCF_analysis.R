library(dplyr)
library(tidyr)
args <- commandArgs(trailingOnly = TRUE) # accept input file and output file name from the user
seqName <- args[1] # push input file i.e. seq no. in an variable
output_data <- args[2]

df_clean <- read.delim(file = "Pharmacogenetics.csv", header = TRUE, sep = ",")
snp <- read.csv(file = "SNP_ALLELE-pharmGCK.csv", header = TRUE)

#vc <- read.delim(file = "10396201_195.bwa.sortdup.bqsr.hc4.vcf_edit.txt", header = TRUE)
vc <- read.delim(seqName, header = TRUE)
sjoined <- left_join(df_clean, vc, by = c("Variant"))
dff_clean <- sjoined[complete.cases(sjoined), ]

vc_data <- dff_clean
snp_data <- snp
##
# Sort datasets based on Clinical.Annotation.ID
vc_data <- vc_data %>%
  arrange(Clinical.Annotation.ID)
snp_data <- snp_data %>%
  arrange(Clinical.Annotation.ID)

# Initialize the Result dataset
result_columns <- c(
  'Clinical.Annotation.ID', 'Gene', 'Level.of.Evidence',
  'Score', 'Phenotype.Category', 'Drug', 'Phenotype', 'CHROM', 'POS',
  'QUAL', 'INFO', 'REF', 'ALT', 'Annotation.Text'
)
result_data <- data.frame(matrix(nrow = 0, ncol = length(result_columns)))
colnames(result_data) <- result_columns

###

# Loop through VC dataset
for (i in 1:nrow(vc_data)) {
  vc_id <- vc_data$Clinical.Annotation.ID[i]
  vc_ref <- vc_data$REF[i]
  vc_alt <- vc_data$ALT[i]
  vc_annotation_text <- vc_data$Annotation.Text[i]
  
  # Find matching rows in SNP dataset
  matching_snps <- snp_data %>%
    filter(Clinical.Annotation.ID == vc_id, REF == vc_ref, ALT == vc_alt)
  
  if (nrow(matching_snps) > 0) {
    for (j in 1:nrow(matching_snps)) {
      result_data <- rbind(result_data, c(
        vc_id, vc_data$Gene[i], vc_data$Level.of.Evidence[i], vc_data$Level.Modifiers[i],
        vc_data$Score[i], vc_data$Phenotype.Category[i], vc_data$Drug[i], vc_data$Phenotype[i],
        vc_data$CHROM[i], vc_data$POS[i], vc_data$QUAL[i], vc_data$INFO[i],
        matching_snps$REF[j], matching_snps$ALT[j], matching_snps$Annotation.Text[j]
      ))
    }
  } else {
    row <- c(
      vc_id, vc_data$Gene[i], vc_data$Level.of.Evidence[i], vc_data$Level.Modifiers[i],
      vc_data$Score[i], vc_data$Phenotype.Category[i], vc_data$Drug[i], vc_data$Phenotype[i],
      vc_data$CHROM[i], vc_data$POS[i], vc_data$QUAL[i], vc_data$INFO[i],
      vc_ref, vc_alt, NA  # Set NA directly here
    )
    result_data <- rbind(result_data, row)
  }
}

# Remove row names (headers)
colnames(result_data) <- NULL

# Assign column names to result_data
colnames(result_data) <- result_columns

# Add column names to result_data
colnames(result_data) <- result_columns

# Save the Result dataset to a CSV file
#write_csv(result_data, 'Pharmaco_result_dataset_unfiltered.csv', col_names = TRUE)
filtered_final <- result_data %>%
  filter(Annotation.Text != 'NA')
write.csv(filtered_final, paste0(output_data, ".csv"), row.names = FALSE)