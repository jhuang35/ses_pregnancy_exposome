library(tidyverse)
library(dplyr)
library(RColorBrewer)
library(ggrepel)
library(paletteer)
library(ggpubr)
library(readxl)
library(glue)
library(writexl)
library(data.table)


#biomarker cc data 

biomarker_desc <- read.csv("e:/sumkk/ses-exposome/data/raw_data/biomarker_desc.csv", header=TRUE)

mc1_full_pval_mi_eth <- read_excel("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/EWAS_FMI_PVAL_ETH.xlsx", sheet="mc1")

mc2_full_pval_mi_eth <- read_excel("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/EWAS_FMI_PVAL_ETH.xlsx", sheet="mc2")

#MC1
#Chinese 

mc1_full_pval_mi_chi <- mc1_full_pval_mi_eth %>% 
  select(Exposure, p_value_chi) %>% 
  rename_at(vars(p_value_chi), ~str_remove(.,"_chi")) %>% 
  mutate(m_ethnicity="Chinese")

mc1_full_chi <- read_excel("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/dimensionality/coef/mca/mc_mi/clean/mc1_chi.xlsx", sheet="Sheet2")  %>%
  left_join(mc1_full_pval_mi_chi, by="Exposure") %>%
  rename_at(vars(coef_dim1:lower_dim1), ~str_remove(.,"_dim1")) %>%
  mutate(m_ethnicity="Chinese")

#Indian 
mc1_full_pval_mi_ind <- mc1_full_pval_mi_eth %>% 
  select(Exposure, p_value_ind) %>% 
  rename_at(vars(p_value_ind), ~str_remove(.,"_ind")) %>% 
  mutate(m_ethnicity="Indian")

mc1_full_ind <- read_excel("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/dimensionality/coef/mca/mc_mi/clean/mc1_ind.xlsx", sheet="Sheet2")  %>%
  left_join(mc1_full_pval_mi_ind, by="Exposure") %>%
  rename_at(vars(coef_dim1:lower_dim1), ~str_remove(.,"_dim1")) %>%
  mutate(m_ethnicity="Indian")

#Malay 
mc1_full_pval_mi_mal <- mc1_full_pval_mi_eth %>% 
  select(Exposure, p_value_mal) %>% 
  rename_at(vars(p_value_mal), ~str_remove(.,"_mal")) %>% 
  mutate(m_ethnicity="Malay")

mc1_full_mal <- read_excel("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/dimensionality/coef/mca/mc_mi/clean/mc1_mal.xlsx", sheet="Sheet2")  %>%
  left_join(mc1_full_pval_mi_mal, by="Exposure") %>%
  rename_at(vars(coef_dim1:lower_dim1), ~str_remove(.,"_dim1")) %>%
  mutate(m_ethnicity="Malay")

##combine all ethnicities 

mc1_full_pval_mi_int  <- mc1_full_pval_mi_eth %>% 
  select(Exposure, p_value_int) 

mc1_full_eth <- rbind(mc1_full_chi, mc1_full_ind, mc1_full_mal) %>%
  left_join(mc1_full_pval_mi_int, by="Exposure") %>%
  mutate(ses="mc1") 

###########################################################

#MC2

#Chinese 
mc2_full_pval_mi_chi <- mc2_full_pval_mi_eth %>% 
  select(Exposure, p_value_chi) %>% 
  rename_at(vars(p_value_chi), ~str_remove(.,"_chi")) %>% 
  mutate(m_ethnicity="Chinese")

mc2_full_chi <- read_excel("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/dimensionality/coef/mca/mc_mi/clean/mc2_chi.xlsx", sheet="Sheet2")  %>%
  left_join(mc2_full_pval_mi_chi, by="Exposure") %>%
  rename_at(vars(coef_dim2:lower_dim2), ~str_remove(.,"_dim2")) %>%
  mutate(m_ethnicity="Chinese")

#Indian 
mc2_full_pval_mi_ind <- mc2_full_pval_mi_eth %>% 
  select(Exposure, p_value_ind) %>% 
  rename_at(vars(p_value_ind), ~str_remove(.,"_ind")) %>% 
  mutate(m_ethnicity="Indian")

mc2_full_ind <- read_excel("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/dimensionality/coef/mca/mc_mi/clean/mc2_ind.xlsx", sheet="Sheet2")  %>%
  left_join(mc2_full_pval_mi_ind, by="Exposure") %>%
  rename_at(vars(coef_dim2:lower_dim2), ~str_remove(.,"_dim2")) %>%
  mutate(m_ethnicity="Indian")

#Malay 
mc2_full_pval_mi_mal <- mc2_full_pval_mi_eth %>% 
  select(Exposure, p_value_mal) %>% 
  rename_at(vars(p_value_mal), ~str_remove(.,"_mal")) %>% 
  mutate(m_ethnicity="Malay")

mc2_full_mal <- read_excel("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/dimensionality/coef/mca/mc_mi/clean/mc2_mal.xlsx", sheet="Sheet2")  %>%
  left_join(mc2_full_pval_mi_mal, by="Exposure") %>%
  rename_at(vars(coef_dim2:lower_dim2), ~str_remove(.,"_dim2")) %>%
  mutate(m_ethnicity="Malay")

##combine all ethnicities 

mc2_full_pval_mi_int  <- mc2_full_pval_mi_eth %>% 
  select(Exposure, p_value_int) 

mc2_full_eth <- rbind(mc2_full_chi, mc2_full_ind, mc2_full_mal) %>%
  left_join(mc2_full_pval_mi_int, by="Exposure") %>%
  mutate(ses="mc2") 
###################################################################################################

#Combine 3 dimensions 
mc_full_eth_mi <- rbind(mc1_full_eth, mc2_full_eth) %>%
  left_join(biomarker_desc, by="Exposure") 

mc_full_eth_mi_clean <- mc_full_eth_mi %>%
  filter(Exposure_name!="Insulin_l", Exposure_name!="CRP_l", Exposure_name!="IFN-g", Exposure_name!="Creatinine_b", 
         Exposure_name!="Gamma glutamyl transferase") %>%
  mutate(significance=factor(case_when(p_value_int<0.05/134~1,
                                       p_value_int>=0.05/134~0)))


mc_full_eth_mi_sig <- filter(mc_full_eth_mi_clean, p_value_int<0.05/134)

mc_full_eth_mi_sig1 <- mc_full_eth_mi_clean %>% 
  filter(Exposure_name=="PFUnDA"| Exposure_name=="PFOS"| Exposure_name=="PFDA")

cols <- c("0" = "black", "1" = "red")

ggplot(data=mc_full_eth_mi_sig, aes(x=coef, y=reorder(Exposure_name, coef), shape=m_ethnicity, linetype=m_ethnicity)) +
  geom_point(aes(x=coef, y=Exposure_name), position=position_dodge(0.7), size=1.8) +
  geom_errorbarh(aes(xmin=lower, xmax=upper), height=.1, position=position_dodge(0.7)) +
  geom_vline(xintercept=0, color="black", linetype="dashed") +
  geom_text(data=mutate_if(filter(mc_full_eth_mi_sig, m_ethnicity=="Chinese"), is.numeric, round,2), 
            aes(label=glue("{coef} [{lower},{upper}]"), x=1.7), hjust="inward", size=3.5, nudge_y=-0.24) +
  geom_text(data=mutate_if(filter(mc_full_eth_mi_sig, m_ethnicity=="Indian"), is.numeric, round,2), 
            aes(label=glue("{coef} [{lower},{upper}]"), x=1.7), hjust="inward", size=3.5) +
  geom_text(data=mutate_if(filter(mc_full_eth_mi_sig, m_ethnicity=="Malay"), is.numeric, round,2), 
            aes(label=glue("{coef} [{lower},{upper}]"), x=1.7), hjust="inward", size=3.5, nudge_y=0.24) +
  geom_text(data=mutate_if(mc_full_eth_mi_sig, is.numeric, signif, 2), 
            aes(label=glue("p={p_value_int}"), x=2), hjust="inward", size=3.5) +
  facet_wrap(~ses, labeller=labeller(ses=
                                       c("mc1"="MC1",
                                         "mc2"="MC2"))) +
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

ggsave("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/interaction_graph/eth_mca_mi_full.png")


