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

mc1_full_pval_mi_cob <- read_excel("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/EWAS_FMI_PVAL_COB.xlsx", sheet="mc1")

mc2_full_pval_mi_cob <- read_excel("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/EWAS_FMI_PVAL_COB.xlsx", sheet="mc2")

#MC1
#Non-native 

mc1_full_pval_mi_xsg <- mc1_full_pval_mi_cob %>% 
  select(Exposure, p_value_xsg) %>% 
  rename_at(vars(p_value_xsg), ~str_remove(.,"_xsg")) %>% 
  mutate(m_cob="Non-native")

mc1_full_xsg <- read_excel("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/dimensionality/coef/mca/mc_mi/clean/mc1_xsg.xlsx", sheet="Sheet2")  %>%
  left_join(mc1_full_pval_mi_xsg, by="Exposure") %>%
  rename_at(vars(coef_dim1:lower_dim1), ~str_remove(.,"_dim1")) %>%
  mutate(m_cob="Non-native")

#Native 
mc1_full_pval_mi_sg <- mc1_full_pval_mi_cob %>% 
  select(Exposure, p_value_sg) %>% 
  rename_at(vars(p_value_sg), ~str_remove(.,"_sg")) %>% 
  mutate(m_cob="Native")

mc1_full_sg <- read_excel("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/dimensionality/coef/mca/mc_mi/clean/mc1_sg.xlsx", sheet="Sheet2")  %>%
  left_join(mc1_full_pval_mi_sg, by="Exposure") %>%
  rename_at(vars(coef_dim1:lower_dim1), ~str_remove(.,"_dim1")) %>%
  mutate(m_cob="Native")

##combine all cob 

mc1_full_pval_mi_cob_int  <- mc1_full_pval_mi_cob %>% 
  select(Exposure, p_value_int) 

mc1_full_cob <- rbind(mc1_full_xsg, mc1_full_sg) %>%
  left_join(mc1_full_pval_mi_cob_int, by="Exposure") %>%
  mutate(ses="mc1") 

###########################################################

#MC2

#Non-native 
mc2_full_pval_mi_xsg <- mc2_full_pval_mi_cob %>% 
  select(Exposure, p_value_xsg) %>% 
  rename_at(vars(p_value_xsg), ~str_remove(.,"_xsg")) %>% 
  mutate(m_cob="Non-native")

mc2_full_xsg <- read_excel("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/dimensionality/coef/mca/mc_mi/clean/mc2_xsg.xlsx", sheet="Sheet2")  %>%
  left_join(mc2_full_pval_mi_xsg, by="Exposure") %>%
  rename_at(vars(coef_dim2:lower_dim2), ~str_remove(.,"_dim2")) %>%
  mutate(m_cob="Non-native")

#Native 
mc2_full_pval_mi_sg <- mc2_full_pval_mi_cob %>% 
  select(Exposure, p_value_sg) %>% 
  rename_at(vars(p_value_sg), ~str_remove(.,"_sg")) %>% 
  mutate(m_cob="Native")

mc2_full_sg <- read_excel("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/dimensionality/coef/mca/mc_mi/clean/mc2_sg.xlsx", sheet="Sheet2")  %>%
  left_join(mc2_full_pval_mi_sg, by="Exposure") %>%
  rename_at(vars(coef_dim2:lower_dim2), ~str_remove(.,"_dim2")) %>%
  mutate(m_cob="Native")

##combine all cob 

mc2_full_pval_mi_cob_int  <- mc2_full_pval_mi_cob %>% 
  select(Exposure, p_value_int) 

mc2_full_cob <- rbind(mc2_full_xsg, mc2_full_sg) %>%
  left_join(mc2_full_pval_mi_cob_int, by="Exposure") %>%
  mutate(ses="mc2") 

###################################################################################################

#Combine 2 dimensions 
mc_full_cob_mi <- rbind(mc1_full_cob, mc2_full_cob) %>%
  left_join(biomarker_desc, by="Exposure") 

mc_full_cob_mi_clean <- mc_full_cob_mi %>%
  filter(Exposure_name!="Insulin_l", Exposure_name!="CRP_l", Exposure_name!="IFN-g", Exposure_name!="Creatinine_b", 
         Exposure_name!="Gamma glutamyl transferase") %>%
  mutate(significance=factor(case_when(p_value_int<0.05/134~1,
                                       p_value_int>=0.05/134~0)))


mc_full_cob_mi_sig <- filter(mc_full_cob_mi_clean, p_value_int<0.05/134) 

mc_full_cob_mi_sig1 <- mc_full_cob_mi_clean %>% filter(Exposure_name=="Folate"| Exposure_name=="Copper"|Exposure_name=="Vitamin D3")

# plot template 
ggplot(data=mc_full_cob_mi_sig, aes(x=coef, y=reorder(Exposure_name, coef), shape=m_cob, linetype=m_cob)) +
  geom_point(aes(x=coef, y=Exposure_name), position=position_dodge(0.7), size=1.8) +
  geom_errorbarh(aes(xmin=lower, xmax=upper), height=.1, position=position_dodge(0.7)) +
  geom_vline(xintercept=0, color="black", linetype="dashed") +
  geom_text(data=mutate_if(filter(mc_full_cob_mi_sig, m_cob=="Non-native"), is.numeric, round,2), 
            aes(label=glue("{coef} [{lower},{upper}]"), x=1), hjust="inward", size=3.5, nudge_y=0.16) +
  geom_text(data=mutate_if(filter(mc_full_cob_mi_sig, m_cob=="Native"), is.numeric, round,2), 
            aes(label=glue("{coef} [{lower},{upper}]"), x=1), hjust="inward", size=3.5, nudge_y=-0.16) +
  geom_text(data=mutate_if(mc_full_cob_mi_sig, is.numeric, signif, 2), 
            aes(label=glue("p={p_value_int}"), x=1.3), hjust="inward", size=3.5) +
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
  scale_shape_discrete(breaks=c("Native", "Non-native")) + 
  scale_linetype_discrete(breaks=c("Native", "Non-native")) +
  labs(color=NULL) +
  ylab(NULL) +
  xlab("Beta coefficient")

ggsave("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/interaction_graph/cob_mca_mi_full.png")

ggplot(data=mc_full_cob_mi_sig, aes(x=coef, y=reorder(Exposure_name, coef))) +
  geom_point(aes(x=coef, y=Exposure_name), position=position_dodge(0.7), size=1.8) +
  geom_errorbarh(aes(xmin=lower, xmax=upper), height=.1, position=position_dodge(0.7)) +
  geom_vline(xintercept=0, color="black", linetype="dashed") +
  geom_text(data=mutate_if(filter(mc_full_cob_mi_sig, m_cob=="Non-native"), is.numeric, round,2), 
            aes(label=glue("{coef} [{lower},{upper}]"), x=1), hjust="inward", size=3.5, nudge_y=0.16) +
  geom_text(data=mutate_if(filter(mc_full_cob_mi_sig, m_cob=="Native"), is.numeric, round,2), 
            aes(label=glue("{coef} [{lower},{upper}]"), x=1), hjust="inward", size=3.5, nudge_y=-0.16) +
  geom_text(data=mutate_if(mc_full_cob_mi_sig, is.numeric, signif, 2), 
            aes(label=glue("p={p_value_int}"), x=1.3), hjust="inward", size=3.5) +
  facet_grid(m_cob~ses, labeller=labeller(ses=
                                       c("mc1"="MC1",
                                         "mc2"="MC2"))) +
  theme(
    legend.title = element_blank(),
    panel.border = element_blank(),
    panel.grid = element_blank(),
    axis.line = element_line(color="black"),
    panel.background = element_rect(fill="white")
  ) +
  labs(color=NULL) +
  ylab(NULL) +
  xlab("Beta coefficient")
