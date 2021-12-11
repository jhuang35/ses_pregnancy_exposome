# Code and summary results for Sum KK, _et al._ "The socioeconomic landscape of the exposome during pregnancy"

This repository contains all the codes used for the data cleaning and geospatial data creation, main ExWAS analyses, and visualizations for the manuscript:
"The socioeconomic landscape of the exposome during pregnancy" by Ka Kei Sum, _et al._ (2021) along with the summary results for all correlations.

The files are organized as follows:

/data_management/  
  - data_managment_obj_updated: code for data cleaning   
  -	descriptive obj_updated: code for transformation and descriptive analysis   
  -	biochemistry: code for data cleaning for biochemistry data   
  - pfas_corrected: code for data cleaning for PFAS data  

/analysis/  
  - ExWAS: code for all ExWAS models (8 X 134 models)   
  -	Interaction: code for interaction with ethnicity and nativity for each SEP indicator   
  - MCA: code for MCA analyses  
  - /MI_IPW/  
     - censorship: code to create censorship weight   
     - MI_biochem_weight: MI for biochemistry data with LOD  
     - MI_covar_weight: MI for all covariates   
     - MI_luminex_novegf_weight: MI for adipocytokines and hormones data with LOD  
     - MI_pfas_corrected_weight: MI for PFAS data with LOD   
  - spearman_mi_full: spearman correlation analyses  
  
/visualization/   
  - forestplots: code to create forest plots presented in the paper   
  - geospatial: geospatial shape files used to create Singapore maps   
  - results_output: spearman and ExWAS results     
  - spearman_correlation: code to create correlation boxplots and heatmaps   
