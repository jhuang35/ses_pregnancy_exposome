library(FactoMineR)
library(tidyverse)
library(ggplot2)
library(missMDA)
library(VIM)
library(naniar)
library(sna)
library(ggrepel)
library(RColorBrewer)
library(writexl)

ses_exposome <- read.csv("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/data/raw_data/obj_clean_transformed_standardized.csv")

ses_demo_mca <- ses_exposome %>% 
  select(subjectid, accommodation_0_1, household_income_0_1, f_education_corrected_0_1, m_highest_education_0_1, sai_quart, sedi_quart, 
         m_place_of_birth_0_2, region, parity_1, m_ethnicity_0, m_age_recruitment) %>%
  column_to_rownames(var="subjectid") %>%
  slice(-(c(40,120,547)))

ses_demo_mca$accommodation_0_1=as.character(ses_demo_mca$accommodation_0_1)
ses_demo_mca$household_income_0_1=as.character(ses_demo_mca$household_income_0_1)
ses_demo_mca$f_education_corrected_0_1=as.character(ses_demo_mca$f_education_corrected_0_1)
ses_demo_mca$m_highest_education_0_1=as.character(ses_demo_mca$m_highest_education_0_1)
ses_demo_mca$sai_quart=as.character(ses_demo_mca$sai_quart)
ses_demo_mca$sedi_quart=as.character(ses_demo_mca$sedi_quart)
ses_demo_mca$m_place_of_birth_0_2=as.character(ses_demo_mca$m_place_of_birth_0_2)
ses_demo_mca$region=as.character(ses_demo_mca$region)
ses_demo_mca$parity_1=as.character(ses_demo_mca$parity_1)
ses_demo_mca$m_ethnicity_0=as.character(ses_demo_mca$m_ethnicity_0)

ses_demo_mca <- ses_demo_mca %>%
  replace_with_na(replace=list(accommodation_0_1=c("others",""),household_income_0_1="",m_highest_education_0_1="", f_education_corrected_0_1="",
                               sai_quart="",sedi_quart="", m_place_of_birth_0_2="", region="", parity_1="",m_ethnicity_0=c("others","")))

?as.factor

ses_demo_mca$accommodation_0_1=as.factor(ses_demo_mca$accommodation_0_1)
ses_demo_mca$household_income_0_1=factor(ses_demo_mca$household_income_0_1,levels=c( "<2000","2000-3999","4000-5999",">6000"))
ses_demo_mca$f_education_corrected_0_1=factor(ses_demo_mca$f_education_corrected_0_1, levels=c("None/primary","Secondary/ITE","A-level/poly/diploma","University/Postgrad"))
ses_demo_mca$m_highest_education_0_1=factor(ses_demo_mca$m_highest_education_0_1, levels=c("None/primary","Secondary/ITE","A-level/poly/diploma","University/Postgrad"))
ses_demo_mca$sai_quart=factor(ses_demo_mca$sai_quart, levels=c("=<93.5","93.6-95","95.1-97.2",">97.2"))
ses_demo_mca$sedi_quart=factor(ses_demo_mca$sedi_quart, levels=c("=<100.2","100.3-101.6","101.7-105.6",">105.6"))
ses_demo_mca$m_place_of_birth_0_2=as.factor(ses_demo_mca$m_place_of_birth_0_2)
ses_demo_mca$region=as.factor(ses_demo_mca$region)
ses_demo_mca$parity_1=as.factor(ses_demo_mca$parity_1)
ses_demo_mca$m_ethnicity_0=as.factor(ses_demo_mca$m_ethnicity_0)

levels(ses_demo_mca$accommodation_0_1)

levels(ses_demo_mca$household_income_0_1)

levels(ses_demo_mca$f_education_corrected_0_1)

levels(ses_demo_mca$m_highest_education_0_1)

levels(ses_demo_mca$sai_quart)

levels(ses_demo_mca$sedi_quart)

summary(ses_demo_mca[,1:6])

#number of categories per variable 
cats_demo = apply(ses_demo_mca[,1:6], 2, function(x) nlevels(as.factor(x)))
cats_demo

#number of categories per variable including NA
cats_demo_na = apply(ses_demo_mca[,1:6], 2, function(x) nlevels(factor(x, exclude=NULL)))
cats_demo_na

mca_demo <- MCA(ses_demo_mca, quali.sup=c(7:10), quanti.sup=c(11))

summary(mca_demo)

# data frames for ggplot
mca_quanti_demo_df = data.frame(mca_demo$quanti.sup$coord)
mca_quali_demo_df = data.frame(mca_demo$quali.sup$coord)
mca_vars_demo_df = data.frame(mca_demo$var$coord, Variable=rep(names(cats_demo_na),cats_demo_na))
mca_obs_demo_df = data.frame(mca_demo$ind$coord)
mca_eta_demo_df = data.frame(mca_demo$var$eta2)

ggplot(data = mca_obs_demo_df, aes(x = Dim.1, y = Dim.2)) + 
  geom_hline(yintercept = 0, colour = "gray70") + 
  geom_vline(xintercept = 0, colour = "gray70") + 
  geom_point(colour = "gray50", alpha = 0.7) + 
  geom_density2d(colour = "gray80") + 
  geom_text_repel(data = mca_vars_demo_df,aes(x = Dim.1, y = Dim.2, label = rownames(mca_vars_demo_df), colour = Variable)) + 
  scale_color_brewer(palette="Dark2") +
  ggtitle("MCA plot of variables")

ggsave ("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/dimensionality/graph/mca_demo_na.png")

#Estimate the number of components needed to impute the data 
nb_ses_demo <- estim_ncpMCA(ses_demo_mca, quali.sup=c(7:10), quanti.sup=c(11))
nb_ses_demo

#Impute the dataset
complete_ses_demo <- imputeMCA(ses_demo_mca, ncp=5, quali.sup=c(7:10), quanti.sup=c(11))

#Perform MCA with complete disjunctive table 
mca_comp_demo <- MCA(ses_demo_mca, ncp=5, quali.sup=c(7:10), quanti.sup=c(11), tab.disj=complete_ses_demo$tab.disj) 

summary(mca_comp_demo)

# data frames for ggplot
mca_quali_demo_df1 = data.frame(mca_comp_demo$quali.sup$coord)
mca_vars_demo_df1 = data.frame(mca_comp_demo$var$coord, Variable=rep(names(cats_demo),cats_demo))
mca_obs_demo_df1 = data.frame(mca_comp_demo$ind$coord)
mca_eta_demo_df1 = data.frame(mca_comp_demo$var$eta2)

mca_vars_demo_out <- mca_vars_demo_df1 %>% rownames_to_column(var="categories")

write_xlsx(mca_vars_demo_out, "C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/dimensionality/dataset/mca_loadings_full.xlsx")

mca_obs_demo_dta <- mca_obs_demo_df1 %>% rownames_to_column(var="subjectid")

View(mca_obs_demo_dta)

write.dta(mca_obs_demo_dta, "C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/dimensionality/dataset/mca_scores.dta")

ggplot(mca_obs_demo_df1, aes(x=Dim.1)) +
         geom_histogram()+
  ggtitle("SES score based on PD1")

ggplot(mca_obs_demo_df1, aes(x=Dim.2)) +
  geom_histogram()+
  ggtitle("SES score based on PD2")

ggplot(mca_obs_demo_df1, aes(x=Dim.3)) +
  geom_histogram()+
  ggtitle("SES score based on PD3")

# MCA plot of categories
ggplot(data = mca_obs_demo_df1, aes(x = Dim.1, y = Dim.2)) + 
  geom_hline(yintercept = 0, colour = "gray70") + 
  geom_vline(xintercept = 0, colour = "gray70") + 
  geom_text_repel(data = mca_vars_demo_df1,aes(x = Dim.1, y = Dim.2, label = rownames(mca_vars_demo_df1), colour = Variable)) + 
  scale_color_brewer(palette="Dark2") +
  ggtitle("MCA plot of categories")

ggsave ("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/dimensionality/mca_cat_demo.png")

ggplot(data = mca_obs_demo_df1, aes(x = Dim.1, y = Dim.2)) + 
  geom_hline(yintercept = 0, colour = "gray70") + 
  geom_vline(xintercept = 0, colour = "gray70") + 
  geom_text_repel(data = mca_vars_demo_df1,aes(x = Dim.1, y = Dim.2, label = rownames(mca_vars_demo_df1), colour = Variable)) + 
  geom_text_repel(data = mca_quali_demo_df1,aes(x = Dim.1, y = Dim.2, label = rownames(mca_quali_demo_df1))) +
  ggtitle("MCA plot of variables using R package FactoMineR") + 
  scale_color_brewer(palette="Dark2") 

ggsave ("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/dimensionality/mca_cat_quali_demo.png")

# MCA plot of observations and categories
ggplot(data = mca_obs_demo_df1, aes(x = Dim.1, y = Dim.2)) + 
  geom_hline(yintercept = 0, colour = "gray70") + 
  geom_vline(xintercept = 0, colour = "gray70") + 
  geom_point(colour = "gray50", alpha = 0.7) + 
  geom_density2d(colour = "gray80") + 
  geom_text_repel(data = mca_vars_demo_df1,aes(x = Dim.1, y = Dim.2, label = rownames(mca_vars_demo_df1), colour = Variable)) + 
  scale_color_brewer(palette="Dark2") +
  ggtitle("Imputed MCA plot of variables")

ggsave ("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/dimensionality/mca_demo.png")

ggplot(data = mca_obs_demo_df1, aes(x = Dim.1, y = Dim.3)) + 
  geom_hline(yintercept = 0, colour = "gray70") + 
  geom_vline(xintercept = 0, colour = "gray70") + 
  geom_point(colour = "gray50", alpha = 0.7) + 
  geom_density2d(colour = "gray80") + 
  geom_text_repel(data = mca_vars_demo_df1,aes(x = Dim.1, y = Dim.3, label = rownames(mca_vars_demo_df1), colour = Variable)) + 
  scale_color_brewer(palette="Dark2") +
  ggtitle("MCA plot of variables")

ggsave ("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/dimensionality/graph/mca_demo_dim3.png")

ggplot(data = mca_obs_demo_df1, aes(x = Dim.2, y = Dim.3)) + 
  geom_hline(yintercept = 0, colour = "gray70") + 
  geom_vline(xintercept = 0, colour = "gray70") + 
  geom_point(colour = "gray50", alpha = 0.7) + 
  geom_density2d(colour = "gray80") + 
  geom_text_repel(data = mca_vars_demo_df1,aes(x = Dim.2, y = Dim.3, label = rownames(mca_vars_demo_df1), colour = Variable)) + 
  scale_color_brewer(palette="Dark2") +
  ggtitle("MCA plot of variables")

ggsave ("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/dimensionality/graph/mca_demo_dim23.png")

# w quali.sup
ggplot(data = mca_obs_demo_df1, aes(x = Dim.1, y = Dim.2)) + 
  geom_hline(yintercept = 0, colour = "gray70") + 
  geom_vline(xintercept = 0, colour = "gray70") + 
  geom_point(colour = "gray50", alpha = 0.7) + 
  geom_density2d(colour = "gray80") + 
  geom_text_repel(data = mca_vars_demo_df1,aes(x = Dim.1, y = Dim.2, label = rownames(mca_vars_demo_df1), colour = Variable)) + 
  geom_text_repel(data = mca_quali_demo_df1,aes(x = Dim.1, y = Dim.2, label = rownames(mca_quali_demo_df1))) +
  ggtitle("MCA plot of variables") + 
  scale_colour_discrete(name = "Variable")

ggsave ("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/dimensionality/mca_quali_demo.png")

summary(mca_comp_demo)

dimdesc(mca_comp_demo)

dimdesc(mca_comp_demo, axes=2)

?dimdesc

# Contributions of rows to dimension 1
fviz_contrib(mca_comp_demo, choice = "var", axes = 1, top = 15)

# Contributions of rows to dimension 2
fviz_contrib(mca_comp_demo, choice = "var", axes = 2, top = 15)

# Contributions of rows to dimension 3
fviz_contrib(mca_comp_demo, choice = "var", axes = 3)

# Total contribution to dimension 1 and 2
fviz_contrib(mca_comp_demo, choice = "var", axes = 1:2, top = 15)

fviz_mca_var(mca_comp_demo, col.var = "contrib",
             axes = c(1, 2),
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"), 
             repel = TRUE, # avoid text overlapping (slow)
             ggtheme = theme_minimal()
)

fviz_mca_var(mca_comp_demo, col.var = "contrib",
             axes = c(1, 3),
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"), 
             repel = TRUE, # avoid text overlapping (slow)
             ggtheme = theme_minimal()
)

fviz_mca_var(mca_comp_demo, choice = "mca.cor",
             repel = TRUE)

fviz_mca_var(mca_demo_cc, choice = "mca.cor", axes = c(1, 3),
             repel = TRUE)

?fviz_mca_var

?dimdesc

?prcomp

##################################################

#complete cases 
ses_demo_mca_cc <- na.omit(ses_demo_mca[,1:6])

ses_demo_mca_cc <- ses_demo_mca %>% 
  select(m_place_of_birth_0_2, region, parity_1, m_ethnicity_0, m_age_recruitment) %>%
  merge(ses_demo_mca_cc, by="row.names") %>%
  column_to_rownames("Row.names") #669 obs 

mca_demo_cc <- MCA(ses_demo_mca_cc, quali.sup=c(1:4), quanti.sup=c(5))

summary(mca_demo_cc)

dimdesc(mca_demo_cc, axes=2)

?dimdesc

# data frames for ggplot
mca_quanti_cc_df = data.frame(mca_demo_cc$quanti.sup$coord)
mca_quali_cc_df = data.frame(mca_demo_cc$quali.sup$coord)
mca_vars_cc_df = data.frame(mca_demo_cc$var$coord, Variable=rep(names(cats_demo),cats_demo))
mca_obs_cc_df = data.frame(mca_demo_cc$ind$coord)
mca_eta_cc_df = data.frame(mca_demo_cc$var$eta2)

mca_vars_cc_out <- mca_vars_cc_df %>% rownames_to_column(var="categories")

write_xlsx(mca_vars_cc_out, "C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/dimensionality/dataset/mca_loadings_cc.xlsx")

ggplot(mca_obs_cc_df, aes(x=Dim.1)) +
  geom_histogram()

ggplot(mca_obs_cc_df, aes(x=Dim.2)) +
  geom_histogram()

ggplot(mca_obs_cc_df, aes(x=Dim.3)) +
  geom_histogram()

ggplot(data = mca_obs_cc_df, aes(x = Dim.1, y = Dim.2)) + 
  geom_hline(yintercept = 0, colour = "gray70") + 
  geom_vline(xintercept = 0, colour = "gray70") + 
  geom_point(colour = "gray50", alpha = 0.7) + 
  geom_density2d(colour = "gray80") + 
  geom_text_repel(data = mca_vars_cc_df,aes(x = Dim.1, y = Dim.2, label = rownames(mca_vars_cc_df), colour = Variable)) + 
  scale_color_brewer(palette="Dark2") +
  ggtitle("MCA plot of variables")

ggsave ("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/dimensionality/mca_demo_cc.png")

ggplot(data = mca_obs_cc_df, aes(x = Dim.1, y = Dim.3)) + 
  geom_hline(yintercept = 0, colour = "gray70") + 
  geom_vline(xintercept = 0, colour = "gray70") + 
  geom_point(colour = "gray50", alpha = 0.7) + 
  geom_density2d(colour = "gray80") + 
  geom_text_repel(data = mca_vars_cc_df,aes(x = Dim.1, y = Dim.3, label = rownames(mca_vars_cc_df), colour = Variable)) + 
  scale_color_brewer(palette="Dark2") +
  ggtitle("MCA plot of variables")

ggsave ("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/dimensionality/mca_demo_cc_dim3.png")

ggplot(data = mca_obs_cc_df, aes(x = Dim.2, y = Dim.3)) + 
  geom_hline(yintercept = 0, colour = "gray70") + 
  geom_vline(xintercept = 0, colour = "gray70") + 
  geom_point(colour = "gray50", alpha = 0.7) + 
  geom_density2d(colour = "gray80") + 
  geom_text_repel(data = mca_vars_cc_df,aes(x = Dim.2, y = Dim.3, label = rownames(mca_vars_cc_df), colour = Variable)) + 
  scale_color_brewer(palette="Dark2") +
  ggtitle("MCA plot of variables")


mca_obs_cc_dta <- mca_obs_cc_df %>% rownames_to_column(var="subjectid")

View(mca_obs_cc_dta)

write.dta(mca_obs_cc_dta, "C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/dimensionality/dataset/mca_scores_cc.dta")

# Contributions of rows to dimension 1
fviz_contrib(mca_demo_cc, choice = "var", axes = 1, top = 15)

# Contributions of rows to dimension 2
fviz_contrib(mca_demo_cc, choice = "var", axes = 2, top = 15)

# Contributions of rows to dimension 3
fviz_contrib(mca_demo_cc, choice = "var", axes = 3)

fviz_mca_var(mca_demo_cc, col.var = "contrib",
             axes = c(1, 2),
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"), 
             repel = TRUE, # avoid text overlapping (slow)
             ggtheme = theme_minimal()
)

fviz_mca_var(mca_demo_cc, col.var = "contrib",
             axes = c(1, 3),
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"), 
             repel = TRUE, # avoid text overlapping (slow)
             ggtheme = theme_minimal()
)

