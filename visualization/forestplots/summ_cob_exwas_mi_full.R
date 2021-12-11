library(tidyverse)
library(dplyr)
library(RColorBrewer)
library(ggrepel)
library(paletteer)
library(ggpubr)
library(readxl)
library(glue)
library(writexl)

biomarker_desc <- read.csv("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/data/raw_data/biomarker_desc.csv", header=TRUE)

acc_mi_cob_pval <- read_excel("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/EWAS_FMI_PVAL_COB.xlsx", sheet="acc") 

hh_mi_cob_pval <- read_excel("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/EWAS_FMI_PVAL_COB.xlsx", sheet="hhincome") 

medu_mi_cob_pval <- read_excel("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/EWAS_FMI_PVAL_COB.xlsx", sheet="medu") 

fedu_mi_cob_pval <- read_excel("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/EWAS_FMI_PVAL_COB.xlsx", sheet="fedu") 

sai_mi_cob_pval <- read_excel("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/EWAS_FMI_PVAL_COB.xlsx", sheet="sai") 

sedi_mi_cob_pval <- read_excel("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/EWAS_FMI_PVAL_COB.xlsx", sheet="sedi") 

#acc_cc_cob
###########

acc_pval_mi_xsg <- acc_mi_cob_pval %>% 
  select(Exposure, p_value_xsg) %>% 
  rename_at(vars(p_value_xsg), ~str_remove(.,"_xsg")) %>% 
  mutate(m_cob="Non-native")

acc_pval_mi_sg <- acc_mi_cob_pval %>% 
  select(Exposure, p_value_sg) %>% 
  rename_at(vars(p_value_sg), ~str_remove(.,"_sg")) %>% 
  mutate(m_cob="Native")

acc_pval_mi_int <- acc_mi_cob_pval %>% 
  select(Exposure, p_value_int)

##xsg

acc_mi_xsg <- read_excel("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/acc_mi_full/##cob/coef/acc_mi_xsg.xlsx", sheet="Sheet2")

acc_xsg_3hdb_mi <- acc_mi_xsg %>%
  select(Exposure, coef_3hdb:lower_3hdb, N) %>% 
  rename_at(vars(coef_3hdb:lower_3hdb), ~str_remove(.,"_3hdb")) %>%
  mutate(ses_level="L2")

acc_xsg_45hdb_mi <- acc_mi_xsg %>%
  select(Exposure, coef_4hdb:lower_4hdb, N) %>% 
  rename_at(vars(coef_4hdb:lower_4hdb), ~str_remove(.,"_4hdb")) %>%
  mutate(ses_level="L3")

acc_xsg_condo_landed_mi <- acc_mi_xsg %>%
  select(Exposure, coef_condo_landed:N) %>%
  rename_at(vars(coef_condo_landed:lower_condo_landed), ~str_remove(.,"_condo_landed")) %>%
  mutate(ses_level="L4")

acc_xsg_all_mi <- rbind(acc_xsg_3hdb_mi, acc_xsg_45hdb_mi, acc_xsg_condo_landed_mi) %>%
  mutate (m_cob="Non-native") %>%
  left_join (acc_pval_mi_xsg, by=c("Exposure"="Exposure", "m_cob"="m_cob"))


##Native

acc_mi_sg <- read_excel("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/acc_mi_full/##cob/coef/acc_mi_sg.xlsx", sheet="Sheet2") 

acc_sg_3hdb_mi <- acc_mi_sg %>%
  select(Exposure, coef_3hdb:lower_3hdb, N) %>% 
  rename_at(vars(coef_3hdb:lower_3hdb), ~str_remove(.,"_3hdb")) %>%
  mutate(ses_level="L2")

acc_sg_45hdb_mi <- acc_mi_sg %>%
  select(Exposure, coef_4hdb:lower_4hdb, N) %>% 
  rename_at(vars(coef_4hdb:lower_4hdb), ~str_remove(.,"_4hdb")) %>%
  mutate(ses_level="L3")

acc_sg_condo_landed_mi <- acc_mi_sg %>%
  select(Exposure, coef_condo_landed:N) %>%
  rename_at(vars(coef_condo_landed:lower_condo_landed), ~str_remove(.,"_condo_landed")) %>%
  mutate(ses_level="L4")

acc_sg_all_mi <- rbind(acc_sg_3hdb_mi, acc_sg_45hdb_mi, acc_sg_condo_landed_mi) %>%
  mutate (m_cob="Native") %>%
  left_join (acc_pval_mi_sg, by=c("Exposure"="Exposure", "m_cob"="m_cob"))


##combine all cob

acc_cob_all_mi <- rbind(acc_xsg_all_mi, acc_sg_all_mi) %>%
  left_join(biomarker_desc, by="Exposure") %>%
  left_join(acc_pval_mi_int, by="Exposure") %>%
  mutate(ses="acc_mi") 

############################################################################################################################################

#hhincome_cc_cob
###########

hh_pval_mi_xsg <- hh_mi_cob_pval %>% 
  select(Exposure, p_value_xsg) %>% 
  rename_at(vars(p_value_xsg), ~str_remove(.,"_xsg")) %>% 
  mutate(m_cob="Non-native")

hh_pval_mi_sg <- hh_mi_cob_pval %>% 
  select(Exposure, p_value_sg) %>% 
  rename_at(vars(p_value_sg), ~str_remove(.,"_sg")) %>% 
  mutate(m_cob="Native")

hh_pval_mi_int <- hh_mi_cob_pval %>% 
  select(Exposure, p_value_int)


##xsg

hhincome_mi_xsg <- read_excel("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/hhincome_mi_full/##cob/coef/hhincome_mi_xsg.xlsx", sheet="Sheet2") 

hhincome_xsg_2000_3999_mi <- hhincome_mi_xsg %>%
  select(Exposure, coef_2000_3999:lower_2000_3999, N) %>% 
  rename_at(vars(coef_2000_3999:lower_2000_3999), ~str_remove(.,"_2000_3999")) %>%
  mutate(ses_level="L2")

hhincome_xsg_4000_5999_mi <- hhincome_mi_xsg %>%
  select(Exposure, coef_4000_5999:lower_4000_5999, N) %>% 
  rename_at(vars(coef_4000_5999:lower_4000_5999), ~str_remove(.,"_4000_5999")) %>%
  mutate(ses_level="L3")

hhincome_xsg_6000_mi <- hhincome_mi_xsg %>%
  select(Exposure, coef_6000:N) %>%
  rename_at(vars(coef_6000:lower_6000), ~str_remove(.,"_6000")) %>%
  mutate(ses_level="L4")

hhincome_xsg_all_mi <- rbind(hhincome_xsg_2000_3999_mi, hhincome_xsg_4000_5999_mi, hhincome_xsg_6000_mi) %>%
  mutate (m_cob="Non-native") %>%
  left_join (hh_pval_mi_xsg, by=c("Exposure"="Exposure", "m_cob"="m_cob"))


##Native

hhincome_mi_sg <- read_excel("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/hhincome_mi_full/##cob/coef/hhincome_mi_sg.xlsx", sheet="Sheet2")

hhincome_sg_2000_3999_mi <- hhincome_mi_sg %>%
  select(Exposure, coef_2000_3999:lower_2000_3999, N) %>% 
  rename_at(vars(coef_2000_3999:lower_2000_3999), ~str_remove(.,"_2000_3999")) %>%
  mutate(ses_level="L2")

hhincome_sg_4000_5999_mi <- hhincome_mi_sg %>%
  select(Exposure, coef_4000_5999:lower_4000_5999, N) %>% 
  rename_at(vars(coef_4000_5999:lower_4000_5999), ~str_remove(.,"_4000_5999")) %>%
  mutate(ses_level="L3")

hhincome_sg_6000_mi <- hhincome_mi_sg %>%
  select(Exposure, coef_6000:N) %>%
  rename_at(vars(coef_6000:lower_6000), ~str_remove(.,"_6000")) %>%
  mutate(ses_level="L4")

hhincome_sg_all_mi <- rbind(hhincome_sg_2000_3999_mi, hhincome_sg_4000_5999_mi, hhincome_sg_6000_mi) %>%
  mutate(m_cob="Native") %>%
  left_join (hh_pval_mi_sg, by=c("Exposure"="Exposure", "m_cob"="m_cob"))


##combine all cob

hhincome_cob_all_mi <- rbind(hhincome_xsg_all_mi, hhincome_sg_all_mi) %>%
  left_join(biomarker_desc, by="Exposure") %>%
  left_join(hh_pval_mi_int, by="Exposure") %>%
  mutate(ses="hhincome_mi") 

############################################################################################################################################

#medu_cc_cob
###########

medu_pval_mi_xsg <- medu_mi_cob_pval %>% 
  select(Exposure, p_value_xsg) %>% 
  rename_at(vars(p_value_xsg), ~str_remove(.,"_xsg")) %>% 
  mutate(m_cob="Non-native")

medu_pval_mi_sg <- medu_mi_cob_pval %>% 
  select(Exposure, p_value_sg) %>% 
  rename_at(vars(p_value_sg), ~str_remove(.,"_sg")) %>% 
  mutate(m_cob="Native")

medu_pval_mi_int <- medu_mi_cob_pval %>% 
  select(Exposure, p_value_int)


##xsg

medu_mi_xsg <- read_excel("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/medu_mi_full/##cob/coef/medu_mi_xsg.xlsx", sheet="Sheet2")

medu_xsg_sec_mi <- medu_mi_xsg %>%
  select(Exposure, coef_sec:lower_sec, N) %>% 
  rename_at(vars(coef_sec:lower_sec), ~str_remove(.,"_sec")) %>%
  mutate(ses_level="L2")

medu_xsg_dip_mi <- medu_mi_xsg %>%
  select(Exposure, coef_dip:lower_dip, N) %>% 
  rename_at(vars(coef_dip:lower_dip), ~str_remove(.,"_dip")) %>%
  mutate(ses_level="L3")

medu_xsg_uni_mi <- medu_mi_xsg %>%
  select(Exposure, coef_uni:N) %>%
  rename_at(vars(coef_uni:lower_uni), ~str_remove(.,"_uni")) %>%
  mutate(ses_level="L4")

medu_xsg_all_mi <- rbind(medu_xsg_sec_mi, medu_xsg_dip_mi, medu_xsg_uni_mi) %>%
  mutate (m_cob="Non-native") %>%
  left_join (medu_pval_mi_xsg, by=c("Exposure"="Exposure", "m_cob"="m_cob"))


##Native

medu_mi_sg <- read_excel("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/medu_mi_full/##cob/coef/medu_mi_sg.xlsx", sheet="Sheet2") 

medu_sg_sec_mi <- medu_mi_sg %>%
  select(Exposure, coef_sec:lower_sec, N) %>% 
  rename_at(vars(coef_sec:lower_sec), ~str_remove(.,"_sec")) %>%
  mutate(ses_level="L2")

medu_sg_dip_mi <- medu_mi_sg %>%
  select(Exposure, coef_dip:lower_dip, N) %>% 
  rename_at(vars(coef_dip:lower_dip), ~str_remove(.,"_dip")) %>%
  mutate(ses_level="L3")

medu_sg_uni_mi <- medu_mi_sg %>%
  select(Exposure, coef_uni:N) %>%
  rename_at(vars(coef_uni:lower_uni), ~str_remove(.,"_uni")) %>%
  mutate(ses_level="L4")

medu_sg_all_mi <- rbind(medu_sg_sec_mi, medu_sg_dip_mi, medu_sg_uni_mi) %>%
  mutate (m_cob="Native") %>%
  left_join (medu_pval_mi_sg, by=c("Exposure"="Exposure", "m_cob"="m_cob"))


##combine all cob

medu_cob_all_mi <- rbind(medu_xsg_all_mi, medu_sg_all_mi) %>%
  left_join(biomarker_desc, by="Exposure") %>%
  left_join(medu_pval_mi_int, by="Exposure") %>%
  mutate(ses="medu_mi") 

############################################################################################################################################

#fedu_cc_cob
###########

fedu_pval_mi_xsg <- fedu_mi_cob_pval %>% 
  select(Exposure, p_value_xsg) %>% 
  rename_at(vars(p_value_xsg), ~str_remove(.,"_xsg")) %>% 
  mutate(m_cob="Non-native")

fedu_pval_mi_sg <- fedu_mi_cob_pval %>% 
  select(Exposure, p_value_sg) %>% 
  rename_at(vars(p_value_sg), ~str_remove(.,"_sg")) %>% 
  mutate(m_cob="Native")

fedu_pval_mi_int <- fedu_mi_cob_pval %>% 
  select(Exposure, p_value_int)


##xsg

fedu_mi_xsg <- read_excel("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/fedu_mi_full/##cob/coef/fedu_mi_xsg.xlsx", sheet="Sheet2") 

fedu_xsg_sec_mi <- fedu_mi_xsg %>%
  select(Exposure, coef_sec:lower_sec, N) %>% 
  rename_at(vars(coef_sec:lower_sec), ~str_remove(.,"_sec")) %>%
  mutate(ses_level="L2")

fedu_xsg_dip_mi <- fedu_mi_xsg %>%
  select(Exposure, coef_dip:lower_dip, N) %>% 
  rename_at(vars(coef_dip:lower_dip), ~str_remove(.,"_dip")) %>%
  mutate(ses_level="L3")

fedu_xsg_uni_mi <- fedu_mi_xsg %>%
  select(Exposure, coef_uni:N) %>%
  rename_at(vars(coef_uni:lower_uni), ~str_remove(.,"_uni")) %>%
  mutate(ses_level="L4")

fedu_xsg_all_mi <- rbind(fedu_xsg_sec_mi, fedu_xsg_dip_mi, fedu_xsg_uni_mi) %>%
  mutate (m_cob="Non-native") %>%
  left_join (fedu_pval_mi_xsg, by=c("Exposure"="Exposure", "m_cob"="m_cob"))


##Native

fedu_mi_sg <- read_excel("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/fedu_mi_full/##cob/coef/fedu_mi_sg.xlsx", sheet="Sheet2")  

fedu_sg_sec_mi <- fedu_mi_sg %>%
  select(Exposure, coef_sec:lower_sec, N) %>% 
  rename_at(vars(coef_sec:lower_sec), ~str_remove(.,"_sec")) %>%
  mutate(ses_level="L2")

fedu_sg_dip_mi <- fedu_mi_sg %>%
  select(Exposure, coef_dip:lower_dip, N) %>% 
  rename_at(vars(coef_dip:lower_dip), ~str_remove(.,"_dip")) %>%
  mutate(ses_level="L3")

fedu_sg_uni_mi <- fedu_mi_sg %>%
  select(Exposure, coef_uni:N) %>%
  rename_at(vars(coef_uni:lower_uni), ~str_remove(.,"_uni")) %>%
  mutate(ses_level="L4")

fedu_sg_all_mi <- rbind(fedu_sg_sec_mi, fedu_sg_dip_mi, fedu_sg_uni_mi) %>%
  mutate (m_cob="Native") %>%
  left_join (fedu_pval_mi_sg, by=c("Exposure"="Exposure", "m_cob"="m_cob"))


##combine all cob

fedu_cob_all_mi <- rbind(fedu_xsg_all_mi, fedu_sg_all_mi) %>%
  left_join(biomarker_desc, by="Exposure") %>%
  left_join(fedu_pval_mi_int, by="Exposure") %>%
  mutate(ses="fedu_mi") 

############################################################################################################################################

#sai_cc_cob
###########

sai_pval_mi_xsg <- sai_mi_cob_pval %>% 
  select(Exposure, p_value_xsg) %>% 
  rename_at(vars(p_value_xsg), ~str_remove(.,"_xsg")) %>% 
  mutate(m_cob="Non-native")

sai_pval_mi_sg <- sai_mi_cob_pval %>% 
  select(Exposure, p_value_sg) %>% 
  rename_at(vars(p_value_sg), ~str_remove(.,"_sg")) %>% 
  mutate(m_cob="Native")

sai_pval_mi_int <- sai_mi_cob_pval %>% 
  select(Exposure, p_value_int)

##xsg

sai_mi_xsg <- read_excel("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/sai_mi_full/##cob/coef/sai_mi_xsg.xlsx", sheet="Sheet2") 

sai_xsg_93_6_95_mi <- sai_mi_xsg %>%
  select(Exposure, coef_93_6_95:lower_93_6_95, N) %>% 
  rename_at(vars(coef_93_6_95:lower_93_6_95), ~str_remove(.,"_93_6_95")) %>%
  mutate(ses_level="L2")

sai_xsg_95_1_97_2_mi <- sai_mi_xsg %>%
  select(Exposure, coef_95_1_97_2:lower_95_1_97_2, N) %>% 
  rename_at(vars(coef_95_1_97_2:lower_95_1_97_2), ~str_remove(.,"_95_1_97_2")) %>%
  mutate(ses_level="L3")

sai_xsg_97_2_mi <- sai_mi_xsg %>%
  select(Exposure, coef_97_2:N) %>%
  rename_at(vars(coef_97_2:lower_97_2), ~str_remove(.,"_97_2")) %>%
  mutate(ses_level="L4")

sai_xsg_all_mi <- rbind(sai_xsg_93_6_95_mi, sai_xsg_95_1_97_2_mi, sai_xsg_97_2_mi) %>%
  mutate (m_cob="Non-native") %>%
  left_join (sai_pval_mi_xsg, by=c("Exposure"="Exposure", "m_cob"="m_cob"))


##Native

sai_mi_sg <- read_excel("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/sai_mi_full/##cob/coef/sai_mi_sg.xlsx", sheet="Sheet2") 

sai_sg_93_6_95_mi <- sai_mi_sg %>%
  select(Exposure, coef_93_6_95:lower_93_6_95, N) %>% 
  rename_at(vars(coef_93_6_95:lower_93_6_95), ~str_remove(.,"_93_6_95")) %>%
  mutate(ses_level="L2")

sai_sg_95_1_97_2_mi <- sai_mi_sg %>%
  select(Exposure, coef_95_1_97_2:lower_95_1_97_2, N) %>% 
  rename_at(vars(coef_95_1_97_2:lower_95_1_97_2), ~str_remove(.,"_95_1_97_2")) %>%
  mutate(ses_level="L3")

sai_sg_97_2_mi <- sai_mi_sg %>%
  select(Exposure, coef_97_2:N) %>%
  rename_at(vars(coef_97_2:lower_97_2), ~str_remove(.,"_97_2")) %>%
  mutate(ses_level="L4")

sai_sg_all_mi <- rbind(sai_sg_93_6_95_mi, sai_sg_95_1_97_2_mi, sai_sg_97_2_mi) %>%
  mutate (m_cob="Native") %>%
  left_join (sai_pval_mi_sg, by=c("Exposure"="Exposure", "m_cob"="m_cob"))


##combine all cob

sai_cob_all_mi <- rbind(sai_xsg_all_mi, sai_sg_all_mi) %>%
  left_join(biomarker_desc, by="Exposure") %>%
  left_join(sai_pval_mi_int, by="Exposure") %>%
  mutate(ses="sai_mi") 

############################################################################################################################################

#sedi_cc_cob
###########

sedi_pval_mi_xsg <- sedi_mi_cob_pval %>% 
  select(Exposure, p_value_xsg) %>% 
  rename_at(vars(p_value_xsg), ~str_remove(.,"_xsg")) %>% 
  mutate(m_cob="Non-native")

sedi_pval_mi_sg <- sedi_mi_cob_pval %>% 
  select(Exposure, p_value_sg) %>% 
  rename_at(vars(p_value_sg), ~str_remove(.,"_sg")) %>% 
  mutate(m_cob="Native")

sedi_pval_mi_int <- sedi_mi_cob_pval %>% 
  select(Exposure, p_value_int)


##xsg
sedi_mi_xsg <- read_excel("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/sedi_mi_full/##cob/coef/sedi_mi_xsg.xlsx", sheet="Sheet2") 

sedi_xsg_100_3_101_6_mi <- sedi_mi_xsg %>%
  select(Exposure, coef_100_3_101_6:lower_100_3_101_6, N) %>% 
  rename_at(vars(coef_100_3_101_6:lower_100_3_101_6), ~str_remove(.,"_100_3_101_6")) %>%
  mutate(ses_level="L2")

sedi_xsg_101_7_105_6_mi <- sedi_mi_xsg %>%
  select(Exposure, coef_101_7_105_6:lower_101_7_105_6, N) %>% 
  rename_at(vars(coef_101_7_105_6:lower_101_7_105_6), ~str_remove(.,"_101_7_105_6")) %>%
  mutate(ses_level="L3")

sedi_xsg_105_6_mi <- sedi_mi_xsg %>%
  select(Exposure, coef_105_6:N) %>%
  rename_at(vars(coef_105_6:lower_105_6), ~str_remove(.,"_105_6")) %>%
  mutate(ses_level="L4")

sedi_xsg_all_mi <- rbind(sedi_xsg_100_3_101_6_mi, sedi_xsg_101_7_105_6_mi, sedi_xsg_105_6_mi) %>%
  mutate (m_cob="Non-native") %>%
  left_join (sedi_pval_mi_xsg, by=c("Exposure"="Exposure", "m_cob"="m_cob"))


##Native

sedi_mi_sg <- read_excel("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/sedi_mi_full/##cob/coef/sedi_mi_sg.xlsx", sheet="Sheet2")

sedi_sg_100_3_101_6_mi <- sedi_mi_sg %>%
  select(Exposure, coef_100_3_101_6:lower_100_3_101_6, N) %>% 
  rename_at(vars(coef_100_3_101_6:lower_100_3_101_6), ~str_remove(.,"_100_3_101_6")) %>%
  mutate(ses_level="L2")

sedi_sg_101_7_105_6_mi <- sedi_mi_sg %>%
  select(Exposure, coef_101_7_105_6:lower_101_7_105_6, N) %>% 
  rename_at(vars(coef_101_7_105_6:lower_101_7_105_6), ~str_remove(.,"_101_7_105_6")) %>%
  mutate(ses_level="L3")

sedi_sg_105_6_mi <- sedi_mi_sg %>%
  select(Exposure, coef_105_6:N) %>%
  rename_at(vars(coef_105_6:lower_105_6), ~str_remove(.,"_105_6")) %>%
  mutate(ses_level="L4")

sedi_sg_all_mi <- rbind(sedi_sg_100_3_101_6_mi, sedi_sg_101_7_105_6_mi, sedi_sg_105_6_mi) %>%
  mutate (m_cob="Native") %>%
  left_join (sedi_pval_mi_sg, by=c("Exposure"="Exposure", "m_cob"="m_cob"))

##combine all cob

sedi_cob_all_mi <- rbind(sedi_xsg_all_mi, sedi_sg_all_mi) %>%
  left_join(biomarker_desc, by="Exposure") %>%
  left_join(sedi_pval_mi_int, by="Exposure") %>%
  mutate(ses="sedi_mi") 

############################################################################################################################################


ses_mi_cob <- rbind(acc_cob_all_mi, hhincome_cob_all_mi, medu_cob_all_mi, fedu_cob_all_mi, sai_cob_all_mi, sedi_cob_all_mi) 

ses_mi_cob_sig <- ses_mi_cob %>% filter(p_value_int<0.05/134)

filter(ses_mi_cob, Exposure_name=="HDL-cholesterol " & ses=="medu_mi")

ses_mi_cob_sig_clean <-  ses_mi_cob %>%
  filter(Exposure_name!="Insulin_l", Exposure_name!="CRP_l", Exposure_name!="IFN-g", Exposure_name!="Creatinine_b") %>%
  mutate(significance=factor(case_when(p_value_int<0.05/134~1,
                                       p_value_int>=0.05/134~0))) 

ses_mi_cob_sig1 <-  ses_mi_cob_clean %>%
  filter(Exposure_name!="Insulin_l", Exposure_name!="CRP_l", Exposure_name!="IFN-g", Exposure_name!="Creatinine_b") %>%
  mutate(significance=factor(case_when(p_value_int<0.05/134~1,
                                       p_value_int>=0.05/134~0))) %>%
  filter(Exposure_name=="PFUnDA"|Exposure_name=="Folate"|Exposure_name=="HDL-cholesterol "|Exposure_name=="Copper"|Exposure_name=="3-Methylhistidine ")

cols <- c("0" = "black", "1" = "red")

ggplot(data=ses_mi_cob_sig1, aes(x=coef, y=reorder(Exposure_name, coef), shape=m_cob, linetype=m_cob, col=significance, alpha=significance)) +
  geom_point(aes(x=coef, y=Exposure_name), position=position_dodge(0.7), size=2) +
  geom_errorbarh(aes(xmin=lower, xmax=upper), height=.1, position=position_dodge(0.7)) +
  geom_vline(xintercept=0, color="black", linetype="dashed") +
  geom_text(data=mutate_if(filter(ses_mi_cob_sig1, m_cob=="Non-native"), is.numeric, round,2), 
            aes(label=glue("{coef} [{lower},{upper}]"), x=4), hjust="inward", size=2.5, nudge_y=0.16) +
  geom_text(data=mutate_if(filter(ses_mi_cob_sig1, m_cob=="Native"), is.numeric, round,2), 
            aes(label=glue("{coef} [{lower},{upper}]"), x=4), hjust="inward", size=2.5, nudge_y=-0.16) +
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
  scale_shape_discrete(breaks=c("Non-native", "Native")) + 
  scale_linetype_discrete(breaks=c("Non-native", "Native")) +
  scale_color_manual(values=cols, guide=F) +
  scale_alpha_discrete(range=c(0.5,1), guide=F) +
  labs(color=NULL) +
  ylab(NULL) +
  xlab("Beta coefficient")

ggsave("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/interaction_graph/cob_int_mi_full.png")

ggplot(data=ses_mi_cob_sig, aes(x=coef, y=reorder(Exposure_name, coef), shape=ses_level, linetype=ses_level)) +
  geom_point(aes(x=coef, y=Exposure_name), position=position_dodge(0.7), size=1.5) +
  geom_errorbarh(aes(xmin=lower, xmax=upper), height=.1, position=position_dodge(0.7)) +
  geom_vline(xintercept=0, color="black", linetype="dashed") +
  geom_text(data=mutate_if(filter(ses_mi_cob_sig, ses_level=="L2"), is.numeric, round,2), 
            aes(label=glue("{coef} [{lower},{upper}]"), x=7), hjust="inward", size=2, nudge_y=-0.24) +
  geom_text(data=mutate_if(filter(ses_mi_cob_sig, ses_level=="L3"), is.numeric, round,2), 
            aes(label=glue("{coef} [{lower},{upper}]"), x=7), hjust="inward", size=2) +
  geom_text(data=mutate_if(filter(ses_mi_cob_sig, ses_level=="L4"), is.numeric, round,2), 
            aes(label=glue("{coef} [{lower},{upper}]"), x=7), hjust="inward", size=2, nudge_y=0.24) +
  facet_grid(m_cob~ses, labeller=labeller(ses=
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

ggsave("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/interaction_graph/cob_int_mi_full1.png")

ggplot(data=ses_mi_cob_sig, aes(x=coef, y=reorder(Exposure_name, coef), shape=m_cob, linetype=m_cob)) +
  geom_point(aes(x=coef, y=Exposure_name), position=position_dodge(0.7), size=2) +
  geom_errorbarh(aes(xmin=lower, xmax=upper), height=.1, position=position_dodge(0.7)) +
  geom_vline(xintercept=0, color="black", linetype="dashed") +
  geom_text(data=mutate_if(filter(ses_mi_cob_sig, m_cob=="Non-native"), is.numeric, round,2), 
            aes(label=glue("{coef} [{lower},{upper}]"), x=5), hjust="inward", size=2.5, nudge_y=0.16) +
  geom_text(data=mutate_if(filter(ses_mi_cob_sig, m_cob=="Native"), is.numeric, round,2), 
            aes(label=glue("{coef} [{lower},{upper}]"), x=5), hjust="inward", size=2.5, nudge_y=-0.16) +
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
  scale_shape_discrete(breaks=c("Non-native", "Native")) + 
  scale_linetype_discrete(breaks=c("Non-native", "Native")) +
  labs(color=NULL) +
  ylab(NULL) +
  xlab("Beta coefficient")



