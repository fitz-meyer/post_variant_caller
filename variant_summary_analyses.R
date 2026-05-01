#tidy/pivot/separate variant summary, SNPGenie, and Shannon's outputs
#calculate richness (total polymorphisms) using variant summary
#plot snv frequency by genome position 
library(tidyverse)


#tidy variant summary
#====================

snvs <- read.csv("/Users/emilyfitzmeyer/Desktop/tempStudy_WNV_WGS/variantID_OUTPUT/20260428_LW/variant_summary.csv")

snvs <- snvs %>%
  rename("genome_position" = "position")

snvs_tidy <- snvs %>%
  select(-"reference_sequence", -"featureid", -"gene", -"indel", -"variant",
         -"reference_base", -"variant_base", -starts_with("R"))

snvs_wider <- snvs %>%
  select(-"reference_sequence", -"featureid", -"gene", -"indel", -"variant",
         -"reference_base", -"variant_base", -"codon", -starts_with("R")) %>%
  pivot_longer(cols = starts_with(c("ex")), names_to = "sample_id")

snvs_wider <- snvs_wider %>%
  separate_wider_delim("sample_id", delim = "_", names = c("experiment", "replicate", "condition", "dpi", "sample_type"),
                       cols_remove = FALSE)

# USE IF THERE ARE input samples IN DATAFRAME

# input_tidy <- snvs %>%
#   select(-"reference_sequence", -"featureid", -"gene", -"indel", -"variant",
#          -"reference_base", -"variant_base", -starts_with("ex"))
#
# input <- select(snvs, starts_with("R"), -"reference_sequence", -"reference_base", -"R2_P3_wnv", "genome_position") %>%
#   pivot_longer(cols = starts_with("R"), names_to = "sample_id")
# 
# # chose to write this out and add extra columns in excel
# write.csv(input, "/Users/emilyfitzmeyer/Desktop/temp_input.csv")
# input_test <- read.csv("/Users/emilyfitzmeyer/Desktop/temp_input.csv")
#
# test <- bind_rows(snvs_wider, input_test) %>%
#   select(-"X")
####
# input <- input %>%
#   separate_wider_delim("samples", delim = "_", names = c("replicate", "passage", "virus")) %>%
#   select("genome_position", "replicate", "value")



# filter by SNV frequency
# majority_snvs <- filter(snvs_wider, value >= 0.5)
# 
# fix_snvs <- filter(snvs_wider, value >= 0.9)

# all.df <- bind_rows(snvs, input)

#SNV frequency by genome position
# ===============================
snvs_wider$dpi <- factor(snvs_wider$dpi, levels = c("3dpi", "6dpi", "9dpi", "12dpi", "15dpi", "18dpi", "21dpi", "24dpi", "27dpi", "30dpi"))

plot <- ggplot(snvs_wider[which(snvs_wider$value>0),], aes(x = genome_position, y = value, colour = dpi)) + geom_point() + geom_hline(yintercept = 0.5, linetype = "dotted") +
  facet_wrap(~condition, ncol = 1) +
  scale_y_log10() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1, size = 10)) +
  theme(axis.text.y = element_text(size = 10)) +
  labs(x = "WNV genome position", y = "SNV frequency (log10)")

setwd("/Users/emilyfitzmeyer/Desktop/")
ggsave("BOD_snv_genomePOS.png", plot = plot, device = png(), scale = 1, width = 8, height = 9, dpi = 300)
dev.off()

# PLOT WITH INPUT PANEL 
test$dpi <- factor(test$dpi, levels = c("3dpi", "6dpi", "9dpi", "12dpi", "15dpi", "18dpi", "21dpi", "24dpi", "27dpi", "30dpi"))

input_plot <- ggplot(test[which(test$value>0),], aes(x = genome_position, y = value, colour = dpi)) + geom_point() + geom_hline(yintercept = 0.5, linetype = "dotted") +
  facet_wrap(~condition, ncol = 1) +
  scale_y_log10() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1, size = 10)) +
  theme(axis.text.y = element_text(size = 10)) +
  labs(x = "WNV genome position", y = "SNV frequency (log10)")

setwd("/Users/emilyfitzmeyer/Desktop/")
ggsave("input_snv_genomePOS.png", plot = input_plot, device = png(), scale = 1, width = 8, height = 10.5, dpi = 300)
dev.off()



# Extract total SNVs (total non-zero values in each sample column) and bind with total mapped reads
#==================================================================================================
# convert 'NA' values to '0s' 
#----------------------------
# NOTE - THIS IS ONLY ACCEPTABLE BECAUSE YOU ARE DISREGARDING 0s IN THE FOLLOWING PROCESSES
# IN LOFREQ OUTPUT NA DOES NOT EQUAL 0, 0 MEANS SOMETHING, SO DOES NA

snvs_tidy[is.na(snvs_tidy)] <- 0

# filter dataframe by variables of interest
#------------------------------------------

S_snvs <- filter(snvs_tidy, genome_position <= 2373) %>%
  filter(genome_position >= 97)

NS_snvs <- filter(snvs_tidy, genome_position <= 10398) %>%
  filter(genome_position >= 2374)

# mis_snvs <- filter(snvs_tidy, effect == "missense")
# 
# syn_snvs <- filter(snvs_tidy, effect == "synonymous")

# pull sample columns
# replace df with filtered dfs above if examining specific variables

samples <- select(S_snvs, starts_with("ex"))
nrow(samples) #this value +1 is what you use for slice() on line 91



#set frequency threshold
# use !=0 for total SNVs
total_snvs <- colSums(samples !=0)
# use >= for specific SNV frequency 
#total_snvs <- colSums(samples >=0.5)
#total_snvs <- colSums(samples >=0.9)

total_snvs <- rbind(samples, total_snvs) %>%
  slice(313)

total_wider <- total_snvs %>%
  pivot_longer(cols = starts_with(c("ex")), names_to = "sample_id")

total_wider <- total_wider %>%
  separate_wider_delim("sample_id", delim = "_", names = c("experiment", "replicate", "condition", "dpi", "sample_type"),
                       cols_remove = FALSE)

write.csv(total_wider, "/Users/emilyfitzmeyer/Desktop/total_S_LWsnvs.csv")


# MERGE WITH MAPPED READS
# =======================

# mapped_reads <- read.delim("/Users/emilyfitzmeyer/Desktop/tempStudy_WNV_WGS/variantID_OUTPUT/20260327_variantID/all_read_counts.txt")
# 
# mapped_reads <- mapped_reads %>%
#   filter(count_type == "refseq_aligned")
# 
# totalSNVs_mappedReads <- merge(total_wider, mapped_reads, by = "sample_id")
# 
# write.csv(total_wider, "/Users/emilyfitzmeyer/Desktop/total_fixed90snvs.csv")
# 
# 
# shan <- read.csv("/Users/emilyfitzmeyer/Desktop/tempStudy_WNV_WGS/variantID_OUTPUT/20260327_variantID/shannon_complexity_per_sample.csv")
# merge <- merge(shan, mapped_reads, by = "sample_id")
# write.csv(merge, "/Users/emilyfitzmeyer/Desktop/shan_mappedRead.csv")





# separate wider sample IDs and dN/dS values
# ==========================================
#tidied in excel - otherwise would have to add some str_replace fuckery here to get the sample IDs right
#LOLOLOL you had to anyway

dnds <- read.csv("/Users/emilyfitzmeyer/Desktop/20260330_dNdS_values.csv")

dnds <- mutate(dnds, sample_id = str_replace_all(sample, "-", "_")) 
dnds <- select(dnds, c(7,2:6))

dnds_wider <- dnds %>%
  separate_wider_delim("sample_id", delim = "_", names = c("experiment", "replicate", "condition", "dpi", "sample_type"),
                       cols_remove = FALSE)

write.csv(dnds_wider, "/Users/emilyfitzmeyer/Desktop/dnds_wider.csv")



# separate wider Shannon values
#==============================

shan <- read.csv("/Users/emilyfitzmeyer/Desktop/shannon_complexity_per_sample.csv")

shan_wider <- shan %>%
  separate_wider_delim("sample", delim = "_", names = c("experiment", "replicate", "condition", "dpi", "sample_type"),
                       cols_remove = FALSE)

write.csv(shan_wider, "/Users/emilyfitzmeyer/Desktop/shan_wider.csv")
















#sense vs missense SNVs per condition - deprecated lol 

df <- data.frame(matrix(ncol = 5))
names(df) <- c("condition", "t_r1syn", "t_r2syn", "t_r1mis", "t_r2mis")

for (cond in unique(all.df$condition)) {
  
  i <- all.df$condition == cond #logical index
  
  r1syn <- all.df %>%
    filter(condition == cond, replicate == "r1", value != 0, effect == "synonymous") %>%
    nrow()
  r2syn <- all.df %>%
    filter(condition == cond, replicate == "r2", value != 0, effect == "synonymous") %>%
    nrow()
  r1mis <- all.df %>%
    filter(condition == cond, replicate == "r1", value != 0, effect == "missense") %>%
    nrow()
  r2mis <- all.df %>%
    filter(condition == cond, replicate == "r2", value != 0, effect == "missense") %>%
    nrow()
  
  x <- c(condition=cond, t_r1syn=r1syn, t_r2syn=r2syn, t_r1mis=r1mis, t_r2mis=r2mis)
  df <- rbind(df, x)
}

#note NTC row will always contain all 0s because NTC samples have no replicate designations

df <- df %>% slice(-1, -8)
write.csv(df2, "/Users/emilyfitzmeyer/Desktop/df2.csv")

#low vs high freq SNVs per condition

df25 <- data.frame(matrix(ncol = 5))
names(df25) <- c("condition", "t_r1L25", "t_r2L25", "t_r1G25", "t_r2G25")

for (cond in unique(all.df$condition)) {
  
  i <- all.df$condition == cond #logical index
  
  r1L25 <- all.df %>%
    filter(condition == cond, replicate == "r1", effect %in% c("missense", "synonymous"), value != 0, value < 0.25) %>%
    nrow()
  r2L25 <- all.df %>%
    filter(condition == cond, replicate == "r2", effect %in% c("missense", "synonymous"), value != 0, value < 0.25) %>%
    nrow()
  r1G25 <- all.df %>%
    filter(condition == cond, replicate == "r1", effect %in% c("missense", "synonymous"), value != 0, value > 0.25) %>%
    nrow()
  r2G25 <- all.df %>%
    filter(condition == cond, replicate == "r2", effect %in% c("missense", "synonymous"), value != 0, value > 0.25) %>%
    nrow()
  
  x <- c(condition=cond, t_r1L25=r1L25, t_r2L25=r2L25, t_r1G25=r1G25, t_r2G25=r2G25)
  df25 <- rbind(df25, x)
}

df25 <- df25 %>% slice(-1, -8)
write.csv(df25, "/Users/emilyfitzmeyer/Desktop/df25.csv")




