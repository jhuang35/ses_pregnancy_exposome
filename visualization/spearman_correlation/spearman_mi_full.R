library(tidyverse)
library(dplyr)
library(Hmisc)
library(forcats)
library(pheatmap)
library(gplots)
library(RColorBrewer)

###############################################
spearman_coef_mi_full <- read.csv("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/spearman_mi_full_neo.csv", row.names=1)
spearman_coef_mat_mi_full <- as.matrix(spearman_coef_mi_full)

flattenCorrMatrix_mi <- function(spearman_coef_mat_mi_full) {
  ut <- upper.tri(spearman_coef_mat_mi_full)
  data.frame(
    row = rownames(spearman_coef_mat_mi_full)[row(spearman_coef_mat_mi_full)[ut]],
    column = rownames(spearman_coef_mat_mi_full)[col(spearman_coef_mat_mi_full)[ut]],
    cor  =(spearman_coef_mat_mi_full)[ut]
  )
}

spearman_coef_flat_mi_full <- flattenCorrMatrix_mi(spearman_coef_mat_mi_full)

class(spearman_coef_flat_mi_full)

spearman_coef_flat_mi_full <- mutate(spearman_coef_flat_mi_full, abs_cor=abs(cor)) 

biomarker_desc <- read.csv("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/data/raw_data/biomarker_desc.csv", header=TRUE)

biomarker_desc1 <- biomarker_desc %>% rename(row=Exposure)
biomarker_desc2 <- biomarker_desc %>% rename(column=Exposure)

spearman_coef_join1_mi_full <- spearman_coef_flat_mi_full %>% 
  left_join(biomarker_desc1, by="row") %>%
  rename (row_fam=Family)

spearman_coef_join2_mi_full <- spearman_coef_join1_mi_full %>% 
  left_join(biomarker_desc2, by="column") %>%
  rename (col_fam=Family) %>%
  mutate(family1="(all)")

write_xlsx(spearman_coef_join2_mi_full, "C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/write up/spearman.xlsx")

View(spearman_coef_join2_mi_full)

filter(spearman_coef_join2_mi_full, abs_cor>=0.9)

table(is.na(spearman_coef_join2_mi_full))

within_group_spearman_mi_full <- filter(spearman_coef_join2_mi_full, row_fam==col_fam)

ggplot(data=filter(spearman_coef_join2_mi_full, row_fam==col_fam)) +
  geom_boxplot(
    mapping=aes(
      x=reorder(row_fam, abs_cor, FUN = median), 
      y=abs_cor
    )
  ) +  scale_x_discrete(guide = guide_axis(angle = 90)) 

##

ggplot(data=spearman_coef_join2_mi_full) +
  geom_boxplot(within_group_spearman_mi_full,
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
    "lipids",
    "air pollutants",
    "anthropometrics",
    "enzyme(liver)",
    "blood pressure"
  )
  ) 

ggplot(data=spearman_coef_join2_mi_full) +
  geom_boxplot(within_group_spearman_mi_full,
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
  ) + scale_x_discrete(guide = guide_axis(angle = 45), limits=c(
    "blood pressure",
    "anthropometrics",
    "air pollutants",
    "lipids/fatty acids",
    "pfas",
    "glucose", 
    "amino acids/choline", 
    "minerals",
    "vitamins", 
    "other biochemicals",
    "adipocytokines and hormones",
    "(all)"
  )
  ) +
  xlab("Category") +
  ylab("Absolute correlation") +
  theme(text = element_text(size=15))

ggsave("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/desc/boxplot_mi_full_neo.png")

quantile(spearman_coef_join2_mi_full$abs_cor, probs=0.95)
#0.3981078  

quantile(spearman_coef_join2_mi_full$abs_cor, probs=0.05)
#0.00508895 

summary(spearman_coef_join2_mi_full$abs_cor)
#median 0.0618993

quantile(within_group_spearman_mi_full$abs_cor, probs=0.95)
#0.8155659  

quantile(within_group_spearman_mi_full$abs_cor, probs=0.05)
#0.02286558 

summary(within_group_spearman_mi_full$abs_cor)
#median 0.2370387

quantile_family <- within_group_spearman_mi_full %>% 
  group_by(row_fam) %>%
  summarize(median=quantile(abs_cor, probs=c(0.5)))

a <- within_group_spearman_mi_full %>% 
  group_by(row_fam) %>%
  filter(abs_cor>0.5, row_fam=="amino acids")

between_group_abs_mi_full <- spearman_coef_join2_mi_full %>%
  filter(row_fam!=col_fam)

summary(between_group_abs_mi_full$abs_cor)
#median 0.0538528

quantile(between_group_abs_mi_full$abs_cor, probs=0.95)
#0.2040636 

quantile(between_group_abs_mi_full$abs_cor, probs=0.05)
#0.00452676  

length(which(between_group_abs_mi_full$abs_cor>0.5)) #13 

between_group_abs_mi_full %>%
  filter(abs_cor>0.5)

pfas_spearman_mi_full <- within_group_spearman_mi_full %>%
  filter(row_fam==col_fam, row_fam=="pfas")

quantile(pfas_spearman_mi_full$abs_cor, probs=0.5) 
#0.3619209  

pfas_spearman_mi_full %>%
  filter(abs_cor>0.5)

ah_spearman_mi_full <- within_group_spearman_mi_full %>%
  filter(row_fam==col_fam, row_fam=="adipocytokines and hormones")

quantile(ah_spearman_mi_full$abs_cor, probs=0.5) 
#0.0956576

#within loosely linked group, those high corr
#########################################
pfas_spearman_mi_full  %>%
  filter(abs_cor>0.7)
#didnt change much 

ah_spearman_mi_full %>%
  filter(abs_cor>0.5)
#ls_cpeptide ls_mbc3ins 0.9258314
#ls_igfbp1  ls_igfbp4 0.7079894

#######################################
#creating heatmap for spearman correlation 

?heatmap
?pheatmap

spearman_rename_mi_full <- read.csv("C:/Users/sumkk/SharePoint/Sum Ka Kei - EDRIVE/SICS/ses_exposome/results/spearman_mi_full_neo_rename.csv", row.names=1)
spearman_rename_mat_mi_full <- as.matrix(spearman_rename_mi_full)
?colorRampPalette

View(spearman_rename_mat_mi_full)

paletteLength <- 50

col <- colorRampPalette(brewer.pal(9, "RdBu"))(paletteLength)


col1 <- colorRampPalette(c("blue", "white", "red"))(paletteLength)


# length(breaks) == length(paletteLength) + 1
# use floor and ceiling to deal with even/odd length pallettelengths
myBreaks <- c(seq(min(spearman_rename_mat_mi_full), 0, length.out=ceiling(paletteLength/2) + 1), 
              seq(max(spearman_rename_mat_mi_full)/paletteLength, max(spearman_rename_mat_mi_full), length.out=floor(paletteLength/2)))

pheatmap(spearman_rename_mat_mi_full, 
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

pheatmap(spearman_rename_mat_mi_full, 
         col=col, 
         symm=TRUE, 
         fontsize=4.3,
         cellheight=3.3,
         cellwidth=3.3,
         border_color= "grey60",
         scale="none"
)

?gpar


length(which(spearman_coef_flat_mi_full$abs_cor>0.9)) #27 

spearman_coef_join2_mi_full %>%
  filter(abs_cor>0.9)

###########
pfas_spearman_mi_full_res <- pfas_spearman_mi_full %>%
  filter(row=="ls_pfhxs"| row=="ls_pfos"| row=="ls_pfoa"| row=="ls_pfna") %>%
  filter(column=="ls_pfhxs"| column=="ls_pfos"| column=="ls_pfoa"| column=="ls_pfna")

quantile(pfas_spearman_mi_full_res$abs_cor, probs=0.5) 
#0.48 

pfas_spearman_mi_full_res1 <- pfas_spearman_mi_full %>%
  filter(row=="ls_pfhxs"| row=="ls_pfos"| row=="ls_pfoa"| row=="ls_pfna"| row=="ls_pfunda") %>%
  filter(column=="ls_pfhxs"| column=="ls_pfos"| column=="ls_pfoa"| column=="ls_pfna"| column=="ls_pfunda")

quantile(pfas_spearman_mi_full_res1$abs_cor, probs=0.5) 
#0.48 

