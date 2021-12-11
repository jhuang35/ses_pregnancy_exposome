# Code and summary results for Sum KK, _et al._ "The socioeconomic landscape of the exposome during pregnancy"

This repository contains all the codes used for the data cleaning and geospatial data creation, main ExWAS analyses, and visualizations for the manuscript:
"The socioeconomic landscape of the exposome during pregnancy" by Ka Kei Sum, _et al._ (2021) along with the summary results for all correlations.

The files are organized as follows:

**/analysis/**  
  - /ExWAS/: code for all ExWAS models (8 X 134 models)   
  -	/Interaction/: code for interaction with ethnicity and nativity for each SEP indicator   
  - /MCA/: code for MCA analyses  
  - /MI_IPW/:  
     - censorship.do: code to create censorship weight   
     - MI_biochem_weight.do: Multiple Imputation (MI) for biochemistry data with LOD  
     - MI_covar_weight.do: MI for all covariates   
     - MI_luminex_novegf_weight.do: MI for adipocytokines and hormones data with LOD  
     - MI_pfas_corrected_weight.do: MI for PFAS data with LOD   
  - spearman_mi_full.do: code for spearman correlation analyses  
  - 
**/data_management/**  
  - data_managment_obj_updated.do: code for data cleaning   
  -	descriptive obj_updated.do: code for transformation and descriptive analysis   
  -	biochemistry.do: code for data cleaning for biochemistry data   
  - pfas_corrected.do: code for data cleaning for PFAS data  
 
**/visualization/**   
  - /forestplots/: code to create forest plots presented in the paper   
  - /geospatial/: geospatial shape files used to create Singapore maps   
  - /results_output/: spearman and ExWAS results     
  - /spearman_correlation/: code to create correlation boxplots and heatmaps   
