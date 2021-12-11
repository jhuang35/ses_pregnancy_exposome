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

biomarker_desc <- read.csv("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/data/raw_data/biomarker_desc.csv", header=TRUE)

acc_mi_pval <- read_excel("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/EWAS_FMI_PVAL.xlsx", sheet="acc")

hh_mi_pval <- read_excel("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/EWAS_FMI_PVAL.xlsx", sheet="hhincome") 

medu_mi_pval <- read_excel("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/EWAS_FMI_PVAL.xlsx", sheet="medu") 

fedu_mi_pval <- read_excel("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/EWAS_FMI_PVAL.xlsx", sheet="fedu")  

sai_mi_pval <- read_excel("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/EWAS_FMI_PVAL.xlsx", sheet="sai") 

sedi_mi_pval <- read_excel("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/EWAS_FMI_PVAL.xlsx", sheet="sedi") 


acc_mi <- read_excel("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/acc_mi_full/coef/acc_mi.xlsx", sheet="Sheet2")  


acc_3hdb_mi <- acc_mi %>%
  select(Exposure, coef_3hdb:lower_3hdb, N) %>%
  left_join(acc_mi_pval, by="Exposure") %>%
  rename_at(vars(coef_3hdb:lower_3hdb), ~str_remove(.,"_3hdb")) %>%
  mutate(ses_level="L2")

acc_4hdb_mi <- acc_mi  %>%
  select(Exposure, coef_4hdb:lower_4hdb, N) %>%
  left_join(acc_mi_pval, by="Exposure") %>%
  rename_at(vars(coef_4hdb:lower_4hdb), ~str_remove(.,"_4hdb")) %>%
  mutate(ses_level="L3")

acc_condo_landed_mi <- acc_mi  %>%
  select(Exposure, coef_condo_landed:N) %>%
  left_join(acc_mi_pval, by="Exposure") %>%
  rename_at(vars(coef_condo_landed:lower_condo_landed), ~str_remove(.,"_condo_landed")) %>%
  mutate(ses_level="L4")

acc_all_mi <- rbind(acc_3hdb_mi, acc_4hdb_mi, acc_condo_landed_mi) %>%
  left_join(biomarker_desc, by="Exposure") %>%
  mutate(ses="acc_mi")  

#########################################################################################################

hhincome_mi <- read_excel("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/hhincome_mi_full/coef/hhincome_mi.xlsx", sheet="Sheet2")

hhincome_2000_3999_mi <- hhincome_mi %>%
  select(Exposure, coef_2000_3999:lower_2000_3999, N) %>%
  left_join(hh_mi_pval, by="Exposure") %>%
  rename_at(vars(coef_2000_3999:lower_2000_3999), ~str_remove(.,"_2000_3999")) %>%
  mutate(ses_level="L2")

hhincome_4000_5999_mi <- hhincome_mi %>%
  select(Exposure, coef_4000_5999:lower_4000_5999, N) %>%
  left_join(hh_mi_pval, by="Exposure") %>%
  rename_at(vars(coef_4000_5999:lower_4000_5999), ~str_remove(.,"_4000_5999")) %>%
  mutate(ses_level="L3")

hhincome_6000_mi <- hhincome_mi %>%
  select(Exposure, coef_6000:N) %>%
  left_join(hh_mi_pval, by="Exposure") %>%
  rename_at(vars(coef_6000:lower_6000), ~str_remove(.,"_6000")) %>%
  mutate(ses_level="L4")

hhincome_all_mi <- rbind(hhincome_2000_3999_mi,hhincome_4000_5999_mi, hhincome_6000_mi ) %>%
  left_join(biomarker_desc, by="Exposure") %>%
  mutate(ses="hhincome_mi")  


#########################################################################################################

medu_mi <- read_excel("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/medu_mi_full/coef/medu_mi.xlsx", sheet="Sheet2")  

medu_sec_mi <- medu_mi %>%
  select(Exposure, coef_sec:lower_sec, N) %>%
  left_join(medu_mi_pval, by="Exposure") %>%
  rename_at(vars(coef_sec:lower_sec), ~str_remove(.,"_sec")) %>%
  mutate(ses_level="L2")

medu_dip_mi <- medu_mi %>%
  select(Exposure, coef_dip:lower_dip, N) %>%
  left_join(medu_mi_pval, by="Exposure") %>%
  rename_at(vars(coef_dip:lower_dip), ~str_remove(.,"_dip")) %>%
  mutate(ses_level="L3")

medu_uni_mi <- medu_mi %>%
  select(Exposure, coef_uni:lower_uni, N) %>%
  left_join(medu_mi_pval, by="Exposure") %>%
  rename_at(vars(coef_uni:N), ~str_remove(.,"_uni")) %>%
  mutate(ses_level="L4")

medu_all_mi <- rbind(medu_sec_mi, medu_dip_mi, medu_uni_mi) %>%
  left_join(biomarker_desc, by="Exposure") %>%
  mutate(ses="medu_mi")  

#########################################################################################################

fedu_mi <- read_excel("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/fedu_mi_full/coef/fedu_mi.xlsx", sheet="Sheet2")  

fedu_sec_mi <- fedu_mi %>%
  select(Exposure, coef_sec:lower_sec, N) %>%
  left_join(fedu_mi_pval, by="Exposure") %>%
  rename_at(vars(coef_sec:lower_sec), ~str_remove(.,"_sec")) %>%
  mutate(ses_level="L2")

fedu_dip_mi <- fedu_mi %>%
  select(Exposure, coef_dip:lower_dip, N) %>%
  left_join(fedu_mi_pval, by="Exposure") %>%
  rename_at(vars(coef_dip:lower_dip), ~str_remove(.,"_dip")) %>%
  mutate(ses_level="L3")

fedu_uni_mi <- fedu_mi %>%
  select(Exposure, coef_uni:lower_uni, N) %>%
  left_join(fedu_mi_pval, by="Exposure") %>%
  rename_at(vars(coef_uni:N), ~str_remove(.,"_uni")) %>%
  mutate(ses_level="L4")

fedu_all_mi <- rbind(fedu_sec_mi, fedu_dip_mi, fedu_uni_mi) %>%
  left_join(biomarker_desc, by="Exposure") %>%
  mutate(ses="fedu_mi")  

#########################################################################################################

sai_mi <- read_excel("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/sai_mi_full/coef/sai_mi.xlsx", sheet="Sheet2") 

sai_93_6_95_mi <- sai_mi %>%
  select(Exposure, coef_93_6_95:lower_93_6_95, N) %>%
  left_join(sai_mi_pval, by="Exposure") %>%
  rename_at(vars(coef_93_6_95:lower_93_6_95), ~str_remove(.,"_93_6_95")) %>%
  mutate(ses_level="L2")

sai_95_1_97_2_mi <- sai_mi %>%
  select(Exposure, coef_95_1_97_2:lower_95_1_97_2, N) %>%
  left_join(sai_mi_pval, by="Exposure") %>%
  rename_at(vars(coef_95_1_97_2:lower_95_1_97_2), ~str_remove(.,"_95_1_97_2")) %>%
  mutate(ses_level="L3")

sai_97_2_mi <- sai_mi %>%
  select(Exposure, coef_97_2:N) %>%
  left_join(sai_mi_pval, by="Exposure") %>%
  rename_at(vars(lower_97_2:coef_97_2), ~str_remove(.,"_97_2")) %>%
  mutate(ses_level="L4")

sai_all_mi <- rbind(sai_93_6_95_mi, sai_95_1_97_2_mi, sai_97_2_mi) %>%
  left_join(biomarker_desc, by="Exposure") %>%
  mutate(ses="sai_mi")  

#########################################################################################################

sedi_mi <- read_excel("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/sedi_mi_full/coef/sedi_mi.xlsx", sheet="Sheet2") 

sedi_100_3_101_6_mi <- sedi_mi %>%
  select(Exposure, coef_100_3_101_6:lower_100_3_101_6, N) %>%
  left_join(sedi_mi_pval, by="Exposure") %>%
  rename_at(vars(coef_100_3_101_6:lower_100_3_101_6), ~str_remove(.,"_100_3_101_6")) %>%
  mutate(ses_level="L2")


sedi_101_7_105_6_mi <- sedi_mi %>%
  select(Exposure, coef_101_7_105_6:lower_101_7_105_6, N) %>%
  left_join(sedi_mi_pval, by="Exposure") %>%
  rename_at(vars(coef_101_7_105_6:lower_101_7_105_6), ~str_remove(.,"_101_7_105_6")) %>%
  mutate(ses_level="L3")

sedi_105_6_mi <- sedi_mi %>%
  select(Exposure, coef_105_6:N) %>%
  left_join(sedi_mi_pval, by="Exposure") %>%
  rename_at(vars(coef_105_6:lower_105_6), ~str_remove(.,"_105_6")) %>%
  mutate(ses_level="L4")

sedi_all_mi <- rbind(sedi_100_3_101_6_mi, sedi_101_7_105_6_mi, sedi_105_6_mi) %>%
  left_join(biomarker_desc, by="Exposure") %>%
  mutate(ses="sedi_mi")  

#########################################################################################################

ses_mi <- rbind(acc_all_mi, hhincome_all_mi, medu_all_mi, fedu_all_mi, sai_all_mi, sedi_all_mi) 

View(ses_mi)

ses_mi_clean <- ses_mi %>%
  filter(Exposure_name!="Insulin_l", Exposure_name!="CRP_l", Exposure_name!="IFN-g", Exposure_name!="Creatinine_b") %>%
  mutate(significance=factor(case_when(p_value<0.05/134~1,
                                       p_value>=0.05/134~0))) 

ses_mi_sig <- ses_mi_clean %>% filter(p_value<0.05/134)

#30 biomarkers
#add IGF-II, phosphorus
#remove Subscapular skinfold at pw26

cols <- c("0" = "black", "1" = "red")

#31 biomarkers
ses_mi_clean_sig <- ses_mi_clean %>% 
  filter(Exposure_name=="IGF-II"|Exposure_name=="DPA "|Exposure_name=="Folate"
         |Exposure_name=="EPA "|Exposure_name=="Height at pw26"|Exposure_name=="PM2.5 1st tri "
         |Exposure_name=="Triceps skinfold at pw26"|Exposure_name=="PM2.5 pregnancy "|Exposure_name=="PM2.5 3rd tri"
         |Exposure_name=="PM2.5 2nd tri"|Exposure_name=="Avg antenatal weight 1st tri "|Exposure_name=="Midarm circumference at pw26"
         |Exposure_name=="Avg antenatal weight 2nd tri"|Exposure_name=="Weight at pw26 " |Exposure_name=="Subscapular skinfold at pw26"
         |Exposure_name=="Neopterin"|Exposure_name=="Fasting glucose"|Exposure_name=="Last antenatal weight")

ggplot(data=ses_mi_clean_sig, aes(x=coef, y=reorder(Exposure_name, coef), shape=ses_level, linetype=ses_level, col=significance, alpha=significance)) +
  geom_point(aes(x=coef, y=reorder(Exposure_name, coef)), position=position_dodge(0.7), size=1.2) +
  geom_errorbarh(aes(xmin=lower, xmax=upper), height=.1, position=position_dodge(0.7)) +
  geom_vline(xintercept=0, color="black", linetype="dashed") +
  geom_text(data=mutate_if(filter(ses_mi_clean_sig, ses_level=="L2"), is.numeric, round,2), 
            aes(label=glue("{coef} [{lower},{upper}]"), x=3), hjust="inward", size=1.8, nudge_y=-0.24) +
  geom_text(data=mutate_if(filter(ses_mi_clean_sig, ses_level=="L3"), is.numeric, round,2), 
            aes(label=glue("{coef} [{lower},{upper}]"), x=3), hjust="inward", size=1.8) +
  geom_text(data=mutate_if(filter(ses_mi_clean_sig, ses_level=="L4"), is.numeric, round,2), 
            aes(label=glue("{coef} [{lower},{upper}]"), x=3), hjust="inward", size=1.8, nudge_y=0.24) +
  facet_wrap(~ses, labeller=labeller(ses=
                                       c("acc_mi"="Accommodation",
                                         "hhincome_mi"="Household Income",
                                         "medu_mi"="Maternal Education", 
                                         "fedu_mi"="Paternal Education", 
                                         "sai_mi"="SAI", 
                                         "sedi_mi"="SEDI")),
             ncol=6) +
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

ggsave("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/ewas_cc_graph/ewas_summ_mi_full.png")

ggplot(data=ses_mi_sig, aes(x=coef, y=reorder(Exposure_name, coef), shape=ses_level, linetype=ses_level)) +
  geom_point(aes(x=coef, y=reorder(Exposure_name, coef)), position=position_dodge(0.7), size=1.2) +
  geom_errorbarh(aes(xmin=lower, xmax=upper), height=.1, position=position_dodge(0.7)) +
  geom_vline(xintercept=0, color="black", linetype="dashed") +
  geom_text(data=mutate_if(filter(ses_mi_sig, ses_level=="L2"), is.numeric, round,2), 
            aes(label=glue("{coef} [{lower},{upper}]"), x=3), hjust="inward", size=1.8, nudge_y=-0.24) +
  geom_text(data=mutate_if(filter(ses_mi_sig, ses_level=="L3"), is.numeric, round,2), 
            aes(label=glue("{coef} [{lower},{upper}]"), x=3), hjust="inward", size=1.8) +
  geom_text(data=mutate_if(filter(ses_mi_sig, ses_level=="L4"), is.numeric, round,2), 
            aes(label=glue("{coef} [{lower},{upper}]"), x=3), hjust="inward", size=1.8, nudge_y=0.24) +
  facet_wrap(~ses, labeller=labeller(ses=
                                       c("acc_mi"="Accommodation",
                                         "hhincome_mi"="Household income",
                                         "medu_mi"="Maternal education", 
                                         "fedu_mi"="Paternal education", 
                                         "sai_mi"="SAI", 
                                         "sedi_mi"="SEDI")),
             ncol=6) +
  theme(
    legend.title = element_blank(),
    panel.border = element_blank(),
    panel.grid = element_blank(),
    axis.line = element_line(color="black"),
    panel.background = element_rect(fill="white")
  ) +
  scale_shape_discrete(breaks=c("L4", "L3", "L2")) +
  scale_linetype_discrete(breaks=c("L4", "L3", "L2")) + 
  labs(color=NULL) +
  ylab(NULL) +
  xlab("Beta coefficient")

###########################################################################

#P_val and SD change

acc_mi_man <- ggplot(filter(ses_mi, ses=="acc", ses_level=="L4"), aes(x=coef, y=-log10(p_value_F_test))) +
  geom_point(aes(color=Family, shape=Family),size=1.5, position="jitter") + 
  geom_hline(yintercept=-log10(0.05/130), linetype="dashed") +
  geom_vline(xintercept=0, linetype="dashed") +
  theme_bw() +
  theme( 
    panel.border = element_rect(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(), 
    axis.title.x = element_blank()
  ) +
  geom_text_repel(data=ses_mi %>% filter(p_value_F_test<0.05/130, ses=="acc", ses_level=="L4"),
                  aes(label=Exposure)) +
  scale_color_paletteer_d("ggthemes::calc") +
  scale_shape_manual(values=seq(0,10)) +
  labs(y="-Log P-value",x="SD change", title="Accommodation")

acc_mi_man 

?geom_text_repel

hhincome_mi_man <- ggplot(filter(ses_mi, ses=="hhincome", ses_level=="L4"), aes(x=coef, y=-log10(p_value_F_test))) +
  geom_point(aes(color=Family, shape=Family),size=1.5, position="jitter") + 
  geom_hline(yintercept=-log10(0.05/130), linetype="dashed") +
  geom_vline(xintercept=0, linetype="dashed") +
  theme_bw() +
  theme( 
    panel.border = element_rect(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.title.y = element_blank()
  ) +
  geom_text_repel(data=ses_mi %>% filter(p_value_F_test<0.05/130, ses=="hhincome", ses_level=="L4"),
                  aes(label=Exposure), size=3) +
  scale_color_paletteer_d("ggthemes::calc") +
  scale_shape_manual(values=seq(0,10)) +
  labs(y="-Log P-value", x="SD change", title="Household Income")

hhincome_mi_man 

medu_mi_man <- ggplot(filter(ses_mi, ses=="medu", ses_level=="L4"), aes(x=coef, y=-log10(p_value_F_test))) +
  geom_point(aes(color=Family, shape=Family),size=1.5, position="jitter") + 
  geom_hline(yintercept=-log10(0.05/130), linetype="dashed") +
  geom_vline(xintercept=0, linetype="dashed") +
  theme_bw() +
  theme( 
    panel.border = element_rect(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(), 
    axis.title.y = element_blank()
  ) +
  geom_text_repel(data=ses_mi %>% filter(p_value_F_test<0.05/130, ses=="medu", ses_level=="L4"),
                  aes(label=Exposure), size=3) +
  scale_color_paletteer_d("ggthemes::calc") +
  scale_shape_manual(values=seq(0,10)) +
  labs(y="-Log P-value", x="SD change", title="Maternal Education")

medu_mi_man 


fedu_mi_man <- ggplot(filter(ses_mi, ses=="fedu", ses_level=="L4"), aes(x=coef, y=-log10(p_value_F_test))) +
  geom_point(aes(color=Family, shape=Family),size=1.5, position="jitter") + 
  geom_hline(yintercept=-log10(0.05/130), linetype="dashed") +
  geom_vline(xintercept=0, linetype="dashed") +
  theme_bw() +
  theme( 
    panel.border = element_rect(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.title.y=element_blank(), 
  ) +
  geom_text_repel(data=ses_mi%>% filter(p_value_F_test<0.05/130, ses=="fedu", ses_level=="L4"),
                  aes(label=Exposure), size=3) +
  scale_color_paletteer_d("ggthemes::calc") +
  scale_shape_manual(values=seq(0,10)) +
  labs(y="-Log P-value", x="SD change", title="Paternal education")

fedu_mi_man 


sai_mi_man <- ggplot(filter(ses_mi, ses=="sai", ses_level=="L4"), aes(x=coef, y=-log10(p_value_F_test))) +
  geom_point(aes(color=Family, shape=Family),size=1.5, position="jitter") + 
  geom_hline(yintercept=-log10(0.05/130), linetype="dashed") +
  geom_vline(xintercept=0, linetype="dashed") +
  theme_bw() +
  theme( 
    panel.border = element_rect(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank()
  ) +
  geom_text_repel(data=ses_mi %>% filter(p_value_F_test<0.05/130, ses=="sai", ses_level=="L4"),
                  aes(label=Exposure), size=3) +
  scale_color_paletteer_d("ggthemes::calc") +
  xlab("SD change") +
  scale_shape_manual(values=seq(0,10)) +
  labs(y="-Log P-value", title="SAI")

sai_mi_man 

sedi_mi_man <- ggplot(filter(ses_mi, ses=="sedi", ses_level=="L4"), aes(x=coef, y=-log10(p_value_F_test))) +
  geom_point(aes(color=Family, shape=Family),size=1.5, position="jitter") + 
  geom_hline(yintercept=-log10(0.05/130), linetype="dashed") +
  geom_vline(xintercept=0, linetype="dashed") +
  theme_bw() +
  theme( 
    panel.border = element_rect(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.title.y=element_blank()
  ) +
  geom_text_repel(data=ses_mi %>% filter(p_value_F_test<0.05/130, ses=="sedi", ses_level=="L4"),
                  aes(label=Exposure), size=3) +
  scale_color_paletteer_d("ggthemes::calc") +
  xlab("SD change") +
  scale_shape_manual(values=seq(0,10))+
  labs(title="SEDI")

sedi_mi_man 

pval_man_mi <- ggarrange(acc_mi_man, hhincome_mi_man, medu_mi_man, fedu_mi_man, sai_mi_man, sedi_mi_man,
                         ncol = 2, nrow = 3, 
                         common.legend = T, align="hv", 
                         legend="bottom")

pval_man_mi

ggarrange(acc_mi_man, hhincome_mi_man, ncol = 2, 
          common.legend = T, align="hv", 
          legend="bottom")

ggsave("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/ewas_cc_graph/p_val1_mi.png")

ggarrange(medu_mi_man, fedu_mi_man, ncol = 2,
          common.legend = T, align="hv", 
          legend="bottom")

ggsave("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/ewas_cc_graph/p_val2_mi.png")

ggarrange(sai_mi_man, sedi_mi_man, ncol = 2,
          common.legend = T, align="hv", 
          legend="bottom")

ggsave("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/ewas_cc_graph/p_val_aSES_mi.png")

ggarrange(acc_mi_man, hhincome_mi_man, medu_mi_man, fedu_mi_man, nrow=1, 
          common.legend = T, align="hv", 
          legend="bottom")

ggsave("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/ewas_cc_graph/p_val_iSES_mi.png")

