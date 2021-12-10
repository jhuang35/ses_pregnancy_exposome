# ses_pregnancy_exposome
Code for Sum KK, et al. socioeconomic landscape of pregnancy exposome

This repository contains all the codes used for the data clearning, main ExWAS analyses, and visualizations for the manuscript:
"The socioeconomic landscape of the exposome during pregnancy" by Ka Kei Sum, et al.

There are three sub-folders:

-	data_management 
o	data_managment_obj_updated: codes for data cleaning 
o	descriptive obj_updated: codes for transformation and descriptive analysis 
o	biochemistry: codes for data cleaning for biochemistry data 
o	pfas_corrected: codes for data cleaning for PFAS data
-	analysis
o	ExWAS: codes for all ExWAS models (8 X 134 models) 
o	Interaction: codes for interaction with ethnicity and nativity for each SEP indicator 
o	MCA: codes for MCA analyses
o	MI_IPW
	censorship: codes to create censorship weight 
	MI_biochem_weight: MI for biochemistry data with LOD
	MI_covar_weight: MI for all covariates 
	MI_luminex_novegf_weight: MI for adipocytokines and hormones data with LOD
	MI_pfas_corrected_weight: MI for PFAS data with LOD 
o	spearman_mi_full: spearman correlation analysis
-	visualization 
o	forestplots: codes to create forest plots presented in the paper 
o	geospatial: geospatial shape files used to create Singapore maps 
o	results_output: spearman and ExWAS results  
o	spearman_correlation: codes to create correlation boxplots and heatmaps 
 
