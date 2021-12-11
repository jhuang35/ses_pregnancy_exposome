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

#EWAS MI (ewas_mi_full_forest.R)
#18 biomarkers
ses_mi_clean_sig <- ses_mi_clean %>% 
  filter(Exposure_name=="IGF-II"|Exposure_name=="DPA "|Exposure_name=="Folate"
         |Exposure_name=="EPA "|Exposure_name=="Height at pw26"|Exposure_name=="PM2.5 1st trimester "
         |Exposure_name=="Triceps skinfold at pw26"|Exposure_name=="PM2.5 pregnancy "|Exposure_name=="PM2.5 3rd trimester"
         |Exposure_name=="PM2.5 2nd trimester"|Exposure_name=="Avg antenatal weight 1st trimester "|Exposure_name=="Midarm circumference at pw26"
         |Exposure_name=="Avg antenatal weight 2nd trimester"|Exposure_name=="Weight at pw26 " |Exposure_name=="Subscapular skinfold at pw26"
         |Exposure_name=="Neopterin"|Exposure_name=="Fasting glucose"|Exposure_name=="Last antenatal weight")

mc_all_mi_clean %>% filter(Exposure_name=="C-reactive protein")

#19 biomarkers (ewas_mi_full_mca.R)
mc_all_mi_all_sig <- mc_all_mi_clean %>% 
  filter(Exposure_name=="Kynurenine "|Exposure_name=="Folate" | Exposure_name== "Biceps skinfold at pw26"
         |Exposure_name=="N1-methylnicotinamide  "|Exposure_name=="Height at pw26" |Exposure_name=="Neopterin "
         |Exposure_name=="Triceps skinfold at pw26" |Exposure_name=="Avg antenatal weight 1st trimester " |Exposure_name=="Avg antenatal weight 2nd trimester"
         |Exposure_name=="Midarm circumference at pw26"|Exposure_name=="Subscapular skinfold at pw26"|Exposure_name=="Weight at pw26 "
         |Exposure_name=="Last antenatal weight" |Exposure_name=="IGF-II"|Exposure_name=="DPA "
         |Exposure_name=="Total cysteine " |Exposure_name=="PM2.5 2nd trimester"|Exposure_name=="PM2.5 pregnancy "|Exposure_name=="PM2.5 3rd trimester" )
  
#mc_all_mi_clean1= mc_all_mi_clean *(-1)


comb_mi <- ses_mi_clean %>% 
  mutate(p_value_quad="NA")

comb_mc <- mc_all_mi_clean1 %>%
  mutate(ses_level="NA")

comb_mi_full <- rbind(comb_mi, comb_mc) 

comb_mi_full$ses <- factor(comb_mi_full$ses, 
                           levels=c("acc_mi", "hhincome_mi", "medu_mi","fedu_mi", "sai_mi", "sedi_mi", "mc1", "mc2"))

#without *-1
comb_mc_ori <- mc_all_mi_clean %>%
  select(-(p_value_quad)) %>%
  mutate(ses_level="NA", p_value_quad="NA")

comb_mi_full_ori <- rbind(comb_mi, comb_mc_ori) %>%
  mutate(model="linear", coef_term="linear") %>%
  select(-(significance)) %>%
  rbind(mc_quad)

comb_mi_full_ori$ses <- factor(comb_mi_full_ori$ses, 
                           levels=c("acc_mi", "hhincome_mi", "medu_mi","fedu_mi", "sai_mi", "sedi_mi", "mc1", "mc2"))


write_xlsx(comb_mi_full_ori, "C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/write up/raw_coef.xlsx")

#dataset for mi_mc
#22 biomarkers

comb_mi_full$ses_level <- str_replace_all(comb_mi_full$ses_level, c("L4"="L4-L1", "L3"="L3-L1","L2"="L2-L1"))

comb_mi_full_clean <- comb_mi_full %>%
  filter(Exposure_name=="IGF-II"|Exposure_name=="DPA "|Exposure_name=="Folate"
         |Exposure_name=="EPA "|Exposure_name=="Height at pw26"|Exposure_name=="PM2.5 1st trimester "
         |Exposure_name=="Triceps skinfold at pw26"|Exposure_name=="PM2.5 pregnancy "|Exposure_name=="PM2.5 3rd trimester"
         |Exposure_name=="PM2.5 2nd trimester"|Exposure_name=="Avg antenatal weight 1st trimester "|Exposure_name=="Midarm circumference at pw26"
         |Exposure_name=="Avg antenatal weight 2nd trimester"|Exposure_name=="Weight at pw26 " |Exposure_name=="Subscapular skinfold at pw26"
         |Exposure_name=="Neopterin "|Exposure_name=="Fasting glucose"|Exposure_name=="Last antenatal weight"
         |Exposure_name=="Kynurenine "| Exposure_name== "Biceps skinfold at pw26"|Exposure_name=="N1-methylnicotinamide  "
         |Exposure_name=="Total cysteine ")

#individual ses (17 biomarkers)
ind_comb_mi_full_clean <- comb_mi_full %>%
  filter(ses!="mc2", ses!="sai_mi", ses!="sedi_mi") %>% 
  filter(Exposure_name=="IGF-II"|Exposure_name=="DPA "|Exposure_name=="Folate"
         |Exposure_name=="EPA "|Exposure_name=="Height at pw26" |Exposure_name=="Triceps skinfold at pw26"
         |Exposure_name=="Avg antenatal weight 1st trimester "|Exposure_name=="Midarm circumference at pw26"
         |Exposure_name=="Avg antenatal weight 2nd trimester"|Exposure_name=="Weight at pw26 " |Exposure_name=="Subscapular skinfold at pw26"
         |Exposure_name=="Neopterin "|Exposure_name=="Fasting glucose"|Exposure_name=="Last antenatal weight"
         |Exposure_name=="Kynurenine "| Exposure_name== "Biceps skinfold at pw26"|Exposure_name=="N1-methylnicotinamide  ")
  

#neighborhood ses (5 biomarkers)
area_comb_mi_full_clean <- comb_mi_full %>%
  filter(ses=="mc2"| ses=="sai_mi"| ses=="sedi_mi") %>% 
  filter(Exposure_name=="PM2.5 1st trimester "|Exposure_name=="PM2.5 pregnancy "|Exposure_name=="PM2.5 3rd trimester"
         |Exposure_name=="PM2.5 2nd trimester"|Exposure_name=="Total cysteine ")

#neighborhood ses (5 biomarkers) w/o mc2
area_comb_mi_full_clean1 <- comb_mi_full %>%
  filter(ses=="sai_mi"| ses=="sedi_mi") %>% 
  filter(Exposure_name=="PM2.5 1st trimester "|Exposure_name=="PM2.5 pregnancy "|Exposure_name=="PM2.5 3rd trimester"
         |Exposure_name=="PM2.5 2nd trimester")

#ind
df_col <- data.frame(Family = levels(factor(ind_comb_mi_full_clean$Family)), 
                     color1 = c("#A6CEE3", "#FDBF6F", "#1F78B4", "#B2DF8A", "#33A02C", "#FB9A99","#E31A1C")) %>%
  mutate(Family=as.character(Family))

color1 = c("#A6CEE3", "#FDBF6F", "#1F78B4", "#B2DF8A", "#33A02C", "#FB9A99","#E31A1C")

names(color1)=c("Adipocytokines and hormones", "Amino acids/choline", "Anthropometrics", "Glucose", "Inflammatory markers/liver enzymes", "Lipids/fatty acids", 
                "Vitamins")

ind_comb_mi_full_clean_col <- ind_comb_mi_full_clean %>% 
  left_join(df_col, by="Family") %>%
  filter(ses=="acc_mi", ses_level=="L4-L1") %>% 
  mutate_at(vars(Exposure_name), ~ factor(.,
                                          levels=c("Kynurenine ","Midarm circumference at pw26","Avg antenatal weight 1st trimester ","Neopterin ",
                                                   "Biceps skinfold at pw26","Last antenatal weight","Weight at pw26 ","Subscapular skinfold at pw26",
                                                   "Avg antenatal weight 2nd trimester","Triceps skinfold at pw26","Fasting glucose","EPA ","IGF-II",
                                                   "DPA ","Folate","N1-methylnicotinamide  ","Height at pw26"))) 

finalcolor <- ind_comb_mi_full_clean_col$color1[order(ind_comb_mi_full_clean_col$Exposure_name)]

p <- ggplot(data=ind_comb_mi_full_clean, aes(x=coef, y=reorder(Exposure_name, coef), shape=ses_level, linetype=ses_level, alpha=significance, col=significance)) +
  geom_point(aes(x=coef, y=reorder(Exposure_name, coef)), position=position_dodge(0.7), size=1.2) +
  geom_errorbarh(aes(xmin=lower, xmax=upper), height=.1, position=position_dodge(0.7)) +
  geom_vline(xintercept=0, color="black", linetype="dashed") +
  geom_text(data=mutate_if(filter(ind_comb_mi_full_clean, ses_level=="NA"), is.numeric, round,2), 
            aes(label=glue("{coef} [{upper},{lower}]"), x=3), hjust="inward", size=2.5) +
  geom_text(data=mutate_if(filter(ind_comb_mi_full_clean, ses_level=="L2-L1"), is.numeric, round,2), 
            aes(label=glue("{coef} [{lower},{upper}]"), x=3), hjust="inward", size=2.5, nudge_y=-0.24) +
  geom_text(data=mutate_if(filter(ind_comb_mi_full_clean, ses_level=="L3-L1"), is.numeric, round,2), 
            aes(label=glue("{coef} [{lower},{upper}]"), x=3), hjust="inward", size=2.5) +
  geom_text(data=mutate_if(filter(ind_comb_mi_full_clean, ses_level=="L4-L1"), is.numeric, round,2), 
            aes(label=glue("{coef} [{lower},{upper}]"), x=3), hjust="inward", size=2.5, nudge_y=0.24) +
  facet_wrap(~ses, labeller=labeller(ses=
                                       c("acc_mi"="Accommodation",
                                         "hhincome_mi"="Household income",
                                         "medu_mi"="Maternal education", 
                                         "fedu_mi"="Paternal education", 
                                         "mc1"="IHSI")),
             ncol=5) +
  theme(
    legend.title = element_blank(),
    panel.border = element_blank(),
    panel.grid = element_blank(),
    axis.line = element_line(color="black"),
    panel.background = element_rect(fill="white")
  ) +
  scale_shape_discrete(breaks=c("L4-L1", "L3-L1", "L2-L1")) +
  scale_linetype_discrete(breaks=c("L4-L1", "L3-L1", "L2-L1")) + 
  scale_color_manual(values=cols, guide=F) +
  scale_alpha_discrete(range=c(0.5,1), guide=F) +
  #scale_color_manual(limits = names(color1), values = color1) +
  labs(color=NULL) +
  ylab(NULL) +
  xlab("SD difference")
  
p

?scale_fill_manual

p + theme(axis.text.y = element_text(color=finalcolor)) 

#ggsave("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/ewas_cc_graph/comb_ewas_mi_full_ind1.png")
ggsave("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/write up/EI/figure_2.png")


#neighborhood
ggplot(data=area_comb_mi_full_clean, aes(x=coef, y=reorder(Exposure_name, coef), shape=ses_level, linetype=ses_level, col=significance, alpha=significance)) +
  geom_point(aes(x=coef, y=reorder(Exposure_name, coef)), position=position_dodge(0.7), size=1.2) +
  geom_errorbarh(aes(xmin=lower, xmax=upper), height=.1, position=position_dodge(0.7)) +
  geom_vline(xintercept=0, color="black", linetype="dashed") +
  geom_text(data=mutate_if(filter(area_comb_mi_full_clean, ses_level=="NA"), is.numeric, round,2), 
            aes(label=glue("{coef} [{upper},{lower}]"), x=1.7), hjust="inward", size=3) +
  geom_text(data=mutate_if(filter(area_comb_mi_full_clean, ses_level=="L2-L1"), is.numeric, round,2), 
            aes(label=glue("{coef} [{lower},{upper}]"), x=1.7), hjust="inward", size=3, nudge_y=-0.24) +
  geom_text(data=mutate_if(filter(area_comb_mi_full_clean, ses_level=="L3-L1"), is.numeric, round,2), 
            aes(label=glue("{coef} [{lower},{upper}]"), x=1.7), hjust="inward", size=3) +
  geom_text(data=mutate_if(filter(area_comb_mi_full_clean, ses_level=="L4-L1"), is.numeric, round,2), 
            aes(label=glue("{coef} [{lower},{upper}]"), x=1.7), hjust="inward", size=3, nudge_y=0.24) +
  facet_wrap(~ses, labeller=labeller(ses=
                                       c("sai_mi"="SAI",
                                         "sedi_mi"="SEDI",
                                         "mc2"="MC2")),
             ncol=3) +
  theme(
    legend.title = element_blank(),
    panel.border = element_blank(),
    panel.grid = element_blank(),
    axis.line = element_line(color="black"),
    panel.background = element_rect(fill="white")
  ) +
  scale_shape_discrete(breaks=c("L4-L1", "L3-L1", "L2-L1")) +
  scale_linetype_discrete(breaks=c("L4-L1", "L3-L1", "L2-L1")) + 
  scale_color_manual(values=cols, guide=F) +
  scale_alpha_discrete(range=c(0.5,1), guide=F) +
  labs(color=NULL) +
  ylab(NULL) +
  xlab("Beta coefficient")

ggsave("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/ewas_cc_graph/comb_ewas_mi_full_area.png")

ggplot(data=area_comb_mi_full_clean1, aes(x=coef, y=reorder(Exposure_name, coef), shape=ses_level, linetype=ses_level, col=significance, alpha=significance)) +
  geom_point(aes(x=coef, y=reorder(Exposure_name, coef)), position=position_dodge(0.7), size=1.2) +
  geom_errorbarh(aes(xmin=lower, xmax=upper), height=.1, position=position_dodge(0.7)) +
  geom_vline(xintercept=0, color="black", linetype="dashed") +
  geom_text(data=mutate_if(filter(area_comb_mi_full_clean1, ses_level=="L2-L1"), is.numeric, round,2), 
            aes(label=glue("{coef} [{lower},{upper}]"), x=1.7), hjust="inward", size=3, nudge_y=-0.24) +
  geom_text(data=mutate_if(filter(area_comb_mi_full_clean1, ses_level=="L3-L1"), is.numeric, round,2), 
            aes(label=glue("{coef} [{lower},{upper}]"), x=1.7), hjust="inward", size=3) +
  geom_text(data=mutate_if(filter(area_comb_mi_full_clean1, ses_level=="L4-L1"), is.numeric, round,2), 
            aes(label=glue("{coef} [{lower},{upper}]"), x=1.7), hjust="inward", size=3, nudge_y=0.24) +
  facet_wrap(~ses, labeller=labeller(ses=
                                       c("sai_mi"="SAI",
                                         "sedi_mi"="SEDI")),
             ncol=2) +
  theme(
    legend.title = element_blank(),
    panel.border = element_blank(),
    panel.grid = element_blank(),
    axis.line = element_line(color="black"),
    panel.background = element_rect(fill="white")
  ) +
  scale_shape_discrete(breaks=c("L4-L1", "L3-L1", "L2-L1")) +
  scale_linetype_discrete(breaks=c("L4-L1", "L3-L1", "L2-L1")) + 
  scale_color_manual(values=cols, guide=F) +
  scale_alpha_discrete(range=c(0.5,1), guide=F) +
  labs(color=NULL) +
  ylab(NULL) +
  xlab("SD difference")

ggsave("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/ewas_cc_graph/comb_ewas_mi_full_area1.png")

###############################################################################

#Ethnicity

#mi (summ_eth_exwas_mi_full.R)
ses_mi_eth_clean 

#filter(Exposure_name=="PFUnDA"|Exposure_name=="PFOS"|Exposure_name=="PFDA"|Exposure_name=="PFNA"|Exposure_name=="Total Homocysteine ")

#mc (ewas_mi_full_eth.R)
comb_mc_eth <- mc_full_eth_mi_clean %>% 
  mutate(ses_level="NA") %>%
  mutate_at(vars(coef:lower), .funs = funs(. * (-1))) 

comb_mc_eth_ori <- mc_full_eth_mi_clean %>% 
  mutate(ses_level="NA")

#filter(Exposure_name=="PFUnDA"| Exposure_name=="PFOS"| Exposure_name=="PFDA")

comb_mi_full_eth <- rbind(ses_mi_eth_clean , comb_mc_eth)

comb_mi_full_eth$ses_level <- str_replace_all(comb_mi_full_eth$ses_level, c("L4"="L4-L1", "L3"="L3-L1","L2"="L2-L1"))

comb_mi_full_eth$ses <- factor(comb_mi_full_eth$ses, 
                               levels=c("acc_mi", "hhincome_mi", "medu_mi","fedu_mi", "sai_mi", "sedi_mi", "mc1", "mc2"))

comb_mi_full_eth_ori <- rbind(ses_mi_eth_clean , comb_mc_eth_ori) %>%
  select(-(significance))

comb_mi_full_eth_ori$ses <- factor(comb_mi_full_eth_ori$ses, 
                               levels=c("acc_mi", "hhincome_mi", "medu_mi","fedu_mi", "sai_mi", "sedi_mi", "mc1", "mc2"))

write_xlsx(comb_mi_full_eth_ori, "C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/write up/raw_coef_eth.xlsx")

#dataset for mi and mc
comb_mi_full_eth_clean <- comb_mi_full_eth %>%
  filter(ses=="mc1"| ses=="medu_mi"| ses=="fedu_mi") %>% 
  filter(Exposure_name=="PFUnDA"|Exposure_name=="PFOS"|Exposure_name=="PFDA"|Exposure_name=="PFNA"|Exposure_name=="Total Homocysteine ")

comb_mi_full_eth_clean1 <- comb_mi_full_eth %>%
  filter(ses=="mc1"| ses=="medu_mi"| ses=="fedu_mi") %>% 
  filter(significance==1)

ggplot(data=comb_mi_full_eth_clean, aes(x=coef, y=reorder(Exposure_name, coef), shape=m_ethnicity, linetype=m_ethnicity,col=significance, alpha=significance)) +
  geom_point(aes(x=coef, y=Exposure_name), position=position_dodge(0.7), size=1.5) +
  geom_errorbarh(aes(xmin=lower, xmax=upper), height=.1, position=position_dodge(0.7)) +
  geom_vline(xintercept=0, color="black", linetype="dashed") +
  geom_text(data=mutate_if(filter(comb_mi_full_eth_clean, m_ethnicity=="Chinese"), is.numeric, round,2), 
            aes(label=glue("{coef} [{lower},{upper}]"), x=4), hjust="inward", size=1.8, nudge_y=-0.24) +
  geom_text(data=mutate_if(filter(comb_mi_full_eth_clean, m_ethnicity=="Indian"), is.numeric, round,2), 
            aes(label=glue("{coef} [{lower},{upper}]"), x=4), hjust="inward", size=1.8) +
  geom_text(data=mutate_if(filter(comb_mi_full_eth_clean, m_ethnicity=="Malay"), is.numeric, round,2), 
            aes(label=glue("{coef} [{lower},{upper}]"), x=4), hjust="inward", size=1.8, nudge_y=0.24) +
  facet_grid(ses~ses_level, labeller=labeller(ses=
                                                c("acc_mi"="Accommodation",
                                                  "hhincome_mi"="Household income",
                                                  "medu_mi"="Maternal education", 
                                                  "fedu_mi"="Paternal education", 
                                                  "sai_mi"="SAI", 
                                                  "sedi_mi"="SEDI",
                                                  "mc1"="MC1"))) +
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

ggplot(data=comb_mi_full_eth_clean, aes(x=coef, y=reorder(Exposure_name, coef), shape=ses_level, linetype=ses_level, col=significance, alpha=significance)) +
  geom_point(aes(x=coef, y=Exposure_name), position=position_dodge(0.7), size=1.5) +
  geom_errorbarh(aes(xmin=lower, xmax=upper), height=.1, position=position_dodge(0.7)) +
  geom_vline(xintercept=0, color="black", linetype="dashed") +
  geom_text(data=mutate_if(filter(comb_mi_full_eth_clean, ses_level=="NA"), is.numeric, round,2), 
            aes(label=glue("{coef} [{upper},{lower}]"), x=5), hjust="inward", size=2) +
  geom_text(data=mutate_if(filter(comb_mi_full_eth_clean, ses_level=="L2-L1"), is.numeric, round,2), 
            aes(label=glue("{coef} [{lower},{upper}]"), x=5), hjust="inward", size=2, nudge_y=-0.24) +
  geom_text(data=mutate_if(filter(comb_mi_full_eth_clean, ses_level=="L3-L1"), is.numeric, round,2), 
            aes(label=glue("{coef} [{lower},{upper}]"), x=5), hjust="inward", size=2) +
  geom_text(data=mutate_if(filter(comb_mi_full_eth_clean, ses_level=="L4-L1"), is.numeric, round,2), 
            aes(label=glue("{coef} [{lower},{upper}]"), x=5), hjust="inward", size=2, nudge_y=0.24) +
  #geom_text(data=mutate_if(comb_mi_full_eth_clean, is.numeric, signif, 2), 
            #aes(label=glue("p={p_value}"), x=8), hjust="inward", size=2) +
  facet_grid(m_ethnicity~ses, labeller=labeller(ses=
                                                  c("acc_mi"="Accommodation",
                                                    "hhincome_mi"="Household income",
                                                    "medu_mi"="Maternal education", 
                                                    "fedu_mi"="Paternal education", 
                                                    "sai_mi"="SAI", 
                                                    "sedi_mi"="SEDI",
                                                    "mc1"="IHSS"))) +
  theme(
    legend.title = element_blank(),
    panel.border = element_blank(),
    panel.grid = element_blank(),
    axis.line = element_line(color="black"),
    panel.background = element_rect(fill="white")
  ) +
  scale_shape_discrete(breaks=c("L4-L1", "L3-L1", "L2-L1", "NA")) + 
  scale_linetype_discrete(breaks=c("L4-L1", "L3-L1", "L2-L1", "NA")) +
  scale_color_manual(values=cols, guide=F) +
  scale_alpha_discrete(range=c(0.5,1), guide=F) +
  labs(color=NULL) +
  ylab(NULL) +
  xlab("Beta coefficient")

ggsave("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/interaction_graph/comb_ewas_mi_full_eth1.png")

ggplot(data=comb_mi_full_eth_clean1, aes(x=coef, y=reorder(Exposure_name, coef), shape=ses_level, linetype=ses_level)) +
  geom_point(aes(x=coef, y=Exposure_name), position=position_dodge(0.7), size=1.5) +
  geom_errorbarh(aes(xmin=lower, xmax=upper), height=.1, position=position_dodge(0.7)) +
  geom_vline(xintercept=0, color="black", linetype="dashed") +
  geom_text(data=mutate_if(filter(comb_mi_full_eth_clean1, ses_level=="NA"), is.numeric, round,2), 
            aes(label=glue("{coef} [{upper},{lower}]"), x=3), hjust="inward", size=2.5) +
  geom_text(data=mutate_if(filter(comb_mi_full_eth_clean1, ses_level=="L2-L1"), is.numeric, round,2), 
            aes(label=glue("{coef} [{lower},{upper}]"), x=3), hjust="inward", size=2.5, nudge_y=-0.24) +
  geom_text(data=mutate_if(filter(comb_mi_full_eth_clean1, ses_level=="L3-L1"), is.numeric, round,2), 
            aes(label=glue("{coef} [{lower},{upper}]"), x=3), hjust="inward", size=2.5) +
  geom_text(data=mutate_if(filter(comb_mi_full_eth_clean1, ses_level=="L4-L1"), is.numeric, round,2), 
            aes(label=glue("{coef} [{lower},{upper}]"), x=3), hjust="inward", size=2.5, nudge_y=0.24) +
  #geom_text(data=mutate_if(comb_mi_full_eth_clean1, is.numeric, signif, 2), 
   #         aes(label=glue("p={p_value}"), x=5), hjust="inward", size=2) +
  facet_grid(m_ethnicity~ses, labeller=labeller(ses=
                                                  c("acc_mi"="Accommodation",
                                                    "hhincome_mi"="Household income",
                                                    "medu_mi"="Maternal education", 
                                                    "fedu_mi"="Paternal education", 
                                                    "sai_mi"="SAI", 
                                                    "sedi_mi"="SEDI",
                                                    "mc1"="IHSI"))) +
  theme(
    legend.title = element_blank(),
    panel.border = element_blank(),
    panel.grid = element_blank(),
    axis.line = element_line(color="black"),
    panel.background = element_rect(fill="white")
  ) +
  scale_shape_discrete(breaks=c("L4-L1", "L3-L1", "L2-L1")) + 
  scale_linetype_discrete(breaks=c("L4-L1", "L3-L1", "L2-L1")) +
  labs(color=NULL) +
  ylab(NULL) +
  xlab("SD difference")

ggsave("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/interaction_graph/comb_ewas_mi_full_eth2.png")

#############
#NOT APPLICABLE 
comb_exwas_eth_clean2 <- comb_exwas_eth_clean1 %>% 
  filter(ses=="acc"|ses=="acc_mi"|ses=="sai"|ses=="sai_mi"|ses=="sedi"|ses=="sedi_mi")

comb_exwas_eth_clean3 <- comb_exwas_eth_clean1 %>% 
  filter(ses=="medu"|ses=="medu_mi"|ses=="fedu"|ses=="fedu_mi"|ses=="hhincome"|ses=="hhincome_mi")

ggplot(data=comb_exwas_eth_clean3, aes(x=coef, y=reorder(Exposure_name, coef), shape=ses_level, linetype=ses_level,col=significance, alpha=significance)) +
  geom_point(aes(x=coef, y=Exposure_name), position=position_dodge(0.7), size=1.5) +
  geom_errorbarh(aes(xmin=lower, xmax=upper), height=.1, position=position_dodge(0.7)) +
  geom_vline(xintercept=0, color="black", linetype="dashed") +
  geom_text(data=mutate_if(filter(comb_exwas_eth_clean3, ses_level=="L2"), is.numeric, round,2), 
            aes(label=glue("{coef} [{lower},{upper}]"), x=7), hjust="inward", size=2, nudge_y=-0.24) +
  geom_text(data=mutate_if(filter(comb_exwas_eth_clean3, ses_level=="L3"), is.numeric, round,2), 
            aes(label=glue("{coef} [{lower},{upper}]"), x=7), hjust="inward", size=2) +
  geom_text(data=mutate_if(filter(comb_exwas_eth_clean3, ses_level=="L4"), is.numeric, round,2), 
            aes(label=glue("{coef} [{lower},{upper}]"), x=7), hjust="inward", size=2, nudge_y=0.24) +
  facet_grid(m_ethnicity~ses) +
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

ggsave("e:/sumkk/ses-exposome/results/interaction_graph/comb_exwas_eth_ml1.png")

ggplot(data=comb_exwas_eth_clean2, aes(x=coef, y=reorder(Exposure_name, coef), shape=ses_level, linetype=ses_level,col=significance, alpha=significance)) +
  geom_point(aes(x=coef, y=Exposure_name), position=position_dodge(0.7), size=1.5) +
  geom_errorbarh(aes(xmin=lower, xmax=upper), height=.1, position=position_dodge(0.7)) +
  geom_vline(xintercept=0, color="black", linetype="dashed") +
  geom_text(data=mutate_if(filter(comb_exwas_eth_clean2, ses_level=="L2"), is.numeric, round,2), 
            aes(label=glue("{coef} [{lower},{upper}]"), x=7), hjust="inward", size=2, nudge_y=-0.24) +
  geom_text(data=mutate_if(filter(comb_exwas_eth_clean2, ses_level=="L3"), is.numeric, round,2), 
            aes(label=glue("{coef} [{lower},{upper}]"), x=7), hjust="inward", size=2) +
  geom_text(data=mutate_if(filter(comb_exwas_eth_clean2, ses_level=="L4"), is.numeric, round,2), 
            aes(label=glue("{coef} [{lower},{upper}]"), x=7), hjust="inward", size=2, nudge_y=0.24) +
  facet_grid(m_ethnicity~ses) +
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

ggsave("e:/sumkk/ses-exposome/results/interaction_graph/comb_exwas_eth_ml2.png")

##################################################################################################3

#COB

#mi (summ_cob_exwas_lmi_full.R)
ses_mi_cob_sig_clean

# filter(Exposure_name=="PFUnDA"|Exposure_name=="Folate"|Exposure_name=="HDL-cholesterol "|Exposure_name=="Copper"|Exposure_name=="3-Methylhistidine ")

#mc_full_cont_cob (ewas_mi_full_mca_cob.R)
comb_mc_cob <- mc_full_cob_mi_clean %>% 
  mutate(ses_level="NA") %>%
  mutate_at(vars(coef:lower), .funs = funs(. * (-1))) 

comb_mc_cob_ori <- mc_full_cob_mi_clean %>% 
  mutate(ses_level="NA")

#filter(Exposure_name=="Folate"| Exposure_name=="Copper"|Exposure_name=="Vitamin D3")

comb_mi_full_cob <- rbind(ses_mi_cob_sig_clean, comb_mc_cob)

comb_mi_full_cob$ses_level <- str_replace_all(comb_mi_full_cob$ses_level, c("L4"="L4-L1", "L3"="L3-L1","L2"="L2-L1"))

comb_mi_full_cob$ses <- factor(comb_mi_full_cob$ses, levels=c("acc_mi", "hhincome_mi", "medu_mi", "fedu_mi", "sai_mi", "sedi_mi", "mc1", "mc2"))

comb_mi_full_cob_ori <- rbind(ses_mi_cob_sig_clean, comb_mc_cob_ori)%>%
  select(-(significance))

comb_mi_full_cob_ori$ses <- factor(comb_mi_full_cob_ori$ses, levels=c("acc_mi", "hhincome_mi", "medu_mi", "fedu_mi", "sai_mi", "sedi_mi", "mc1", "mc2"))

write_xlsx(comb_mi_full_cob_ori, "C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/write up/raw_coef_cob.xlsx")

comb_mi_full_cob_clean <- comb_mi_full_cob %>%
  filter(ses=="acc_mi"| ses=="medu_mi"| ses=="fedu_mi"| ses=="mc1") %>% 
  filter(Exposure_name=="Folate"| Exposure_name=="Copper" |Exposure_name=="PFUnDA"|Exposure_name=="Vitamin D3"|Exposure_name=="HDL-cholesterol "
         |Exposure_name=="3-Methylhistidine ")

comb_mi_full_cob_clean1 <- comb_mi_full_cob %>%
  filter(ses=="acc_mi"| ses=="medu_mi"| ses=="fedu_mi"| ses=="mc1") %>% 
  filter(significance==1)

ggplot(data=comb_mi_full_cob_clean, aes(x=coef, y=reorder(Exposure_name, coef), shape=ses_level, linetype=ses_level, col=significance, alpha=significance)) +
  geom_point(aes(x=coef, y=Exposure_name), position=position_dodge(0.7), size=1.5) +
  geom_errorbarh(aes(xmin=lower, xmax=upper), height=.1, position=position_dodge(0.7)) +
  geom_vline(xintercept=0, color="black", linetype="dashed") +
  geom_text(data=mutate_if(filter(comb_mi_full_cob_clean, ses_level=="NA"), is.numeric, round,2), 
            aes(label=glue("{coef} [{upper},{lower}]"), x=4), hjust="inward", size=2.5) +
  geom_text(data=mutate_if(filter(comb_mi_full_cob_clean, ses_level=="L2"), is.numeric, round,2), 
            aes(label=glue("{coef} [{lower},{upper}]"), x=4), hjust="inward", size=2.5, nudge_y=-0.24) +
  geom_text(data=mutate_if(filter(comb_mi_full_cob_clean, ses_level=="L3"), is.numeric, round,2), 
            aes(label=glue("{coef} [{lower},{upper}]"), x=4), hjust="inward", size=2.5) +
  geom_text(data=mutate_if(filter(comb_mi_full_cob_clean, ses_level=="L4"), is.numeric, round,2), 
            aes(label=glue("{coef} [{lower},{upper}]"), x=4), hjust="inward", size=2.5, nudge_y=0.24) +
  #geom_text(data=mutate_if(comb_mi_full_cob_clean1, is.numeric, signif, 2), 
  #          aes(label=glue("p={p_value}"), x=6), hjust="inward", size=2.5) +
  facet_grid(m_cob~ses, labeller=labeller(ses=
                                            c("acc_mi"="Accommodation",
                                              "hhincome_mi"="Household income",
                                              "medu_mi"="Maternal education", 
                                              "fedu_mi"="Paternal education", 
                                              "sai_mi"="SAI", 
                                              "sedi_mi"="SEDI",
                                              "mc1"="MC1"))) +
  theme(
    legend.title = element_blank(),
    panel.border = element_blank(),
    panel.grid = element_blank(),
    axis.line = element_line(color="black"),
    panel.background = element_rect(fill="white")
  ) +
  scale_shape_discrete(breaks=c("L4", "L3", "L2", "NA")) + 
  scale_linetype_discrete(breaks=c("L4", "L3", "L2", "NA")) +
  scale_color_manual(values=cols, guide=F) +
  scale_alpha_discrete(range=c(0.5,1), guide=F) +
  labs(color=NULL) +
  ylab(NULL) +
  xlab("Beta coefficient")

ggsave("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/interaction_graph/comb_ewas_mi_full_cob1.png")

ggplot(data=comb_mi_full_cob_clean1, aes(x=coef, y=reorder(Exposure_name, coef), shape=ses_level, linetype=ses_level)) +
  geom_point(aes(x=coef, y=Exposure_name), position=position_dodge(0.7), size=1.5) +
  geom_errorbarh(aes(xmin=lower, xmax=upper), height=.1, position=position_dodge(0.7)) +
  geom_vline(xintercept=0, color="black", linetype="dashed") +
  geom_text(data=mutate_if(filter(comb_mi_full_cob_clean1, ses_level=="NA"), is.numeric, round,2), 
            aes(label=glue("{coef} [{upper},{lower}]"), x=4), hjust="inward", size=2.5) +
  geom_text(data=mutate_if(filter(comb_mi_full_cob_clean1, ses_level=="L2-L1"), is.numeric, round,2), 
            aes(label=glue("{coef} [{lower},{upper}]"), x=4), hjust="inward", size=2.5, nudge_y=-0.24) +
  geom_text(data=mutate_if(filter(comb_mi_full_cob_clean1, ses_level=="L3-L1"), is.numeric, round,2), 
            aes(label=glue("{coef} [{lower},{upper}]"), x=4), hjust="inward", size=2.5) +
  geom_text(data=mutate_if(filter(comb_mi_full_cob_clean1, ses_level=="L4-L1"), is.numeric, round,2), 
            aes(label=glue("{coef} [{lower},{upper}]"), x=4), hjust="inward", size=2.5, nudge_y=0.24) +
  #geom_text(data=mutate_if(comb_mi_full_cob_clean1, is.numeric, signif, 2), 
   #         aes(label=glue("p={p_value}"), x=6.5), hjust="inward", size=2.5) +
  facet_grid(m_cob~ses, labeller=labeller(ses=
                                            c("acc_mi"="Accommodation",
                                              "hhincome_mi"="Household income",
                                              "medu_mi"="Maternal education", 
                                              "fedu_mi"="Paternal education", 
                                              "sai_mi"="SAI", 
                                              "sedi_mi"="SEDI",
                                              "mc1"="IHSI"))) +
  theme(
    legend.title = element_blank(),
    panel.border = element_blank(),
    panel.grid = element_blank(),
    axis.line = element_line(color="black"),
    panel.background = element_rect(fill="white")
  ) +
  scale_shape_discrete(breaks=c("L4-L1", "L3-L1", "L2-L1")) + 
  scale_linetype_discrete(breaks=c("L4-L1", "L3-L1", "L2-L1")) +
  labs(color=NULL) +
  ylab(NULL) +
  xlab("SD difference")

ggsave("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/interaction_graph/comb_ewas_mi_full_cob2.png")

################################
#looking at tryptophan 

comb_mi_full_clean_t <- comb_mi_full %>%
  filter(ses!="mc2", ses!="sai_mi", ses!="sedi_mi") %>% 
  filter(Exposure_name=="IGF-II"|Exposure_name=="DPA "|Exposure_name=="Folate"
         |Exposure_name=="EPA "|Exposure_name=="Height at pw26"|Exposure_name=="PM2.5 1st trimester "
         |Exposure_name=="Triceps skinfold at pw26"|Exposure_name=="PM2.5 pregnancy "|Exposure_name=="PM2.5 3rd trimester"
         |Exposure_name=="PM2.5 2nd trimester"|Exposure_name=="Avg antenatal weight 1st trimester "|Exposure_name=="Midarm circumference at pw26"
         |Exposure_name=="Avg antenatal weight 2nd trimester"|Exposure_name=="Weight at pw26 " |Exposure_name=="Subscapular skinfold at pw26"
         |Exposure_name=="Neopterin "|Exposure_name=="Fasting glucose"|Exposure_name=="Last antenatal weight"
         |Exposure_name=="Kynurenine "| Exposure_name== "Biceps skinfold at pw26"|Exposure_name=="N1-methylnicotinamide  "
         |Exposure_name=="Total cysteine "|Exposure_name=="Tryptophan ")

ggplot(data=comb_mi_full_clean_t, aes(x=coef, y=reorder(Exposure_name, coef), shape=ses_level, linetype=ses_level, col=significance, alpha=significance)) +
  geom_point(aes(x=coef, y=reorder(Exposure_name, coef)), position=position_dodge(0.7), size=1.2) +
  geom_errorbarh(aes(xmin=lower, xmax=upper), height=.1, position=position_dodge(0.7)) +
  geom_vline(xintercept=0, color="black", linetype="dashed") +
  geom_text(data=mutate_if(filter(comb_mi_full_clean_t, ses_level=="NA"), is.numeric, round,2), 
            aes(label=glue("{coef} [{upper},{lower}]"), x=3.5), hjust="inward", size=1.8) +
  geom_text(data=mutate_if(filter(comb_mi_full_clean_t, ses_level=="L2"), is.numeric, round,2), 
            aes(label=glue("{coef} [{lower},{upper}]"), x=3.5), hjust="inward", size=1.8, nudge_y=-0.24) +
  geom_text(data=mutate_if(filter(comb_mi_full_clean_t, ses_level=="L3"), is.numeric, round,2), 
            aes(label=glue("{coef} [{lower},{upper}]"), x=3.5), hjust="inward", size=1.8) +
  geom_text(data=mutate_if(filter(comb_mi_full_clean_t, ses_level=="L4"), is.numeric, round,2), 
            aes(label=glue("{coef} [{lower},{upper}]"), x=3.5), hjust="inward", size=1.8, nudge_y=0.24) +
  facet_wrap(~ses, labeller=labeller(ses=
                                       c("acc_mi"="Accommodation",
                                         "hhincome_mi"="Household income",
                                         "medu_mi"="Maternal education", 
                                         "fedu_mi"="Paternal education", 
                                         "mc1"="MC1")),
             ncol=5) +
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

###################################

#volcano plot 
ggplot(filter(comb_mi_full_clean, ses=="hhincome_mi", ses_level=="L4-L1"), aes(x=coef, y=-log10(p_value))) +
  geom_point(aes(color=Family, shape=Family),size=1.5, position="jitter") + 
  geom_hline(yintercept=-log10(0.05/134), linetype="dashed") +
  geom_vline(xintercept=0, linetype="dashed") +
  theme_bw() +
  theme( 
    panel.border = element_rect(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank()
  ) +
  geom_text_repel(data=comb_mi_full_clean %>% filter(p_value <0.05/134, ses=="hhincome_mi",  ses_level=="L4-L1"),
                  aes(label=Exposure_name)) +
  scale_color_paletteer_d("ggthemes::calc") +
  scale_shape_manual(values=seq(0,10)) +
  labs(y="-Log P-value", x="SD Change", title="Hhincome")

#############################################
#venn diagram 

if (!require(devtools)) install.packages("devtools")
devtools::install_github("yanlinlin82/ggvenn")
install.packages("wesanderson")

library(ggvenn)
library(wesanderson)

?ggvenn

venn_ind <- ind_comb_mi_full_clean %>%
  filter(ses_level=="L4-L1"|ses_level=="NA") %>%
  select(significance, ses, Exposure_name) %>%
  mutate(
    ses=case_when(
    ses=="acc_mi" ~ "acc",
    ses=="hhincome_mi" ~ "Houshold income",
    ses=="fedu_mi" ~ "Paternal Education", 
    ses=="medu_mi" ~ "Maternal education",
    ses=="mc1" ~ "MC1"
  ),
    significance=case_when(significance==0 ~F,
                           significance==1 ~T)) %>%
  spread(ses, significance) %>%
  select(-(acc))

ggvenn(venn_ind, 
       fill_color=brewer.pal(name="Set3", n=4),
       stroke_size = 0.5, set_name_size = 3.5)  

ggsave("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/ewas_cc_graph/venn4ind.png")

ggvenn(venn_ind,
       c("Houshold income","Maternal education","Paternal Education"),
       fill_color=brewer.pal(name="Set2", n=3),
       stroke_size = 0.5, set_name_size = 3.5)  

ggsave("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/ewas_cc_graph/venn3ind.png")

###################################
#ggupset 

devtools::install_github("const-ae/ggupset")
install.packages("UpSetR")
install.packages('ComplexUpset')

library(ggplot2)
library(tidyverse, warn.conflicts = FALSE)
library(ggupset)
library(UpSetR)
library(ComplexUpset)

upset <- comb_mi_full_clean %>%
  filter(ses_level=="L4-L1"|ses_level=="NA") %>%
  select(significance, ses, Exposure_name, Family) %>%
  mutate(
    ses=case_when(
      ses=="acc_mi" ~ "Accommodation",
      ses=="hhincome_mi" ~ "Houshold income",
      ses=="fedu_mi" ~ "Paternal Education", 
      ses=="medu_mi" ~ "Maternal education",
      ses=="sai_mi" ~ "SAI",
      ses=="sedi_mi" ~ "SEDI",
      ses=="mc1" ~ "MC1",
      ses=="mc2" ~ "MC2"
    )) %>%
    filter(significance==1) %>%
    select(-significance) %>%
  group_by(Exposure_name, Family) %>%
  summarise(SEP=list(ses)) 

  #mutate(Family = sub("(.)", "\\U\\1", Family, perl=TRUE))

ggplot(upset, aes(x =SEP, fill=Family)) +
  geom_bar() +
  geom_text(stat='count', aes(label=after_stat(count)), position = position_stack(0.5)) +
  scale_x_upset()  +
  theme(
    panel.border = element_blank(),
    panel.grid = element_blank(),
    axis.line = element_line(color="black"),
    panel.background = element_rect(fill="white")
  ) +
  labs(fill="Exposure family")


#with complexupset
#simulation data
set_size = function(w, h, factor=1.5) {
  s = 1 * factor
  options(
    repr.plot.width=w * s,
    repr.plot.height=h * s,
    repr.plot.res=100 / factor,
    jupyter.plot_mimetypes='image/png',
    jupyter.plot_scale=1
  )
}

movies <- tidy_movies %>%
  distinct(title, year, length, .keep_all=TRUE) %>%
  unnest(cols = Genres) %>%
  mutate(GenreMember=1) %>%
  pivot_wider(names_from = Genres, values_from = GenreMember, values_fill = list(GenreMember = 0)) %>%
  as.data.frame()

genres = colnames(movies)[10:16]
movies[genres] = movies[genres] == 1
t(head(movies[genres], 3))

movies[movies$mpaa == '', 'mpaa'] = NA
movies = na.omit(movies)

set_size(8, 3)
upset(movies, genres, name='genre', width_ratio=0.1)

#real data
upset1 <- comb_mi_full_clean %>%
  filter(ses_level=="L4-L1"|ses_level=="NA", Exposure_name!="Total cysteine ") %>%
  select(significance, ses, Exposure_name, Family) %>%
  mutate(
    ses=case_when(
      ses=="acc_mi" ~ "Accommodation",
      ses=="hhincome_mi" ~ "Household income",
      ses=="fedu_mi" ~ "Paternal education", 
      ses=="medu_mi" ~ "Maternal education",
      ses=="sai_mi" ~ "SAI",
      ses=="sedi_mi" ~ "SEDI",
      ses=="mc1" ~ "MC1",
      ses=="mc2" ~ "MC2"
    ),
    significance=case_when(significance==0 ~F,
                           significance==1 ~T)) %>%
  spread(ses, significance) %>%
  mutate(Family = sub("(.)", "\\U\\1", Family, perl=TRUE)) %>%
  rename(Exposure_family=Family)

#overall 

SEP = colnames(upset1)[3:10]
upset1[SEP] = upset1[SEP] == 1

set_size(5, 3)
upset(
  upset1,
  SEP,
  name="SEP indicators",
  base_annotations=list(
    'Intersection size'=intersection_size(
    mapping=aes(fill=Exposure_family),
    counts=F
    ) +
      scale_fill_brewer(palette="Paired")
  ),
  width_ratio=0.3,
  encode_sets=FALSE,  # for annotate() to select the set by name disable encoding
  set_sizes=(
    upset_set_size(geom=geom_bar(
      aes(fill=Exposure_family, x=group),
      width=0.8
    ),
    position='right')
    + geom_text(aes(label=..count..), hjust=-0.3, stat='count')
    + expand_limits(y=16)
    + theme(axis.text.x=element_text(angle=90),
            legend.position = "none")
    + scale_fill_brewer(palette="Paired")
    ),
  guides="over"
  )

#only ind SEP

library(pals)

upset2 <- upset1 %>% select(c(1:2,4:5, 8)) %>% 
  slice(1:2,4:9, 11:12, 14, 19:21)

SEP1 = colnames(upset2)[3:5]
upset2[SEP1] = upset2[SEP1] == 1

set_size(8, 3)
upset(
  upset2,
  SEP1,
  name="SEP indicators",
  base_annotations=list(
    'Intersection size'=intersection_size(
      mapping=aes(fill=Exposure_name),
      counts=F
    ) +
      scale_fill_manual(values=as.vector(kelly(14)))
  ),
  width_ratio=0.3,
  height_ratio=0.2,
  encode_sets=FALSE,  # for annotate() to select the set by name disable encoding
  set_sizes=(
    upset_set_size(geom=geom_bar(
      aes(fill=Exposure_family, x=group),
      width=0.7
    ),
    position='right')
    + geom_text(aes(label=..count..), hjust=-0.3, stat='count')
    + expand_limits(y=15)
    + theme(axis.text.x=element_text(angle=90))
    + scale_fill_brewer(palette="Paired") 
    + labs(fill="Exposure_family")
  ),
  guides="over"
)


#excluding mc1 and mc2

upset3 <- upset1 %>% select(-(6:7)) %>% 
  slice(1:2, 4:9, 11:12, 14:21)

SEP2 = colnames(upset3)[3:8]
upset3[SEP2] = upset3[SEP2] == 1

set_size(8, 3)
upset(
  upset3,
  SEP2,
  name="SEP indicators",
  base_annotations=list(
    'Intersection size'=intersection_size(
      mapping=aes(fill=Exposure_family),
      counts=F
    ) +
      scale_fill_brewer(palette="Paired")
  ),
  width_ratio=0.3,
  encode_sets=FALSE,  # for annotate() to select the set by name disable encoding
  set_sizes=(
    upset_set_size(geom=geom_bar(
      aes(fill=Exposure_family, x=group),
      width=0.8
    ),
    position='right')
    + geom_text(aes(label=..count..), hjust=-0.3, stat='count')
    + expand_limits(y=16)
    + theme(axis.text.x=element_text(angle=90),
            legend.position = "none")
    + scale_fill_brewer(palette="Paired") 
  ),
  guides="over"
)

#only ind SEP + mc1

library(pals)

upset4 <- upset1 %>% select(-c("MC2", "Accommodation", "SAI", "SEDI")) %>% 
  slice(1:14, 19:21)

SEP3 = colnames(upset4)[3:6]
upset4[SEP3] = upset4[SEP3] == 1

set_size(5, 3)
upset(
  upset4,
  SEP3,
  name="SEP indicators",
  base_annotations=list(
    'Intersection size'=intersection_size(
      mapping=aes(fill=Exposure_name),
      counts=F
    ) +
      scale_fill_manual(values=as.vector(kelly(17)))
  ),
  width_ratio=0.3,
  height_ratio=0.2,
  encode_sets=FALSE,  # for annotate() to select the set by name disable encoding
  set_sizes=(
    upset_set_size(geom=geom_bar(
      aes(fill=Exposure_family, x=group),
      width=0.7
    ),
    position='right')
    + geom_text(aes(label=..count..), hjust=-0.3, stat='count')
    + expand_limits(y=18)
    + theme(axis.text.x=element_text(angle=90))
    + scale_fill_brewer(palette="Paired") 
    + labs(fill="Exposure_family")
  ),
  guides="over"
)

##################################
#prediction mc2 quad 

mc2_quad <- read_excel("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/dimensionality/mc2_quad.xlsx") %>%
  gather(2:5, key="var", value="val")

ggplot(data=mc2_quad, aes(x=MC2, y=val, shape=var,linetype=var, group=var)) +
  geom_line() +
  geom_point() +
  labs(x= "Quintiles of areal SEP index (ASI)",
       y= "Mean predicted values", 
       shape= "Exposures",
       linetype="Exposures") + 
  theme(
    panel.grid = element_blank(),
    axis.line = element_line(color="black"),
    panel.background = element_rect(fill="white")
  )
  
ggsave("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/dimensionality/mc2_quad.png")



