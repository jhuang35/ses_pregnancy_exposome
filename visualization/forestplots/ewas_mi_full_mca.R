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

biomarker_desc <- read.csv("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/data/raw_data/biomarker_desc.csv", header=TRUE) %>%
  rename("Exposure_family"="Family")

#merge p-value files

mc1_pval_mi <- read_excel("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/EWAS_FMI_PVAL.xlsx", sheet="mc1") %>% 
  mutate(ses="mc1") 

mc2_pval_mi <- read_excel("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/EWAS_FMI_PVAL.xlsx", sheet="mc2") %>% 
  mutate(ses="mc2") 

mca_pval_mi <- rbind(mc1_pval_mi, mc2_pval_mi)

#####################################

#merge mc files 

mc1_quad_mi <- read_excel("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/dimensionality/coef/mca/mc_mi/clean/mc1_quad.xlsx", sheet="Sheet2") %>%
  rename_at(vars(coef_dim1:lower_dim1), ~str_replace(.,"_dim1", "_quad")) %>%
  rename_at(vars(coef_dim1sq:lower_dim1sq), ~str_replace(.,"_dim1sq", "_quad2")) %>%
  rename(N_quad=N)

mc1_quad_mi_linear <- read_excel("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/dimensionality/coef/mca/mc_mi/clean/mc1_quad.xlsx", sheet="Sheet2") %>%
  rename_at(vars(coef_dim1:lower_dim1), ~str_remove(.,"_dim1")) %>%
  mutate(model="quadratic", coef_term="linear") %>%
  select(Exposure:lower, N, model, coef_term)

mc1_quad_comb <- read_excel("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/dimensionality/coef/mca/mc_mi/clean/mc1_quad.xlsx", sheet="Sheet2") %>%
  rename_at(vars(coef_dim1sq:lower_dim1sq), ~str_remove(.,"_dim1sq")) %>%
  mutate(model="quadratic", coef_term="squared") %>%
  select(Exposure, coef:N, model, coef_term) %>%
  rbind(mc1_quad_mi_linear) %>%
  left_join(mc1_pval_mi, by="Exposure")%>%
  select(-(p_value))

mc2_quad_mi_linear <- read_excel("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/dimensionality/coef/mca/mc_mi/clean/mc2_quad.xlsx", sheet="Sheet2") %>%
  rename_at(vars(coef_dim2:lower_dim2), ~str_remove(.,"_dim2")) %>%
  mutate(model="quadratic", coef_term="linear") %>%
  select(Exposure:lower, N, model, coef_term)

mc2_quad_comb <- read_excel("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/dimensionality/coef/mca/mc_mi/clean/mc2_quad.xlsx", sheet="Sheet2") %>%
  rename_at(vars(coef_dim2sq:lower_dim2sq), ~str_remove(.,"_dim2sq")) %>%
  mutate(model="quadratic", coef_term="squared") %>%
  select(Exposure, coef:N, model, coef_term) %>%
  rbind(mc2_quad_mi_linear) %>%
  left_join(mc2_pval_mi, by="Exposure")%>%
  select(-(p_value))

mc1_mi <- read_excel("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/dimensionality/coef/mca/mc_mi/clean/mc1.xlsx", sheet="Sheet2")  %>%
  rename_at(vars(coef_dim1:lower_dim1), ~str_remove(.,"_dim1")) %>%
  left_join(mc1_pval_mi, by="Exposure")

mc2_mi <- read_excel("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/dimensionality/coef/mca/mc_mi/clean/mc2.xlsx", sheet="Sheet2")  %>%
  rename_at(vars(coef_dim2:lower_dim2), ~str_remove(.,"_dim2")) %>%
  left_join(mc2_pval_mi, by="Exposure")

#Combine 2 dimensions 
mc_all_mi <- rbind(mc1_mi, mc2_mi) %>%
  left_join(biomarker_desc, by="Exposure") 

mc2_all_mi <- mc2_quad_mi %>%
  left_join(biomarker_desc, by="Exposure") %>%
  left_join(mc2_pval_mi, by="Exposure") %>%
  mutate(significance=factor(case_when(p_value_quad<0.05/134~1,
                                       p_value_quad>=0.05/134~0))) %>%
  filter(significance==1)

mc_quad <- mc1_quad_comb %>%
  rbind(mc2_quad_comb) %>%
  left_join(biomarker_desc, by="Exposure") %>%
  mutate(p_value="NA", ses_level="NA")

mc2_sig <-mc2_quad_comb %>%
  left_join(biomarker_desc, by="Exposure") %>%
  #mutate_at(vars(coef:lower), .funs = funs(. * (-1))) %>%
  mutate(significance=factor(case_when(p_value_quad<0.05/134~1,
                                       p_value_quad>=0.05/134~0))) %>%
  filter(significance==1)

#########################################################################################################
#PLOT

mc_all_mi_clean <- mc_all_mi %>%
  filter(Exposure_name!="Insulin_l", Exposure_name!="CRP_l", Exposure_name!="IFN-g", Exposure_name!="Creatinine_b") %>%
  mutate(significance=factor(case_when(p_value_quad<0.05/134~1,
                                       p_value<0.05/134~2,
                                       p_value>=0.05/134~3)))
#for combine purpose 
mc_all_mi_clean <- mc_all_mi %>%
  filter(Exposure_name!="Insulin_l", Exposure_name!="CRP_l", Exposure_name!="IFN-g", Exposure_name!="Creatinine_b") %>%
  mutate(significance=factor(case_when(p_value<0.05/134~1,
                                       p_value>=0.05/134~0)))

mc_all_mi_clean1 <- mc_all_mi %>%
  filter(Exposure_name!="Insulin_l", Exposure_name!="CRP_l", Exposure_name!="IFN-g", Exposure_name!="Creatinine_b") %>%
  mutate(significance=factor(case_when(p_value<0.05/134~1,
                                       p_value>=0.05/134~0))) %>%
  mutate_at(vars(coef:lower), ~(. * (-1))) 

mc_all_mi_clean_sig <- mc_all_mi_clean %>% filter(p_value<0.05/134)

mc_all_mi_quad_sig <- mc_all_mi_clean %>% filter(p_value_quad<0.05/134)

mc_all_mi_all_sig <- mc_all_mi_clean %>% 
  filter(Exposure_name=="Kynurenine "|Exposure_name=="Folate" | Exposure_name== "Biceps skinfold at pw26"
         |Exposure_name=="N1-methylnicotinamide  "|Exposure_name=="Height at pw26" |Exposure_name=="Neopterin "
         |Exposure_name=="Triceps skinfold at pw26" |Exposure_name=="Avg antenatal weight 1st tri " |Exposure_name=="Avg antenatal weight 2nd tri"
         |Exposure_name=="Midarm circumference at pw26"|Exposure_name=="Subscapular skinfold at pw26"|Exposure_name=="Weight at pw26 "
         |Exposure_name=="Last antenatal weight" |Exposure_name=="IGF-II"|Exposure_name=="DPA "
         |Exposure_name=="Total cysteine " |Exposure_name=="PM2.5 2nd tri"|Exposure_name=="PM2.5 pregnancy "|Exposure_name=="PM2.5 3rd tri" )

#forest plot
ggplot(data=mc_all_mi_clean_sig, aes(x=coef, y=reorder(Exposure_name, coef))) +
  geom_point(aes(x=coef, y=reorder(Exposure_name, coef)), size=1.2) +
  geom_errorbarh(aes(xmin=lower, xmax=upper), height=.1) +
  geom_vline(xintercept=0, color="black", linetype="dashed") +
  geom_text(data=mutate_if(mc_all_mi_clean_sig, is.numeric, round, 2), 
            aes(label=glue("{coef} [{lower},{upper}]"), x=0.7), hjust="inward", size=4) +
  geom_text(data=mutate_if(mc_all_mi_clean_sig, is.numeric, signif, 2), 
            aes(label=glue("p={p_value}"), x=0.9), hjust="inward", size=4) +
  facet_wrap(~ses, labeller=labeller(ses=
                                       c("mc1"="MC1",
                                         "mc2"="MC2")),
             ncol=2) +
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

ggsave("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/ewas_cc_graph/mc_mi_full_sig.png")

#forest plot(mc2 quad evidence)
ggplot(data=mc_all_mi_quad_sig, aes(x=coef, y=reorder(Exposure_name, coef), alpha=significance, col=significance)) +
  geom_point(aes(x=coef, y=reorder(Exposure_name, coef)), size=1.2) +
  geom_errorbarh(aes(xmin=lower, xmax=upper), height=.1) +
  geom_vline(xintercept=0, color="black", linetype="dashed") +
  geom_text(data=mutate_if(mc_all_mi_quad_sig, is.numeric, round, 2), 
            aes(label=glue("{coef} [{lower},{upper}]"), x=1), hjust="inward", size=3) +
  geom_text(data=mutate_if(mc_all_mi_quad_sig, is.numeric, signif, 2), 
            aes(label=glue("p={p_value}"), x=1.5), hjust="inward", size=3) +
  facet_wrap(~ses, labeller=labeller(ses=
                                       c("mc1"="MC1",
                                         "mc2"="MC2")),
             ncol=2) +
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

cols <- c("3" = "grey", "2" = "red", "1"="blue")

options( scipen = 0 )

#forest plot (just mc2)
ggplot(data=mc2_sig, aes(x=coef, y=reorder(Exposure_name, coef))) +
  geom_point(aes(x=coef, y=reorder(Exposure_name, coef)), size=1.2) +
  geom_errorbarh(aes(xmin=lower, xmax=upper), height=.1) +
  geom_vline(xintercept=0, color="black", linetype="dashed") +
  geom_text(data=mutate_if(mc2_sig, is.numeric, round, 2), 
            aes(label=glue("{coef} [{lower},{upper}]"), x=1), hjust="inward", size=3) +
  geom_text(data=mutate_if(filter(mc2_sig, model=="quadratic"), is.numeric, signif, 2), 
            aes(label=glue("p={p_value_quad}"), x=1.5), hjust="inward", size=3) +
  facet_wrap(~coef_term, labeller=labeller(coef_term=
                                       c("linear"="Linear term",
                                         "squared"="Squared term")),
             ncol=2) +
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

ggsave("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/ewas_cc_graph/mc2_mi_full_quad.png")

#forest plot(all mcs)
ggplot(data=mc_all_mi_all_sig, aes(x=coef, y=reorder(Exposure_name, coef), col=significance)) +
  geom_point(aes(x=coef, y=reorder(Exposure_name, coef)), size=1.2) +
  geom_errorbarh(aes(xmin=lower, xmax=upper), height=.1) +
  geom_vline(xintercept=0, color="black", linetype="dashed") +
  geom_text(data=mutate_if(mc_all_mi_all_sig, is.numeric, round, 2), 
            aes(label=glue("{coef} [{lower},{upper}]"), x=1), hjust="inward", size=3) +
  geom_text(data=mutate_if(mc_all_mi_all_sig, is.numeric, signif, 2), 
            aes(label=glue("p={p_value}"), x=1.5), hjust="inward", size=3) +
  facet_wrap(~ses, labeller=labeller(ses=
                                       c("mc1"="MC1",
                                         "mc2"="MC2")),
             ncol=2) +
  theme(
    legend.title = element_blank(),
    panel.border = element_blank(),
    panel.grid = element_blank(),
    axis.line = element_line(color="black"),
    panel.background = element_rect(fill="white")
  ) +
  scale_color_manual(values=cols, guide=F) +
  labs(color=NULL) +
  ylab(NULL) +
  xlab("Beta coefficient")


ggsave("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/ewas_cc_graph/mc_mi_full_sig.png")

#volcano plot 
ggplot(filter(mc_all_mi_clean1, ses=="mc1"), aes(x=coef, y=-log10(p_value))) +
  geom_point(aes(color=Exposure_family, shape=Exposure_family),size=1.5, position="jitter") + 
  geom_hline(yintercept=-log10(0.05/134), linetype="dashed") +
  geom_vline(xintercept=0, linetype="dashed") +
  theme_bw() +
  theme( 
    panel.border = element_rect(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank()
  ) +
  geom_text_repel(data=mc_all_mi_clean1 %>% filter(p_value <0.05/134, ses=="mc1"),
                  aes(label=Exposure_name)) +
  scale_color_paletteer_d("ggthemes::calc") +
  scale_shape_manual(values=seq(0,10)) +
  labs(y="-Log P-value", x="SD Change", title="MC1")

ggsave("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/ewas_cc_graph/mc1_mi_full_vol1.png")

ggplot(filter(mc_all_mi_clean1, ses=="mc2"),  aes(x=coef, y=-log10(p_value))) +
  geom_point(aes(color=Family, shape=Family),size=1.5, position="jitter") + 
  geom_hline(yintercept=-log10(0.05/134), linetype="dashed") +
  geom_vline(xintercept=0, linetype="dashed") +
  theme_bw() +
  theme( 
    panel.border = element_rect(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank()
  ) +
  geom_text_repel(data=mc_all_mi_clean1 %>% filter(p_value <0.05/134, ses=="mc2"),
                  aes(label=Exposure_name)) +
  scale_color_paletteer_d("ggthemes::calc") +
  scale_shape_manual(values=seq(0,10)) +
  labs(y="-Log P-value", x="SD Change", title="MC2")

ggsave("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/ewas_cc_graph/mc2_mi_full_vol1.png")

#################################################################

