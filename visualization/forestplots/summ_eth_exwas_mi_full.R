library(tidyverse)
library(dplyr)
library(RColorBrewer)
library(ggrepel)
library(paletteer)
library(ggpubr)
library(readxl)
library(glue)
library(writexl)

?read.csv

#importing datasets
biomarker_desc <- read.csv("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/data/raw_data/biomarker_desc.csv", header=TRUE)

acc_mi_eth_pval <- read_excel("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/EWAS_FMI_PVAL_ETH.xlsx", sheet="acc")

hh_mi_eth_pval <- read_excel("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/EWAS_FMI_PVAL_ETH.xlsx", sheet="hhincome")

medu_mi_eth_pval <- read_excel("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/EWAS_FMI_PVAL_ETH.xlsx", sheet="medu") 

fedu_mi_eth_pval <- read_excel("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/EWAS_FMI_PVAL_ETH.xlsx", sheet="fedu")

sai_mi_eth_pval <- read_excel("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/EWAS_FMI_PVAL_ETH.xlsx", sheet="sai") 

sedi_mi_eth_pval <- read_excel("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/EWAS_FMI_PVAL_ETH.xlsx", sheet="sedi")

#acc_cc_eth
###########

acc_pval_mi_chi <- acc_mi_eth_pval %>% 
  select(Exposure, p_value_chi) %>% 
  rename_at(vars(p_value_chi), ~str_remove(.,"_chi")) %>% 
  mutate(m_ethnicity="Chinese")

acc_pval_mi_ind <- acc_mi_eth_pval %>% 
  select(Exposure, p_value_ind) %>% 
  rename_at(vars(p_value_ind), ~str_remove(.,"_ind")) %>% 
  mutate(m_ethnicity="Indian")

acc_pval_mi_mal <- acc_mi_eth_pval %>% 
  select(Exposure, p_value_mal) %>% 
  rename_at(vars(p_value_mal), ~str_remove(.,"_mal")) %>% 
  mutate(m_ethnicity="Malay")

acc_pval_mi_int <- acc_mi_eth_pval %>% 
  select(Exposure, p_value_int)

##chinese

acc_mi_chi <- read_excel("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/acc_mi_full/##ethnicity/coef/acc_mi_chi.xlsx", sheet="Sheet2") 

acc_chi_3hdb_mi <- acc_mi_chi %>%
  select(Exposure, coef_3hdb:lower_3hdb, N) %>% 
  rename_at(vars(coef_3hdb:lower_3hdb), ~str_remove(.,"_3hdb")) %>%
  mutate(ses_level="L2")

acc_chi_45hdb_mi <- acc_mi_chi %>%
  select(Exposure, coef_4hdb:lower_4hdb, N) %>% 
  rename_at(vars(coef_4hdb:lower_4hdb), ~str_remove(.,"_4hdb")) %>%
  mutate(ses_level="L3")

acc_chi_condo_landed_mi <- acc_mi_chi %>%
  select(Exposure, coef_condo_landed:N) %>%
  rename_at(vars(coef_condo_landed:lower_condo_landed), ~str_remove(.,"_condo_landed")) %>%
  mutate(ses_level="L4")

acc_chi_all_mi <- rbind(acc_chi_3hdb_mi, acc_chi_45hdb_mi, acc_chi_condo_landed_mi) %>%
  mutate (m_ethnicity="Chinese") %>%
  left_join (acc_pval_mi_chi, by=c("Exposure"="Exposure", "m_ethnicity"="m_ethnicity"))


##indian

acc_mi_ind <- read_excel("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/acc_mi_full/##ethnicity/coef/acc_mi_ind.xlsx", sheet="Sheet2") 

acc_ind_3hdb_mi <- acc_mi_ind %>%
  select(Exposure, coef_3hdb:lower_3hdb, N) %>% 
  rename_at(vars(coef_3hdb:lower_3hdb), ~str_remove(.,"_3hdb")) %>%
  mutate(ses_level="L2")

acc_ind_45hdb_mi <- acc_mi_ind %>%
  select(Exposure, coef_4hdb:lower_4hdb, N) %>% 
  rename_at(vars(coef_4hdb:lower_4hdb), ~str_remove(.,"_4hdb")) %>%
  mutate(ses_level="L3")

acc_ind_condo_landed_mi <- acc_mi_ind %>%
  select(Exposure, coef_condo_landed:N) %>%
  rename_at(vars(coef_condo_landed:lower_condo_landed), ~str_remove(.,"_condo_landed")) %>%
  mutate(ses_level="L4")

acc_ind_all_mi <- rbind(acc_ind_3hdb_mi, acc_ind_45hdb_mi, acc_ind_condo_landed_mi) %>%
  mutate (m_ethnicity="Indian") %>%
  left_join (acc_pval_mi_ind, by=c("Exposure"="Exposure", "m_ethnicity"="m_ethnicity"))

##malay

acc_mi_mal <- read_excel("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/acc_mi_full/##ethnicity/coef/acc_mi_mal.xlsx", sheet="Sheet2") 

acc_mal_3hdb_mi <- acc_mi_mal %>%
  select(Exposure, coef_3hdb:lower_3hdb, N) %>% 
  rename_at(vars(coef_3hdb:lower_3hdb), ~str_remove(.,"_3hdb")) %>%
  mutate(ses_level="L2")

acc_mal_45hdb_mi <- acc_mi_mal %>%
  select(Exposure, coef_4hdb:lower_4hdb, N) %>% 
  rename_at(vars(coef_4hdb:lower_4hdb), ~str_remove(.,"_4hdb")) %>%
  mutate(ses_level="L3")

acc_mal_condo_landed_mi <- acc_mi_mal %>%
  select(Exposure, coef_condo_landed:N) %>%
  rename_at(vars(coef_condo_landed:lower_condo_landed), ~str_remove(.,"_condo_landed")) %>%
  mutate(ses_level="L4")

acc_mal_all_mi <- rbind(acc_mal_3hdb_mi, acc_mal_45hdb_mi, acc_mal_condo_landed_mi) %>%
  mutate (m_ethnicity="Malay") %>%
  left_join (acc_pval_mi_mal, by=c("Exposure"="Exposure", "m_ethnicity"="m_ethnicity"))


##combine all ethnicicties 

acc_eth_all_mi <- rbind(acc_chi_all_mi, acc_ind_all_mi, acc_mal_all_mi) %>%
  left_join(biomarker_desc, by="Exposure") %>%
  left_join(acc_pval_mi_int, by="Exposure") %>%
  mutate(ses="acc_mi") 

############################################################################################################################################

#hhincome_cc_eth
###########

hh_pval_mi_chi <- hh_mi_eth_pval %>% 
  select(Exposure, p_value_chi) %>% 
  rename_at(vars(p_value_chi), ~str_remove(.,"_chi")) %>% 
  mutate(m_ethnicity="Chinese")

hh_pval_mi_ind <- hh_mi_eth_pval %>% 
  select(Exposure, p_value_ind) %>% 
  rename_at(vars(p_value_ind), ~str_remove(.,"_ind")) %>% 
  mutate(m_ethnicity="Indian")

hh_pval_mi_mal <- hh_mi_eth_pval %>% 
  select(Exposure, p_value_mal) %>% 
  rename_at(vars(p_value_mal), ~str_remove(.,"_mal")) %>% 
  mutate(m_ethnicity="Malay")

hh_pval_mi_int <- hh_mi_eth_pval %>% 
  select(Exposure, p_value_int)


##chinese

hhincome_mi_chi <- read_excel("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/hhincome_mi_full/##ethnicity/coef/hhincome_mi_chi.xlsx", sheet="Sheet2") 

hhincome_chi_2000_3999_mi <- hhincome_mi_chi %>%
  select(Exposure, coef_2000_3999:lower_2000_3999, N) %>% 
  rename_at(vars(coef_2000_3999:lower_2000_3999), ~str_remove(.,"_2000_3999")) %>%
  mutate(ses_level="L2")

hhincome_chi_4000_5999_mi <- hhincome_mi_chi %>%
  select(Exposure, coef_4000_5999:lower_4000_5999, N) %>% 
  rename_at(vars(coef_4000_5999:lower_4000_5999), ~str_remove(.,"_4000_5999")) %>%
  mutate(ses_level="L3")

hhincome_chi_6000_mi <- hhincome_mi_chi %>%
  select(Exposure, coef_6000:N) %>%
  rename_at(vars(coef_6000:lower_6000), ~str_remove(.,"_6000")) %>%
  mutate(ses_level="L4")

hhincome_chi_all_mi <- rbind(hhincome_chi_2000_3999_mi, hhincome_chi_4000_5999_mi, hhincome_chi_6000_mi) %>%
  mutate (m_ethnicity="Chinese") %>%
  left_join (hh_pval_mi_chi, by=c("Exposure"="Exposure", "m_ethnicity"="m_ethnicity"))


##indian

hhincome_mi_ind <- read_excel("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/hhincome_mi_full/##ethnicity/coef/hhincome_mi_ind.xlsx", sheet="Sheet2") 

hhincome_ind_2000_3999_mi <- hhincome_mi_ind %>%
  select(Exposure, coef_2000_3999:lower_2000_3999, N) %>% 
  rename_at(vars(coef_2000_3999:lower_2000_3999), ~str_remove(.,"_2000_3999")) %>%
  mutate(ses_level="L2")

hhincome_ind_4000_5999_mi <- hhincome_mi_ind %>%
  select(Exposure, coef_4000_5999:lower_4000_5999, N) %>% 
  rename_at(vars(coef_4000_5999:lower_4000_5999), ~str_remove(.,"_4000_5999")) %>%
  mutate(ses_level="L3")

hhincome_ind_6000_mi <- hhincome_mi_ind %>%
  select(Exposure, coef_6000:N) %>%
  rename_at(vars(coef_6000:lower_6000), ~str_remove(.,"_6000")) %>%
  mutate(ses_level="L4")

hhincome_ind_all_mi <- rbind(hhincome_ind_2000_3999_mi, hhincome_ind_4000_5999_mi, hhincome_ind_6000_mi) %>%
  mutate(m_ethnicity="Indian") %>%
  left_join (hh_pval_mi_ind, by=c("Exposure"="Exposure", "m_ethnicity"="m_ethnicity"))

##malay

hhincome_mi_mal <- read_excel("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/hhincome_mi_full/##ethnicity/coef/hhincome_mi_mal.xlsx", sheet="Sheet2") 

hhincome_mal_2000_3999_mi <- hhincome_mi_mal %>%
  select(Exposure, coef_2000_3999:lower_2000_3999, N) %>% 
  rename_at(vars(coef_2000_3999:lower_2000_3999), ~str_remove(.,"_2000_3999")) %>%
  mutate(ses_level="L2")

hhincome_mal_4000_5999_mi <- hhincome_mi_mal %>%
  select(Exposure, coef_4000_5999:lower_4000_5999, N) %>% 
  rename_at(vars(coef_4000_5999:lower_4000_5999), ~str_remove(.,"_4000_5999")) %>%
  mutate(ses_level="L3")

hhincome_mal_6000_mi <- hhincome_mi_mal %>%
  select(Exposure, coef_6000:N) %>%
  rename_at(vars(coef_6000:lower_6000), ~str_remove(.,"_6000")) %>%
  mutate(ses_level="L4")

hhincome_mal_all_mi <- rbind(hhincome_mal_2000_3999_mi, hhincome_mal_4000_5999_mi, hhincome_mal_6000_mi) %>%
  mutate (m_ethnicity="Malay") %>%
  left_join (hh_pval_mi_mal, by=c("Exposure"="Exposure", "m_ethnicity"="m_ethnicity"))


##combine all ethnicicties 

hhincome_eth_all_mi <- rbind(hhincome_chi_all_mi, hhincome_ind_all_mi, hhincome_mal_all_mi) %>%
  left_join(biomarker_desc, by="Exposure") %>%
  left_join(hh_pval_mi_int, by="Exposure") %>%
  mutate(ses="hhincome_mi") 

############################################################################################################################################


#medu_mi_eth
###########

medu_pval_mi_chi <- medu_mi_eth_pval %>% 
  select(Exposure, p_value_chi) %>% 
  rename_at(vars(p_value_chi), ~str_remove(.,"_chi")) %>% 
  mutate(m_ethnicity="Chinese")

medu_pval_mi_ind <- medu_mi_eth_pval %>% 
  select(Exposure, p_value_ind) %>% 
  rename_at(vars(p_value_ind), ~str_remove(.,"_ind")) %>% 
  mutate(m_ethnicity="Indian")

medu_pval_mi_mal <- medu_mi_eth_pval %>% 
  select(Exposure, p_value_mal) %>% 
  rename_at(vars(p_value_mal), ~str_remove(.,"_mal")) %>% 
  mutate(m_ethnicity="Malay")

medu_pval_mi_int <- medu_mi_eth_pval %>% 
  select(Exposure, p_value_int)


##chinese

medu_mi_chi <- read_excel("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/medu_mi_full/##ethnicity/coef/medu_mi_chi.xlsx", sheet="Sheet2")

medu_chi_sec_mi <- medu_mi_chi %>%
  select(Exposure, coef_sec:lower_sec, N) %>% 
  rename_at(vars(coef_sec:lower_sec), ~str_remove(.,"_sec")) %>%
  mutate(ses_level="L2")

medu_chi_dip_mi <- medu_mi_chi %>%
  select(Exposure, coef_dip:lower_dip, N) %>% 
  rename_at(vars(coef_dip:lower_dip), ~str_remove(.,"_dip")) %>%
  mutate(ses_level="L3")

medu_chi_uni_mi <- medu_mi_chi %>%
  select(Exposure, coef_uni:N) %>%
  rename_at(vars(coef_uni:lower_uni), ~str_remove(.,"_uni")) %>%
  mutate(ses_level="L4")

medu_chi_all_mi <- rbind(medu_chi_sec_mi, medu_chi_dip_mi, medu_chi_uni_mi) %>%
  mutate (m_ethnicity="Chinese") %>%
  left_join (medu_pval_mi_chi, by=c("Exposure"="Exposure", "m_ethnicity"="m_ethnicity"))


##indian

medu_mi_ind <- read_excel("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/medu_mi_full/##ethnicity/coef/medu_mi_ind.xlsx", sheet="Sheet2")

medu_ind_sec_mi <- medu_mi_ind %>%
  select(Exposure, coef_sec:lower_sec, N) %>% 
  rename_at(vars(coef_sec:lower_sec), ~str_remove(.,"_sec")) %>%
  mutate(ses_level="L2")

medu_ind_dip_mi <- medu_mi_ind %>%
  select(Exposure, coef_dip:lower_dip, N) %>% 
  rename_at(vars(coef_dip:lower_dip), ~str_remove(.,"_dip")) %>%
  mutate(ses_level="L3")

medu_ind_uni_mi <- medu_mi_ind %>%
  select(Exposure, coef_uni:N) %>%
  rename_at(vars(coef_uni:lower_uni), ~str_remove(.,"_uni")) %>%
  mutate(ses_level="L4")

medu_ind_all_mi <- rbind(medu_ind_sec_mi, medu_ind_dip_mi, medu_ind_uni_mi) %>%
  mutate (m_ethnicity="Indian") %>%
  left_join (medu_pval_mi_ind, by=c("Exposure"="Exposure", "m_ethnicity"="m_ethnicity"))

##malay

medu_mi_mal <- read_excel("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/medu_mi_full/##ethnicity/coef/medu_mi_mal.xlsx", sheet="Sheet2") 

medu_mal_sec_mi <- medu_mi_mal %>%
  select(Exposure, coef_sec:lower_sec, N) %>% 
  rename_at(vars(coef_sec:lower_sec), ~str_remove(.,"_sec")) %>%
  mutate(ses_level="L2")

medu_mal_dip_mi <- medu_mi_mal %>%
  select(Exposure, coef_dip:lower_dip, N) %>% 
  rename_at(vars(coef_dip:lower_dip), ~str_remove(.,"_dip")) %>%
  mutate(ses_level="L3")

medu_mal_uni_mi <- medu_mi_mal %>%
  select(Exposure, coef_uni:N) %>%
  rename_at(vars(coef_uni:lower_uni), ~str_remove(.,"_uni")) %>%
  mutate(ses_level="L4")

medu_mal_all_mi <- rbind(medu_mal_sec_mi, medu_mal_dip_mi, medu_mal_uni_mi) %>%
  mutate (m_ethnicity="Malay") %>%
  left_join (medu_pval_mi_mal, by=c("Exposure"="Exposure", "m_ethnicity"="m_ethnicity"))


##combine all ethnicicties 

medu_eth_all_mi <- rbind(medu_chi_all_mi, medu_ind_all_mi, medu_mal_all_mi) %>%
  left_join(biomarker_desc, by="Exposure") %>%
  left_join(medu_pval_mi_int, by="Exposure") %>%
  mutate(ses="medu_mi") 

############################################################################################################################################

#fedu_cc_eth
###########

fedu_pval_mi_chi <- fedu_mi_eth_pval %>% 
  select(Exposure, p_value_chi) %>% 
  rename_at(vars(p_value_chi), ~str_remove(.,"_chi")) %>% 
  mutate(m_ethnicity="Chinese")

fedu_pval_mi_ind <- fedu_mi_eth_pval %>% 
  select(Exposure, p_value_ind) %>% 
  rename_at(vars(p_value_ind), ~str_remove(.,"_ind")) %>% 
  mutate(m_ethnicity="Indian")

fedu_pval_mi_mal <- fedu_mi_eth_pval %>% 
  select(Exposure, p_value_mal) %>% 
  rename_at(vars(p_value_mal), ~str_remove(.,"_mal")) %>% 
  mutate(m_ethnicity="Malay")

fedu_pval_mi_int <- fedu_mi_eth_pval %>% 
  select(Exposure, p_value_int)


##chinese

fedu_mi_chi <- read_excel("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/fedu_mi_full/##ethnicity/coef/fedu_mi_chi.xlsx", sheet="Sheet2")

fedu_chi_sec_mi <- fedu_mi_chi %>%
  select(Exposure, coef_sec:lower_sec, N) %>% 
  rename_at(vars(coef_sec:lower_sec), ~str_remove(.,"_sec")) %>%
  mutate(ses_level="L2")

fedu_chi_dip_mi <- fedu_mi_chi %>%
  select(Exposure, coef_dip:lower_dip, N) %>% 
  rename_at(vars(coef_dip:lower_dip), ~str_remove(.,"_dip")) %>%
  mutate(ses_level="L3")

fedu_chi_uni_mi <- fedu_mi_chi %>%
  select(Exposure, coef_uni:N) %>%
  rename_at(vars(coef_uni:lower_uni), ~str_remove(.,"_uni")) %>%
  mutate(ses_level="L4")

fedu_chi_all_mi <- rbind(fedu_chi_sec_mi, fedu_chi_dip_mi, fedu_chi_uni_mi) %>%
  mutate (m_ethnicity="Chinese") %>%
  left_join (fedu_pval_mi_chi, by=c("Exposure"="Exposure", "m_ethnicity"="m_ethnicity"))


##indian

fedu_mi_ind <- read_excel("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/fedu_mi_full/##ethnicity/coef/fedu_mi_ind.xlsx", sheet="Sheet2") 

fedu_ind_sec_mi <- fedu_mi_ind %>%
  select(Exposure, coef_sec:lower_sec, N) %>% 
  rename_at(vars(coef_sec:lower_sec), ~str_remove(.,"_sec")) %>%
  mutate(ses_level="L2")

fedu_ind_dip_mi <- fedu_mi_ind %>%
  select(Exposure, coef_dip:lower_dip, N) %>% 
  rename_at(vars(coef_dip:lower_dip), ~str_remove(.,"_dip")) %>%
  mutate(ses_level="L3")

fedu_ind_uni_mi <- fedu_mi_ind %>%
  select(Exposure, coef_uni:N) %>%
  rename_at(vars(coef_uni:lower_uni), ~str_remove(.,"_uni")) %>%
  mutate(ses_level="L4")

fedu_ind_all_mi <- rbind(fedu_ind_sec_mi, fedu_ind_dip_mi, fedu_ind_uni_mi) %>%
  mutate (m_ethnicity="Indian") %>%
  left_join (fedu_pval_mi_ind, by=c("Exposure"="Exposure", "m_ethnicity"="m_ethnicity"))

##malay

fedu_mi_mal <- read_excel("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/fedu_mi_full/##ethnicity/coef/fedu_mi_mal.xlsx", sheet="Sheet2")

fedu_mal_sec_mi <- fedu_mi_mal %>%
  select(Exposure, coef_sec:lower_sec, N) %>% 
  rename_at(vars(coef_sec:lower_sec), ~str_remove(.,"_sec")) %>%
  mutate(ses_level="L2")

fedu_mal_dip_mi <- fedu_mi_mal %>%
  select(Exposure, coef_dip:lower_dip, N) %>% 
  rename_at(vars(coef_dip:lower_dip), ~str_remove(.,"_dip")) %>%
  mutate(ses_level="L3")

fedu_mal_uni_mi <- fedu_mi_mal %>%
  select(Exposure, coef_uni:N) %>%
  rename_at(vars(coef_uni:lower_uni), ~str_remove(.,"_uni")) %>%
  mutate(ses_level="L4")

fedu_mal_all_mi <- rbind(fedu_mal_sec_mi, fedu_mal_dip_mi, fedu_mal_uni_mi) %>%
  mutate (m_ethnicity="Malay") %>%
  left_join (fedu_pval_mi_mal, by=c("Exposure"="Exposure", "m_ethnicity"="m_ethnicity"))


##combine all ethnicicties 

fedu_eth_all_mi <- rbind(fedu_chi_all_mi, fedu_ind_all_mi, fedu_mal_all_mi) %>%
  left_join(biomarker_desc, by="Exposure") %>%
  left_join(fedu_pval_mi_int, by="Exposure") %>%
  mutate(ses="fedu_mi") 

############################################################################################################################################

#sai_cc_eth
###########

sai_pval_mi_chi <- sai_mi_eth_pval %>% 
  select(Exposure, p_value_chi) %>% 
  rename_at(vars(p_value_chi), ~str_remove(.,"_chi")) %>% 
  mutate(m_ethnicity="Chinese")

sai_pval_mi_ind <- sai_mi_eth_pval %>% 
  select(Exposure, p_value_ind) %>% 
  rename_at(vars(p_value_ind), ~str_remove(.,"_ind")) %>% 
  mutate(m_ethnicity="Indian")

sai_pval_mi_mal <- sai_mi_eth_pval %>% 
  select(Exposure, p_value_mal) %>% 
  rename_at(vars(p_value_mal), ~str_remove(.,"_mal")) %>% 
  mutate(m_ethnicity="Malay")

sai_pval_mi_int <- sai_mi_eth_pval %>% 
  select(Exposure, p_value_int)

##chinese

sai_mi_chi <- read_excel("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/sai_mi_full/##ethnicity/coef/sai_mi_chi.xlsx", sheet="Sheet2") 

sai_chi_93_6_95_mi <- sai_mi_chi %>%
  select(Exposure, coef_93_6_95:lower_93_6_95, N) %>% 
  rename_at(vars(coef_93_6_95:lower_93_6_95), ~str_remove(.,"_93_6_95")) %>%
  mutate(ses_level="L2")

sai_chi_95_1_97_2_mi <- sai_mi_chi %>%
  select(Exposure, coef_95_1_97_2:lower_95_1_97_2, N) %>% 
  rename_at(vars(coef_95_1_97_2:lower_95_1_97_2), ~str_remove(.,"_95_1_97_2")) %>%
  mutate(ses_level="L3")

sai_chi_97_2_mi <- sai_mi_chi %>%
  select(Exposure, coef_97_2:N) %>%
  rename_at(vars(coef_97_2:lower_97_2), ~str_remove(.,"_97_2")) %>%
  mutate(ses_level="L4")

sai_chi_all_mi <- rbind(sai_chi_93_6_95_mi, sai_chi_95_1_97_2_mi, sai_chi_97_2_mi) %>%
  mutate (m_ethnicity="Chinese") %>%
  left_join (sai_pval_mi_chi, by=c("Exposure"="Exposure", "m_ethnicity"="m_ethnicity"))


##indian

sai_mi_ind <- read_excel("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/sai_mi_full/##ethnicity/coef/sai_mi_ind.xlsx", sheet="Sheet2")

sai_ind_93_6_95_mi <- sai_mi_ind %>%
  select(Exposure, coef_93_6_95:lower_93_6_95, N) %>% 
  rename_at(vars(coef_93_6_95:lower_93_6_95), ~str_remove(.,"_93_6_95")) %>%
  mutate(ses_level="L2")

sai_ind_95_1_97_2_mi <- sai_mi_ind %>%
  select(Exposure, coef_95_1_97_2:lower_95_1_97_2, N) %>% 
  rename_at(vars(coef_95_1_97_2:lower_95_1_97_2), ~str_remove(.,"_95_1_97_2")) %>%
  mutate(ses_level="L3")

sai_ind_97_2_mi <- sai_mi_ind %>%
  select(Exposure, coef_97_2:N) %>%
  rename_at(vars(coef_97_2:lower_97_2), ~str_remove(.,"_97_2")) %>%
  mutate(ses_level="L4")

sai_ind_all_mi <- rbind(sai_ind_93_6_95_mi, sai_ind_95_1_97_2_mi, sai_ind_97_2_mi) %>%
  mutate (m_ethnicity="Indian") %>%
  left_join (sai_pval_mi_ind, by=c("Exposure"="Exposure", "m_ethnicity"="m_ethnicity"))

##malay

sai_mi_mal <- read_excel("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/sai_mi_full/##ethnicity/coef/sai_mi_mal.xlsx", sheet="Sheet2") 

sai_mal_93_6_95_mi <- sai_mi_mal %>%
  select(Exposure, coef_93_6_95:lower_93_6_95, N) %>% 
  rename_at(vars(coef_93_6_95:lower_93_6_95), ~str_remove(.,"_93_6_95")) %>%
  mutate(ses_level="L2")

sai_mal_95_1_97_2_mi <- sai_mi_mal %>%
  select(Exposure, coef_95_1_97_2:lower_95_1_97_2, N) %>% 
  rename_at(vars(coef_95_1_97_2:lower_95_1_97_2), ~str_remove(.,"_95_1_97_2")) %>%
  mutate(ses_level="L3")

sai_mal_97_2_mi <- sai_mi_mal %>%
  select(Exposure, coef_97_2:N) %>%
  rename_at(vars(coef_97_2:lower_97_2), ~str_remove(.,"_97_2")) %>%
  mutate(ses_level="L4")

sai_mal_all_mi <- rbind(sai_mal_93_6_95_mi, sai_mal_95_1_97_2_mi, sai_mal_97_2_mi) %>%
  mutate (m_ethnicity="Malay") %>%
  left_join (sai_pval_mi_mal, by=c("Exposure"="Exposure", "m_ethnicity"="m_ethnicity"))


##combine all ethnicicties 

sai_eth_all_mi <- rbind(sai_chi_all_mi, sai_ind_all_mi, sai_mal_all_mi) %>%
  left_join(biomarker_desc, by="Exposure") %>%
  left_join(sai_pval_mi_int, by="Exposure") %>%
  mutate(ses="sai_mi") 

############################################################################################################################################

#sedi_cc_eth
###########

sedi_pval_mi_chi <- sedi_mi_eth_pval %>% 
  select(Exposure, p_value_chi) %>% 
  rename_at(vars(p_value_chi), ~str_remove(.,"_chi")) %>% 
  mutate(m_ethnicity="Chinese")

sedi_pval_mi_ind <- sedi_mi_eth_pval %>% 
  select(Exposure, p_value_ind) %>% 
  rename_at(vars(p_value_ind), ~str_remove(.,"_ind")) %>% 
  mutate(m_ethnicity="Indian")

sedi_pval_mi_mal <- sedi_mi_eth_pval %>% 
  select(Exposure, p_value_mal) %>% 
  rename_at(vars(p_value_mal), ~str_remove(.,"_mal")) %>% 
  mutate(m_ethnicity="Malay")

sedi_pval_mi_int <- sedi_mi_eth_pval %>% 
  select(Exposure, p_value_int)


##chinese
sedi_mi_chi <- read_excel("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/sedi_mi_full/##ethnicity/coef/sedi_mi_chi.xlsx", sheet="Sheet2") 

sedi_chi_100_3_101_6_mi <- sedi_mi_chi %>%
  select(Exposure, coef_100_3_101_6:lower_100_3_101_6, N) %>% 
  rename_at(vars(coef_100_3_101_6:lower_100_3_101_6), ~str_remove(.,"_100_3_101_6")) %>%
  mutate(ses_level="L2")

sedi_chi_101_7_105_6_mi <- sedi_mi_chi %>%
  select(Exposure, coef_101_7_105_6:lower_101_7_105_6, N) %>% 
  rename_at(vars(coef_101_7_105_6:lower_101_7_105_6), ~str_remove(.,"_101_7_105_6")) %>%
  mutate(ses_level="L3")

sedi_chi_105_6_mi <- sedi_mi_chi %>%
  select(Exposure, coef_105_6:N) %>%
  rename_at(vars(coef_105_6:lower_105_6), ~str_remove(.,"_105_6")) %>%
  mutate(ses_level="L4")

sedi_chi_all_mi <- rbind(sedi_chi_100_3_101_6_mi, sedi_chi_101_7_105_6_mi, sedi_chi_105_6_mi) %>%
  mutate (m_ethnicity="Chinese") %>%
  left_join (sedi_pval_mi_chi, by=c("Exposure"="Exposure", "m_ethnicity"="m_ethnicity"))


##indian

sedi_mi_ind <- read_excel("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/sedi_mi_full/##ethnicity/coef/sedi_mi_ind.xlsx", sheet="Sheet2") 

sedi_ind_100_3_101_6_mi <- sedi_mi_ind %>%
  select(Exposure, coef_100_3_101_6:lower_100_3_101_6, N) %>% 
  rename_at(vars(coef_100_3_101_6:lower_100_3_101_6), ~str_remove(.,"_100_3_101_6")) %>%
  mutate(ses_level="L2")

sedi_ind_101_7_105_6_mi <- sedi_mi_ind %>%
  select(Exposure, coef_101_7_105_6:lower_101_7_105_6, N) %>% 
  rename_at(vars(coef_101_7_105_6:lower_101_7_105_6), ~str_remove(.,"_101_7_105_6")) %>%
  mutate(ses_level="L3")

sedi_ind_105_6_mi <- sedi_mi_ind %>%
  select(Exposure, coef_105_6:N) %>%
  rename_at(vars(coef_105_6:lower_105_6), ~str_remove(.,"_105_6")) %>%
  mutate(ses_level="L4")

sedi_ind_all_mi <- rbind(sedi_ind_100_3_101_6_mi, sedi_ind_101_7_105_6_mi, sedi_ind_105_6_mi) %>%
  mutate (m_ethnicity="Indian") %>%
  left_join (sedi_pval_mi_ind, by=c("Exposure"="Exposure", "m_ethnicity"="m_ethnicity"))

##malay

sedi_mi_mal <- read_excel("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/sedi_mi_full/##ethnicity/coef/sedi_mi_mal.xlsx", sheet="Sheet2") 

sedi_mal_100_3_101_6_mi <- sedi_mi_mal %>%
  select(Exposure, coef_100_3_101_6:lower_100_3_101_6, N) %>% 
  rename_at(vars(coef_100_3_101_6:lower_100_3_101_6), ~str_remove(.,"_100_3_101_6")) %>%
  mutate(ses_level="L2")

sedi_mal_101_7_105_6_mi <- sedi_mi_mal %>%
  select(Exposure, coef_101_7_105_6:lower_101_7_105_6, N) %>% 
  rename_at(vars(coef_101_7_105_6:lower_101_7_105_6), ~str_remove(.,"_101_7_105_6")) %>%
  mutate(ses_level="L3")

sedi_mal_105_6_mi <- sedi_mi_mal %>%
  select(Exposure, coef_105_6:N) %>%
  rename_at(vars(coef_105_6:lower_105_6), ~str_remove(.,"_105_6")) %>%
  mutate(ses_level="L4")

sedi_mal_all_mi <- rbind(sedi_mal_100_3_101_6_mi, sedi_mal_101_7_105_6_mi, sedi_mal_105_6_mi) %>%
  mutate (m_ethnicity="Malay") %>%
  left_join (sedi_pval_mi_mal, by=c("Exposure"="Exposure", "m_ethnicity"="m_ethnicity"))


##combine all ethnicicties 

sedi_eth_all_mi <- rbind(sedi_chi_all_mi, sedi_ind_all_mi, sedi_mal_all_mi) %>%
  left_join(biomarker_desc, by="Exposure") %>%
  left_join(sedi_pval_mi_int, by="Exposure") %>%
  mutate(ses="sedi_mi") 


############################################################################################################################################


ses_mi_eth <- rbind(acc_eth_all_mi, hhincome_eth_all_mi, medu_eth_all_mi, fedu_eth_all_mi, sai_eth_all_mi, sedi_eth_all_mi) 

ses_mi_eth_sig <- ses_mi_eth %>% filter(p_value_int<0.05/134)

filter(ses_mi_eth, Exposure_name=="3-Methylhistidine " & ses=="medu") #p_int=0.000394

ses_mi_eth_clean <-  ses_mi_eth %>%
  filter(Exposure_name!="Insulin_l", Exposure_name!="CRP_l", Exposure_name!="IFN-g", Exposure_name!="Creatinine_b") %>%
  mutate(significance=factor(case_when(p_value_int<0.05/134~1,
                                       p_value_int>=0.05/134~0))) 

ses_mi_eth_sig1 <-  ses_mi_eth_clean %>%
  filter(Exposure_name=="PFUnDA"|Exposure_name=="PFOS"|Exposure_name=="PFDA"|Exposure_name=="PFNA"|Exposure_name=="Total Homocysteine ")

ggplot(data=ses_mi_eth_sig1, aes(x=coef, y=reorder(Exposure_name, coef), shape=m_ethnicity, linetype=m_ethnicity,col=significance, alpha=significance)) +
  geom_point(aes(x=coef, y=Exposure_name), position=position_dodge(0.7), size=1.5) +
  geom_errorbarh(aes(xmin=lower, xmax=upper), height=.1, position=position_dodge(0.7)) +
  geom_vline(xintercept=0, color="black", linetype="dashed") +
  geom_text(data=mutate_if(filter(ses_mi_eth_sig1, m_ethnicity=="Chinese"), is.numeric, round,2), 
            aes(label=glue("{coef} [{lower},{upper}]"), x=5), hjust="inward", size=1.8, nudge_y=-0.24) +
  geom_text(data=mutate_if(filter(ses_mi_eth_sig1, m_ethnicity=="Indian"), is.numeric, round,2), 
            aes(label=glue("{coef} [{lower},{upper}]"), x=5), hjust="inward", size=1.8) +
  geom_text(data=mutate_if(filter(ses_mi_eth_sig1, m_ethnicity=="Malay"), is.numeric, round,2), 
            aes(label=glue("{coef} [{lower},{upper}]"), x=5), hjust="inward", size=1.8, nudge_y=0.24) +
  facet_grid(ses~ses_level, labeller=labeller(ses=
                                                c("acc_mi"="Accommodation",
                                                  "hhincome_mi"="Household income",
                                                  "medu_mi"="Maternal education", 
                                                  "fedu_mi"="Paternal education", 
                                                  "sai_mi"="SAI", 
                                                  "sedi_mi"="SEDI"))) +
  theme(
    legend.title = element_blank(),
    panel.border = element_blank(),
    panel.grid = element_blank(),
    axis.line = element_line(color="black"),
    panel.background = element_rect(fill="white")
  ) +
  scale_shape_discrete(breaks=c("Malay", "Indian", "Chinese")) + 
  scale_linetype_discrete(breaks=c("Malay", "Indian", "Chinese")) +
  scale_color_manual(values=cols, guide=F) +
  scale_alpha_discrete(range=c(0.5,1), guide=F) +
  labs(color=NULL) +
  ylab(NULL) +
  xlab("Beta coefficient")

ggsave("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/interaction_graph/eth_int_mi_full.png")

ggplot(data=ses_mi_eth_sig, aes(x=coef, y=reorder(Exposure_name, coef), shape=ses_level, linetype=ses_level)) +
  geom_point(aes(x=coef, y=Exposure_name), position=position_dodge(0.7), size=1.5) +
  geom_errorbarh(aes(xmin=lower, xmax=upper), height=.1, position=position_dodge(0.7)) +
  geom_vline(xintercept=0, color="black", linetype="dashed") +
  geom_text(data=mutate_if(filter(ses_mi_eth_sig, ses_level=="L2"), is.numeric, round,2), 
            aes(label=glue("{coef} [{lower},{upper}]"), x=7), hjust="inward", size=2, nudge_y=-0.24) +
  geom_text(data=mutate_if(filter(ses_mi_eth_sig, ses_level=="L3"), is.numeric, round,2), 
            aes(label=glue("{coef} [{lower},{upper}]"), x=7), hjust="inward", size=2) +
  geom_text(data=mutate_if(filter(ses_mi_eth_sig, ses_level=="L4"), is.numeric, round,2), 
            aes(label=glue("{coef} [{lower},{upper}]"), x=7), hjust="inward", size=2, nudge_y=0.24) +
  facet_grid(m_ethnicity~ses, labeller=labeller(ses=
                                            c("acc_mi"="Accommodation",
                                              "hhincome_mi"="Household income",
                                              "medu_mi"="Maternal education", 
                                              "fedu_mi"="Paternal education", 
                                              "sai_mi"="SAI", 
                                              "sedi_mi"="SEDI"))) +
  theme(
    legend.title = element_blank(),
    panel.border = element_blank(),
    panel.grid = element_blank(),
    axis.line = element_line(color="black"),
    panel.background = element_rect(fill="white")
  ) +
  scale_shape_discrete(breaks=c("L4", "L3", "L2")) + 
  scale_linetype_discrete(breaks=c("L4", "L3", "L2")) +
  scale_color_manual(values=cols, guide=F) +
  scale_alpha_discrete(range=c(0.5,1), guide=F) +
  labs(color=NULL) +
  ylab(NULL) +
  xlab("Beta coefficient")

ggsave("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/interaction_graph/eth_int_mi_full1.png")

ggplot(data=ses_mi_eth_sig, aes(x=coef, y=reorder(Exposure_name, coef), shape=m_ethnicity, linetype=m_ethnicity)) +
  geom_point(aes(x=coef, y=Exposure_name), position=position_dodge(0.7), size=1.5) +
  geom_errorbarh(aes(xmin=lower, xmax=upper), height=.1, position=position_dodge(0.7)) +
  geom_vline(xintercept=0, color="black", linetype="dashed") +
  geom_text(data=mutate_if(filter(ses_mi_eth_sig, m_ethnicity=="Chinese"), is.numeric, round,2), 
            aes(label=glue("{coef} [{lower},{upper}]"), x=5), hjust="inward", size=2, nudge_y=-0.24) +
  geom_text(data=mutate_if(filter(ses_mi_eth_sig, m_ethnicity=="Indian"), is.numeric, round,2), 
            aes(label=glue("{coef} [{lower},{upper}]"), x=5), hjust="inward", size=2) +
  geom_text(data=mutate_if(filter(ses_mi_eth_sig, m_ethnicity=="Malay"), is.numeric, round,2), 
            aes(label=glue("{coef} [{lower},{upper}]"), x=5), hjust="inward", size=2, nudge_y=0.24) +
  facet_grid(ses~ses_level, labeller=labeller(ses=
                                                c("acc_mi"="Accommodation",
                                                  "hhincome_mi"="Household income",
                                                  "medu_mi"="Maternal education", 
                                                  "fedu_mi"="Paternal education", 
                                                  "sai_mi"="SAI", 
                                                  "sedi_mi"="SEDI"))) +
  theme(
    legend.title = element_blank(),
    panel.border = element_blank(),
    panel.grid = element_blank(),
    axis.line = element_line(color="black"),
    panel.background = element_rect(fill="white")
  ) +
  scale_shape_discrete(breaks=c("Malay", "Indian", "Chinese")) + 
  scale_linetype_discrete(breaks=c("Malay", "Indian", "Chinese")) +
  labs(color=NULL) +
  ylab(NULL) +
  xlab("Beta coefficient")



