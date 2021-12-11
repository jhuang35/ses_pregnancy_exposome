library(tidyverse)
library(dplyr)
library(Hmisc)
library(forcats)
library(pheatmap)
library(gplots)
library(RColorBrewer)
library(ggbeeswarm)
library(naniar)


###############################################
spearman_coef_mi_full_sen <- read.csv("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/spearman_mi_full_sen_neo.csv", row.names=1)
spearman_coef_mat_mi_full_sen <- as.matrix(spearman_coef_mi_full_sen)

flattenCorrMatrix_mi <- function(spearman_coef_mat_mi_full_sen) {
  ut <- upper.tri(spearman_coef_mat_mi_full_sen)
  data.frame(
    row = rownames(spearman_coef_mat_mi_full_sen)[row(spearman_coef_mat_mi_full_sen)[ut]],
    column = rownames(spearman_coef_mat_mi_full_sen)[col(spearman_coef_mat_mi_full_sen)[ut]],
    cor  =(spearman_coef_mat_mi_full_sen)[ut]
  )
}

spearman_coef_flat_mi_full_sen <- flattenCorrMatrix_mi(spearman_coef_mat_mi_full_sen)

class(spearman_coef_flat_mi_full_sen)

spearman_coef_flat_mi_full_sen <- mutate(spearman_coef_flat_mi_full_sen, abs_cor=abs(cor)) 

biomarker_desc <- read.csv("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/data/raw_data/biomarker_desc.csv", header=TRUE)

biomarker_desc1 <- biomarker_desc %>% rename(row=Exposure)
biomarker_desc2 <- biomarker_desc %>% rename(column=Exposure)

spearman_coef_join1_mi_full_sen <- spearman_coef_flat_mi_full_sen %>% 
  left_join(biomarker_desc1, by="row") %>%
  rename (row_fam=Family)

spearman_coef_join2_mi_full_sen <- spearman_coef_join1_mi_full_sen %>% 
  left_join(biomarker_desc2, by="column") %>%
  rename (col_fam=Family) %>%
  mutate(family1="(all)")

write_xlsx(spearman_coef_join2_mi_full_sen, "C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/write up/spearman_sen.xlsx")

View(spearman_coef_join2_mi_full_sen)

filter(spearman_coef_join2_mi_full_sen, abs_cor>=0.9)

table(is.na(spearman_coef_join2_mi_full_sen))

within_group_spearman_mi_full_sen <- filter(spearman_coef_join2_mi_full_sen, row_fam==col_fam)

ggplot(data=filter(spearman_coef_join2_mi_full_sen, row_fam==col_fam)) +
  geom_boxplot(
    mapping=aes(
      x=reorder(row_fam, abs_cor, FUN = median), 
      y=abs_cor
    )
  ) +  scale_x_discrete(guide = guide_axis(angle = 90)) 

##

ggplot(data=spearman_coef_join2_mi_full_sen) +
  geom_boxplot(within_group_spearman_mi_full_sen,
               mapping=aes(
                 x=row_fam, 
                 y=abs_cor
               )
  ) + 
  geom_boxplot(
    mapping=aes(
      x=family1,
      y=abs_cor
    )
  ) + 
  geom_hline(
    mapping=aes(
      yintercept=quantile(abs_cor, probs=0.95)
    )
  ) + scale_x_discrete(guide = guide_axis(angle = 90), limits=c(
    "(all)", 
    "adipocytokines and hormones",
    "vitamins", 
    "minerals", 
    "amino acids", 
    "waste byproduct(kidney)",
    "glucose", 
    "pfas",
    "lipids/fatty acids",
    "air pollutants",
    "anthropometrics",
    "enzyme(liver)",
    "blood pressure"
  )
  ) 

?geom_quasirandom
?geom_point

ggplot(data=spearman_coef_join2_mi_full_sen) +
  geom_quasirandom(within_group_spearman_mi_full_sen,
               mapping=aes(
                 x=row_fam, 
                 y=abs_cor), 
                col="gray",
               size=0.8
               ) +
  geom_boxplot(within_group_spearman_mi_full_sen,
               mapping=aes(
                 x=row_fam, 
                 y=abs_cor,
                 col=row_fam),
                 fill="NA",
                 outlier.shape = NA
               ) +
  geom_boxplot(
    mapping=aes(
      x=family1,
      y=abs_cor
    )
  ) + 
  geom_hline(
    mapping=aes(
      yintercept=quantile(abs_cor, probs=0.95)
    )
  ) + scale_x_discrete(guide = guide_axis(angle = 45), limits=c(
    "Blood pressure",
    "Anthropometrics",
    "Air pollutants",
    "Lipids/fatty acids",
    "PFAS",
    "Glucose", 
    "Amino acids/choline", 
    "Minerals",
    "Other biochemicals",
    "Vitamins",
    "Adipocytokines and hormones",
    "(all)"
  )
  ) +
  xlab("Exposure family") +
  ylab("Absolute correlation") +
  theme(text = element_text(size=15), 
        panel.border = element_blank(),
        panel.grid = element_blank(), 
        panel.background = element_rect(color="black", fill="white"),
        legend.position = "none")

ggsave("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/desc/boxplot_mi_full_sen_neo_b.png")

quantile(spearman_coef_join2_mi_full_sen$abs_cor, probs=0.95)
#0.3734745   

quantile(spearman_coef_join2_mi_full_sen$abs_cor, probs=0.05)
#0.00519745 

summary(spearman_coef_join2_mi_full_sen$abs_cor)
#median 0.0608316

quantile(within_group_spearman_mi_full_sen$abs_cor, probs=0.95)
#0.8319589  

quantile(within_group_spearman_mi_full_sen$abs_cor, probs=0.05)
#0.0189611 

summary(within_group_spearman_mi_full_sen$abs_cor)
#median 0.2213782

quantile_family_sen <- within_group_spearman_mi_full_sen %>% 
  group_by(row_fam) %>%
  summarize(median=quantile(abs_cor, probs=c(0.5))) %>%
  arrange(median)

a_sen <- within_group_spearman_mi_full_sen %>% 
  group_by(row_fam) %>%
  rename(abs_cor_sen=abs_cor) %>%
  left_join(within_group_spearman_mi_full, by=c("row", "column", "Exposure_name.x", "Exposure_name.y", "row_fam")) %>%
  filter(abs_cor>0.5) %>%
  group_by(row_fam) %>%
  select(row, column, Exposure_name.x, Exposure_name.y,row_fam, abs_cor, abs_cor_sen) 

within_group_spearman_mi_full_sen %>% 
  group_by(row_fam) %>%
  filter(abs_cor>0.5, row_fam=="vitamins") 
  summarize(min=min(abs_cor), max=max(abs_cor))

between_group_abs_mi_full_sen <- spearman_coef_join2_mi_full_sen %>%
  filter(row_fam!=col_fam)

summary(between_group_abs_mi_full_sen$abs_cor)
#median 0.0534214

quantile(between_group_abs_mi_full_sen$abs_cor, probs=0.95)
#0.2106692    

quantile(between_group_abs_mi_full_sen$abs_cor, probs=0.05)
#0.00475476  

length(which(between_group_abs_mi_full_sen$abs_cor>0.5)) #1 

between_group_abs_mi_full_sen %>%
  filter(abs_cor>0.45)

pfas_spearman_mi_full_sen <- within_group_spearman_mi_full_sen %>%
  filter(row_fam==col_fam, row_fam=="pfas")

quantile(pfas_spearman_mi_full_sen$abs_cor, probs=0.5) 
#0.3572738   

pfas_spearman_mi_full_sen %>%
  filter(abs_cor>0.5)

ah_spearman_mi_full_sen <- within_group_spearman_mi_full_sen %>%
  filter(row_fam==col_fam, row_fam=="adipocytokines and hormones")

quantile(ah_spearman_mi_full_sen$abs_cor, probs=0.5) 
#0.101909

#within loosely linked group, those high corr
#########################################
pfas_spearman_mi_full_sen  %>%
  filter(abs_cor>0.7)
#didnt change much 

ah_spearman_mi_full_sen %>%
  filter(abs_cor>0.5)
#ls_cpeptide ls_mbc3ins 0.9258314
#ls_igfbp1  ls_igfbp4 0.7079894

#######################################
#creating heatmap for spearman correlation 

?heatmap
?pheatmap

spearman_rename_mi_full_sen <- read.csv("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/spearman_mi_full_sen_neo_rename.csv", row.names=1)
spearman_rename_mat_mi_full_sen <- as.matrix(spearman_rename_mi_full_sen)
?colorRampPalette

View(spearman_rename_mat_mi_full_sen)

paletteLength <- 50

col <- colorRampPalette(brewer.pal(9, "RdBu"))(paletteLength)


col1 <- colorRampPalette(c("blue", "white", "red"))(paletteLength)


# length(breaks) == length(paletteLength) + 1
# use floor and ceiling to deal with even/odd length pallettelengths
myBreaks <- c(seq(min(spearman_rename_mat_mi_full_sen), 0, length.out=ceiling(paletteLength/2) + 1), 
              seq(max(spearman_rename_mat_mi_full_sen)/paletteLength, max(spearman_rename_mat_mi_full_sen), length.out=floor(paletteLength/2)))

pheatmap(spearman_rename_mat_mi_full_sen, 
         annotation_row = biomarker_desc_hm,
         cluster_rows=F,
         cluster_cols=F,
         col=col, 
         symm=TRUE, 
         fontsize=4.5,
         cellheight=3.5,
         cellwidth=3.5,
         border_color= "grey60",
         scale="none",
         breaks=myBreaks
)

biomarker_desc_hm$Family=factor(biomarker_desc_hm$Family, levels=c("Blood pressure",
                                                              "Anthropometrics",
                                                              "Air pollutants",
                                                              "Lipids/fatty acids",
                                                              "PFAS",
                                                              "Glucose", 
                                                              "Amino acids/choline", 
                                                              "Minerals",
                                                              "Other biochemicals",
                                                              "Vitamins",
                                                              "Adipocytokines and hormones"))

biomarker_desc_hm <- biomarker_desc %>% 
  filter(!grepl(remove.list, Exposure)) %>%
  column_to_rownames("Exposure_name") %>%
  select(-("Exposure")) %>%
  rename("Exposure Family"="Family")



remove.list <- paste(c("ls_insulin", "ls_mbc3hscp_num", "ls_mbc3alt_num", "ls_mbc3ggt_num", "ls_mbc3ura_num", 
                       "s_mbc3cre", "ls_crp", "ls_vegf", "ls_pfhpa", "ls_pfdoda", "ls_ifng", 	
                       "s_mbc3ldl_num", "ls_mbc3ggt"), collapse="|")

row.names(biomarker_desc_hm) <- colnames(spearman_rename_mat_mi_full_sen)

pheatmap(spearman_rename_mat_mi_full_sen, 
         col=col, 
         symm=TRUE, 
         fontsize=4.3,
         cellheight=3.3,
         cellwidth=3.3,
         border_color= "grey60",
         scale="none"
)

?gpar


length(which(spearman_coef_flat_mi_full_sen$abs_cor>0.9)) #27 

spearman_coef_join2_mi_full_sen %>%
  filter(abs_cor>0.9)

###########
pfas_spearman_mi_full_sen_res <- pfas_spearman_mi_full_sen %>%
  filter(row=="ls_pfhxs"| row=="ls_pfos"| row=="ls_pfoa"| row=="ls_pfna") %>%
  filter(column=="ls_pfhxs"| column=="ls_pfos"| column=="ls_pfoa"| column=="ls_pfna")

quantile(pfas_spearman_mi_full_sen_res$abs_cor, probs=0.5) 
#0.48 

pfas_spearman_mi_full_sen_res1 <- pfas_spearman_mi_full_sen %>%
  filter(row=="ls_pfhxs"| row=="ls_pfos"| row=="ls_pfoa"| row=="ls_pfna"| row=="ls_pfunda") %>%
  filter(column=="ls_pfhxs"| column=="ls_pfos"| column=="ls_pfoa"| column=="ls_pfna"| column=="ls_pfunda")

quantile(pfas_spearman_mi_full_sen_res1$abs_cor, probs=0.5) 
#0.48 


##############################
#comparing sensitivity analyses 

all_btw <- between_group_abs_mi_full_sen %>%
  select(row, column, abs_cor, Exposure_name.x, Exposure_name.y, row_fam, col_fam) %>%
  rename (abs_cor_sen=abs_cor)

all_btw_comp <- between_group_abs_mi_full %>%
  left_join(all_btw, by=c("row", "column", "Exposure_name.x", "Exposure_name.y", "row_fam", "col_fam")) %>%
  select(row, column, Exposure_name.x, Exposure_name.y,row_fam, col_fam, abs_cor, abs_cor_sen) %>%
  mutate(percent_diff=((abs_cor_sen-abs_cor)/abs_cor_sen)*100, times_diff=abs_cor/abs_cor_sen, times_diff1=abs_cor_sen/abs_cor) 

all_btw_comp_dec <- all_btw_comp %>%
  group_by(row_fam, col_fam) %>%
  filter(times_diff>=1) %>%
  arrange(times_diff)
#  summarize(min_decrease=min(times_diff), max_decrease=max(times_diff)) %>%
#  arrange(max_decrease)

all_btw_comp_inc <- all_btw_comp %>%
  group_by(row_fam, col_fam) %>%
  filter(times_diff1>=1) %>%
  summarize(min_increase=min(times_diff1), max_increase=max(times_diff1)) %>%
  arrange(max_increase)

all_with <- within_group_spearman_mi_full_sen %>%
  select(row, column, abs_cor, Exposure_name.x, Exposure_name.y, row_fam) %>%
  rename (abs_cor_sen=abs_cor)

all_with_comp <- within_group_spearman_mi_full %>%
  left_join(all_with, by=c("row", "column", "Exposure_name.x", "Exposure_name.y", "row_fam")) %>%
  select(row, column, Exposure_name.x, Exposure_name.y,row_fam, col_fam, abs_cor, abs_cor_sen) %>%
  mutate(percent_diff=((abs_cor_sen-abs_cor)/abs_cor_sen)*100, times_diff=abs_cor/abs_cor_sen, times_diff1=abs_cor_sen/abs_cor) %>%
  group_by(row_fam)

all_with_comp_dec <- all_with_comp %>%
  filter(abs_cor>0.5 & times_diff>=1) %>%
  summarize(min_decrease=min(times_diff), max_decrease=max(times_diff))

all_with_comp_inc <- all_with_comp %>%
  filter(abs_cor>0.5 & times_diff1>=1) %>%
  summarize(min_increase=min(times_diff1), max_increase=max(times_diff1))

options(scipen=999)


aa_ins_cpep <- between_group_abs_mi_full_sen %>%
  filter((column=="ls_mbc3ins"|column=="ls_cpeptide") & row_fam=="amino acids") %>%
  select(row, column, abs_cor) %>%
  rename (abs_cor_sen=abs_cor)

aa_ins_cpep_comp <- between_group_abs_mi_full %>%
  filter((column=="ls_mbc3ins"|column=="ls_cpeptide") & row_fam=="amino acids") %>%
  left_join(aa_ins_cpep, by=c("row", "column")) %>%
  select(row, column, abs_cor, abs_cor_sen) %>%
  mutate(percent_diff=((abs_cor_sen-abs_cor)/abs_cor_sen)*100, times_diff=abs_cor/abs_cor_sen, times_diff1=abs_cor_sen/abs_cor) %>%
  arrange(abs_cor)

###############################
library(visNetwork)
library(geomnet)
library(igraph)

network <- spearman_coef_join2_mi_full_sen %>% 
  mutate (id=1:n())%>% 
  select(id, everything()) %>% 
  mutate(value=abs_cor)
  
rm(network)

View(between_group_abs_mi_full_sen)

value <- between_group_abs_mi_full_sen %>%
  group_by(row) %>%
  arrange(row) %>%
  filter(abs_cor>0.5)

rm(value)
  
biomarker_desc


visNetwork(
  nodes=
)

