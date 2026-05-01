# Merge richness, dN/dS, pi, and Shannon's data 
# Match sets 
library(tidyverse)

# BODY

setwd("/Users/emilyfitzmeyer/Desktop/tempStudy_WNV_WGS/variantID_OUTPUT/20260429_BOD/")

bod_poly <- read.csv("total_BODsnvs.csv") %>%
  select("sample_id", "value") %>%
  rename("BOD_total_poly" = "value")

bod_Spoly <- read.csv("total_S_BODsnvs.csv") %>%
  select("sample_id", "value") %>%
  rename("BOD_total_Spoly" = "value")

bod_NSpoly <- read.csv("total_NS_BODsnvs.csv") %>%
  select("sample_id", "value") %>%
  rename("BOD_total_NSpoly" = "value")

bod_shannon <- read.csv("shannon_BOD_20260429.csv") %>%
  select("sample_id", "shannon") %>%
  rename("BOD_shannon" = "shannon")

bod_dn.ds <- read.csv("snpGenie_20260429_bod/dNdS_values.csv") %>%
  select("sample_id", "pi", "sites_polymorphic", "dN.dS", "piN.piS") %>%
  rename("BOD_pi" = "pi") %>%
  rename("BOD_snpgenieSNVs" = "sites_polymorphic") %>%
  rename("BOD_dn.ds" = "dN.dS") %>%
  rename("BOD_pin.pis" = "piN.piS")

# list
BOD_list <- list(bod_poly, bod_Spoly, bod_NSpoly, bod_shannon, bod_dn.ds)

# merge 
BOD <- BOD_list %>% reduce(full_join, by = "sample_id")



# LEGS AND WINGS

setwd("/Users/emilyfitzmeyer/Desktop/tempStudy_WNV_WGS/variantID_OUTPUT/20260428_LW/")

lw_poly <- read.csv("total_LWsnvs.csv") %>%
  select("sample_id", "value") %>%
  rename("LW_total_poly" = "value")

lw_Spoly <- read.csv("total_S_LWsnvs.csv") %>%
  select("sample_id", "value") %>%
  rename("LW_total_Spoly" = "value")

lw_NSpoly <- read.csv("total_NS_LWsnvs.csv") %>%
  select("sample_id", "value") %>%
  rename("LW_total_NSpoly" = "value")

lw_shannon <- read.csv("shannon_LW_20260428.csv") %>%
  select("sample_id", "shannon") %>%
  rename("LW_shannon" = "shannon")

lw_dn.ds <- read.csv("snpGenie_20260428_lw/dNdS_values.csv") %>%
  select("sample_id", "pi", "sites_polymorphic", "dN.dS", "piN.piS") %>%
  rename("LW_pi" = "pi") %>%
  rename("LW_snpgenieSNVs" = "sites_polymorphic") %>%
  rename("LW_dn.ds" = "dN.dS") %>%
  rename("LW_pin.pis" = "piN.piS")

# list
LW_list <- list(lw_poly, lw_Spoly, lw_NSpoly, lw_shannon, lw_dn.ds)

# Merge all dataframes by 'id'
LW <- LW_list %>% reduce(full_join, by = "sample_id")



# SALIVA

setwd("/Users/emilyfitzmeyer/Desktop/tempStudy_WNV_WGS/variantID_OUTPUT/20260430_SAL/")

sal_poly <- read.csv("total_SALsnvs.csv") %>%
  select("sample_id", "value") %>%
  rename("SAL_total_poly" = "value")

sal_Spoly <- read.csv("total_S_SALsnvs.csv") %>%
  select("sample_id", "value") %>%
  rename("SAL_total_Spoly" = "value")

sal_NSpoly <- read.csv("total_NS_SALsnvs.csv") %>%
  select("sample_id", "value") %>%
  rename("SAL_total_NSpoly" = "value")

sal_shannon <- read.csv("shannon_SAL_20260430.csv") %>%
  select("sample_id", "shannon") %>%
  rename("SAL_shannon" = "shannon")

sal_dn.ds <- read.csv("snpGenie_20260430_sal/dNdS_values.csv") %>%
  select("sample_id", "pi", "sites_polymorphic", "dN.dS", "piN.piS") %>%
  rename("SAL_pi" = "pi") %>%
  rename("SAL_snpgenieSNVs" = "sites_polymorphic") %>%
  rename("SAL_dn.ds" = "dN.dS") %>%
  rename("SAL_pin.pis" = "piN.piS")

# list
SAL_list <- list(sal_poly, sal_Spoly, sal_NSpoly, sal_shannon, sal_dn.ds)

# Merge all dataframes by 'id'
SAL <- SAL_list %>% reduce(full_join, by = "sample_id")


view(BOD_df)
head(BOD_df)


BOD_df <- BOD_df %>%
  mutate("base_id" = str_remove(sample_id, "body"))

LW_df <- LW_df %>%
  mutate("base_id" = str_remove(sample_id, "legswings"))

SAL_df <- SAL_df %>%
  mutate("base_id" = str_remove(sample_id, "saliva"))

all_list <- list(BOD, LW, SAL)
all_merge <- all_list %>% reduce(full_join, by = "base_id")
view(all_merge)


write.csv(all_merge, "/Users/emilyfitzmeyer/Desktop/merged_diversity_metrics.csv")
