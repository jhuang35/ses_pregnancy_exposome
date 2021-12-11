/* "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\raw_data\
DO file "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\do_files\mi_covar
Multiple imputation covariate
28 Jan 2020, Ka Kei Sum
Dataset: 
  "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\raw_data\obj_clean_transformed_standardized (1193 vars, 1,344 obs)
*/

cd "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\mi_data"
capture log close  
log using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\log_files\mi_covar_weight.log", replace 
set more off

use "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\raw_data\obj_clean_transformed_standardized", clear

merge 1:1 subjectid using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\dimensionality\dataset\mca_scores_full_cluster.dta"

drop Dim_3-_merge

merge 1:1 subjectid using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\raw_data\censorship1"

drop if m_age_recruitment==.

drop _merge 

//gen interaction term 
gen dim1_sq=Dim_1^2
gen dim2_sq=Dim_2^2

//bp (1095)
mi set flong 

mi register imputed accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart parity_1 m_income_0 m_occupation_0_1 f_occupation_corrected_0_1 f_monthly_income_0_1 m_place_of_birth_0_2 region

mi register regular m_ethnicity_0 m_age_recruitment s_sbp_avg ls_dbp_avg ls_map_avg wdel_quintile dim1_sq dim2_sq Dim_1 Dim_2

/*
mi impute chained (pmm, knn(3)) ///
accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart parity_1 m_income_0 m_occupation_0_1 f_occupation_corrected_0_1 f_monthly_income_0_1 m_place_of_birth_0_2 region ///
= m_age_recruitment s_sbp_avg ls_dbp_avg ls_map_avg i.w26_quintile dim1_sq dim2_sq Dim_1 Dim_2 if m_ethnicity_0!=4 & s_sbp_avg!=., replace add(10) rseed(53421) by(m_ethnicity_0) dryrun
*/

mi impute chained (pmm, knn(3)) ///
accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart parity_1 m_income_0 m_occupation_0_1 f_occupation_corrected_0_1 f_monthly_income_0_1 m_place_of_birth_0_2 region ///
= m_age_recruitment s_sbp_avg ls_dbp_avg ls_map_avg i.wdel_quintile dim1_sq dim2_sq Dim_1 Dim_2 if m_ethnicity_0!=4 & s_sbp_avg!=., replace add(10) rseed(53421) by(m_ethnicity_0, noreport) 

mi desc

*compare observed and imputed distribution 
//midiagplots accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart if m_ethnicity_0!=4 & s_sbp_avg!=., m(1)

save bp_mi_weight, replace 

*convergence diagnostics 
mi impute chained (pmm, knn(3)) ///
accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart parity_1 m_income_0 m_occupation_0_1 f_occupation_corrected_0_1 f_monthly_income_0_1 m_place_of_birth_0_2 region ///
= m_age_recruitment s_sbp_avg ls_dbp_avg ls_map_avg i.w26_quintile dim1_sq dim2_sq Dim_1 Dim_2 if m_ethnicity_0!=4 & s_sbp_avg!=., add(3) burnin(100) savetrace(convergence/bp_impstats, replace) rseed(53421)

use convergence/bp_impstats, clear
rename f_occupation_corrected_0_1_mean f_occupation_corr_0_1_mean
desc
reshape wide *mean *sd, i(iter) j(m)
tsset iter
tsline accommodation_0_2_mean*, name(accommodation_0_2_mean,replace) legend(off) ytitle("accommodation_0_2 mean")
tsline accommodation_0_2_sd*, name(accommodation_0_2_sd, replace) legend(off) ytitle("accommodation_0_2 sd")
graph combine accommodation_0_2_mean accommodation_0_2_sd, xcommon cols(1) 


*body_measures
***************

//ls_m_weight_pw26 ls_m_height_pw26 ls_m_midarm_pw26 s_m_triceps_pw26 ls_m_biceps_pw26 s_m_subscapular_pw26 s_m_suprailiac_pw26 ls_avg_weight_1sttri ls_avg_weight_2ndtri ls_avg_weight_3rdtri ls_last_antenatal_weight

//ls_m_weight_pw26 (1109)
use "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\raw_data\obj_clean_transformed_standardized", clear

merge 1:1 subjectid using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\dimensionality\dataset\mca_scores_full_cluster.dta

drop Dim_3-_merge

merge 1:1 subjectid using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\raw_data\censorship1

drop if m_age_recruitment==.

drop _merge 

//gen interaction term 
gen dim1_sq=Dim_1^2
gen dim2_sq=Dim_2^2

mi set flong 

mi register imputed accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart parity_1 m_income_0 m_occupation_0_1 f_occupation_corrected_0_1 f_monthly_income_0_1 m_place_of_birth_0_2 region ///
ls_m_height_pw26 ls_m_midarm_pw26 s_m_triceps_pw26 ls_m_biceps_pw26 s_m_subscapular_pw26 s_m_suprailiac_pw26 ls_avg_weight_1sttri ls_avg_weight_2ndtri ls_avg_weight_3rdtri ls_last_antenatal_weight

mi register regular m_ethnicity_0 m_age_recruitment ls_m_weight_pw26 w26_quintile dim1_sq dim2_sq Dim_1 Dim_2

/*
mi impute chained ///
(regress) ls_m_height_pw26 ls_m_midarm_pw26 s_m_triceps_pw26 ls_m_biceps_pw26 s_m_subscapular_pw26 s_m_suprailiac_pw26 ls_avg_weight_1sttri ls_avg_weight_2ndtri ls_avg_weight_3rdtri ls_last_antenatal_weight ///
(pmm, knn(3)) ///
accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart parity_1 m_income_0 m_occupation_0_1 f_occupation_corrected_0_1 f_monthly_income_0_1 m_place_of_birth_0_2 region ///
= m_age_recruitment ls_m_weight_pw26 i.w26_quintile dim1_sq dim2_sq Dim_1 Dim_2 if m_ethnicity_0!=4 & ls_m_weight_pw26!=., replace add(2) rseed(53421) by(m_ethnicity_0) dryrun
*/

mi impute chained ///
(regress) ls_m_height_pw26 ls_m_midarm_pw26 s_m_triceps_pw26 ls_m_biceps_pw26 s_m_subscapular_pw26 s_m_suprailiac_pw26 ls_avg_weight_1sttri ls_avg_weight_2ndtri ls_avg_weight_3rdtri ls_last_antenatal_weight ///
(pmm, knn(3)) ///
accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart parity_1 m_income_0 m_occupation_0_1 f_occupation_corrected_0_1 f_monthly_income_0_1 m_place_of_birth_0_2 region ///
= m_age_recruitment ls_m_weight_pw26 i.w26_quintile dim1_sq dim2_sq Dim_1 Dim_2 if m_ethnicity_0!=4 & ls_m_weight_pw26!=., replace add(10) rseed(53421) by(m_ethnicity_0, noreport)

//midiagplots accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart if m_ethnicity_0!=4 & ls_m_weight_pw26!=., m(1) 

save body_measures\ls_m_weight_pw26_mi_weight, replace 

//ls_ppbmi 
use "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\raw_data\obj_clean_transformed_standardized", clear

merge 1:1 subjectid using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\dimensionality\dataset\mca_scores_full_cluster.dta

drop Dim_3-_merge

merge 1:1 subjectid using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\raw_data\censorship1

drop if m_age_recruitment==.

drop _merge 

//gen interaction term 
gen dim1_sq=Dim_1^2
gen dim2_sq=Dim_2^2

mi set flong 

mi register imputed accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart parity_1 m_income_0 m_occupation_0_1 f_occupation_corrected_0_1 f_monthly_income_0_1 m_place_of_birth_0_2 region ///
ls_m_weight_pw26 ls_m_midarm_pw26 s_m_triceps_pw26 ls_m_biceps_pw26 s_m_subscapular_pw26 s_m_suprailiac_pw26 ls_avg_weight_1sttri ls_avg_weight_2ndtri ls_avg_weight_3rdtri ls_last_antenatal_weight s_gwg

mi register regular m_ethnicity_0 m_age_recruitment ls_ppbmi w26_quintile dim1_sq dim2_sq Dim_1 Dim_2

/*
mi impute chained ///
(regress) ls_m_weight_pw26 ls_m_midarm_pw26 s_m_triceps_pw26 ls_m_biceps_pw26 s_m_subscapular_pw26 s_m_suprailiac_pw26 ls_avg_weight_1sttri ls_avg_weight_2ndtri ls_avg_weight_3rdtri ls_last_antenatal_weight ///
(pmm, knn(3)) ///
accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart parity_1 m_income_0 m_occupation_0_1 f_occupation_corrected_0_1 f_monthly_income_0_1 m_place_of_birth_0_2 region ///
= m_age_recruitment ls_m_height_pw26 i.w26_quintile dim1_sq dim2_sq Dim_1 Dim_2 if m_ethnicity_0!=4 & ls_m_height_pw26!=., replace add(2) rseed(53421) by(m_ethnicity_0) dryrun
*/

mi impute chained ///
(regress) ls_m_weight_pw26 ls_m_midarm_pw26 s_m_triceps_pw26 ls_m_biceps_pw26 s_m_subscapular_pw26 s_m_suprailiac_pw26 ls_avg_weight_1sttri ls_avg_weight_2ndtri ls_avg_weight_3rdtri ls_last_antenatal_weight s_gwg ///
(pmm, knn(3)) ///
accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart parity_1 m_income_0 m_occupation_0_1 f_occupation_corrected_0_1 f_monthly_income_0_1 m_place_of_birth_0_2 region ///
= m_age_recruitment ls_ppbmi i.w26_quintile dim1_sq dim2_sq Dim_1 Dim_2 if m_ethnicity_0!=4 & ls_ppbmi!=., replace add(10) rseed(53421) by(m_ethnicity_0, noreport)

//midiagplots accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart if m_ethnicity_0!=4 & ls_m_height_pw26!=., m(1) 

save body_measures\ls_ppbmi, replace 

//s_gwg
use "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\raw_data\obj_clean_transformed_standardized", clear

merge 1:1 subjectid using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\dimensionality\dataset\mca_scores_full_cluster.dta

drop Dim_3-_merge

merge 1:1 subjectid using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\raw_data\censorship1

drop if m_age_recruitment==.

drop _merge 

//gen interaction term 
gen dim1_sq=Dim_1^2
gen dim2_sq=Dim_2^2

mi set flong 

mi register imputed accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart parity_1 m_income_0 m_occupation_0_1 f_occupation_corrected_0_1 f_monthly_income_0_1 m_place_of_birth_0_2 region ///
ls_m_weight_pw26 ls_m_midarm_pw26 s_m_triceps_pw26 ls_m_biceps_pw26 s_m_subscapular_pw26 s_m_suprailiac_pw26 ls_avg_weight_1sttri ls_avg_weight_2ndtri ls_avg_weight_3rdtri ls_last_antenatal_weight ls_ppbmi

mi register regular m_ethnicity_0 m_age_recruitment s_gwg w26_quintile dim1_sq dim2_sq Dim_1 Dim_2

/*
mi impute chained ///
(regress) ls_m_weight_pw26 ls_m_midarm_pw26 s_m_triceps_pw26 ls_m_biceps_pw26 s_m_subscapular_pw26 s_m_suprailiac_pw26 ls_avg_weight_1sttri ls_avg_weight_2ndtri ls_avg_weight_3rdtri ls_last_antenatal_weight ///
(pmm, knn(3)) ///
accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart parity_1 m_income_0 m_occupation_0_1 f_occupation_corrected_0_1 f_monthly_income_0_1 m_place_of_birth_0_2 region ///
= m_age_recruitment ls_m_height_pw26 i.w26_quintile dim1_sq dim2_sq Dim_1 Dim_2 if m_ethnicity_0!=4 & ls_m_height_pw26!=., replace add(2) rseed(53421) by(m_ethnicity_0) dryrun
*/

mi impute chained ///
(regress) ls_m_weight_pw26 ls_m_midarm_pw26 s_m_triceps_pw26 ls_m_biceps_pw26 s_m_subscapular_pw26 s_m_suprailiac_pw26 ls_avg_weight_1sttri ls_avg_weight_2ndtri ls_avg_weight_3rdtri ls_last_antenatal_weight ls_ppbmi ///
(pmm, knn(3)) ///
accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart parity_1 m_income_0 m_occupation_0_1 f_occupation_corrected_0_1 f_monthly_income_0_1 m_place_of_birth_0_2 region ///
= m_age_recruitment s_gwg i.w26_quintile dim1_sq dim2_sq Dim_1 Dim_2 if m_ethnicity_0!=4 & s_gwg!=., replace add(10) rseed(53421) by(m_ethnicity_0, noreport)

//midiagplots accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart if m_ethnicity_0!=4 & ls_m_height_pw26!=., m(1) 

save body_measures\s_gwg, replace 

//ls_m_height_pw26 (1115)
use "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\raw_data\obj_clean_transformed_standardized", clear

merge 1:1 subjectid using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\dimensionality\dataset\mca_scores_full_cluster.dta

drop Dim_3-_merge

merge 1:1 subjectid using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\raw_data\censorship1

drop if m_age_recruitment==.

drop _merge 

//gen interaction term 
gen dim1_sq=Dim_1^2
gen dim2_sq=Dim_2^2

mi set flong 

mi register imputed accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart parity_1 m_income_0 m_occupation_0_1 f_occupation_corrected_0_1 f_monthly_income_0_1 m_place_of_birth_0_2 region ///
ls_m_weight_pw26 ls_m_midarm_pw26 s_m_triceps_pw26 ls_m_biceps_pw26 s_m_subscapular_pw26 s_m_suprailiac_pw26 ls_avg_weight_1sttri ls_avg_weight_2ndtri ls_avg_weight_3rdtri ls_last_antenatal_weight

mi register regular m_ethnicity_0 m_age_recruitment ls_m_height_pw26 w26_quintile dim1_sq dim2_sq Dim_1 Dim_2

/*
mi impute chained ///
(regress) ls_m_weight_pw26 ls_m_midarm_pw26 s_m_triceps_pw26 ls_m_biceps_pw26 s_m_subscapular_pw26 s_m_suprailiac_pw26 ls_avg_weight_1sttri ls_avg_weight_2ndtri ls_avg_weight_3rdtri ls_last_antenatal_weight ///
(pmm, knn(3)) ///
accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart parity_1 m_income_0 m_occupation_0_1 f_occupation_corrected_0_1 f_monthly_income_0_1 m_place_of_birth_0_2 region ///
= m_age_recruitment ls_m_height_pw26 i.w26_quintile dim1_sq dim2_sq Dim_1 Dim_2 if m_ethnicity_0!=4 & ls_m_height_pw26!=., replace add(2) rseed(53421) by(m_ethnicity_0) dryrun
*/

mi impute chained ///
(regress) ls_m_weight_pw26 ls_m_midarm_pw26 s_m_triceps_pw26 ls_m_biceps_pw26 s_m_subscapular_pw26 s_m_suprailiac_pw26 ls_avg_weight_1sttri ls_avg_weight_2ndtri ls_avg_weight_3rdtri ls_last_antenatal_weight ///
(pmm, knn(3)) ///
accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart parity_1 m_income_0 m_occupation_0_1 f_occupation_corrected_0_1 f_monthly_income_0_1 m_place_of_birth_0_2 region ///
= m_age_recruitment ls_m_height_pw26 i.w26_quintile dim1_sq dim2_sq Dim_1 Dim_2 if m_ethnicity_0!=4 & ls_m_height_pw26!=., replace add(10) rseed(53421) by(m_ethnicity_0, noreport)

//midiagplots accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart if m_ethnicity_0!=4 & ls_m_height_pw26!=., m(1) 

save body_measures\ls_m_height_pw26_mi_weight, replace 

//ls_m_midarm_pw26 
use "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\raw_data\obj_clean_transformed_standardized", clear

merge 1:1 subjectid using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\dimensionality\dataset\mca_scores_full_cluster.dta

drop Dim_3-_merge

merge 1:1 subjectid using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\raw_data\censorship1

drop if m_age_recruitment==.

drop _merge 

//gen interaction term 
gen dim1_sq=Dim_1^2
gen dim2_sq=Dim_2^2

mi set flong 

mi register imputed accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart parity_1 m_income_0 m_occupation_0_1 f_occupation_corrected_0_1 f_monthly_income_0_1 m_place_of_birth_0_2 region ///
ls_m_height_pw26 ls_m_weight_pw26 s_m_triceps_pw26 ls_m_biceps_pw26 s_m_subscapular_pw26 s_m_suprailiac_pw26 ls_avg_weight_1sttri ls_avg_weight_2ndtri ls_avg_weight_3rdtri ls_last_antenatal_weight

mi register regular m_ethnicity_0 m_age_recruitment ls_m_midarm_pw26 w26_quintile dim1_sq dim2_sq Dim_1 Dim_2

/*
mi impute chained ///
(regress) ls_m_height_pw26 ls_m_weight_pw26 s_m_triceps_pw26 ls_m_biceps_pw26 s_m_subscapular_pw26 s_m_suprailiac_pw26 ls_avg_weight_1sttri ls_avg_weight_2ndtri ls_avg_weight_3rdtri ls_last_antenatal_weight ///
(pmm, knn(3)) ///
accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart parity_1 m_income_0 m_occupation_0_1 f_occupation_corrected_0_1 f_monthly_income_0_1 m_place_of_birth_0_2 region ///
= m_age_recruitment ls_m_midarm_pw26 i.w26_quintile dim1_sq dim2_sq Dim_1 Dim_2 if m_ethnicity_0!=4 & ls_m_midarm_pw26!=., replace add(2) rseed(53421) by(m_ethnicity_0) dryrun
*/

mi impute chained ///
(regress) ls_m_height_pw26 ls_m_weight_pw26 s_m_triceps_pw26 ls_m_biceps_pw26 s_m_subscapular_pw26 s_m_suprailiac_pw26 ls_avg_weight_1sttri ls_avg_weight_2ndtri ls_avg_weight_3rdtri ls_last_antenatal_weight ///
(pmm, knn(3)) ///
accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart parity_1 m_income_0 m_occupation_0_1 f_occupation_corrected_0_1 f_monthly_income_0_1 m_place_of_birth_0_2 region ///
= m_age_recruitment ls_m_midarm_pw26 i.w26_quintile dim1_sq dim2_sq Dim_1 Dim_2 if m_ethnicity_0!=4 & ls_m_midarm_pw26!=., replace add(10) rseed(53421) by(m_ethnicity_0, noreport)

//midiagplots accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart if m_ethnicity_0!=4 & ls_m_midarm_pw26!=., m(1) 

save body_measures\ls_m_midarm_pw26_mi_weight, replace 

//s_m_triceps_pw26 
use "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\raw_data\obj_clean_transformed_standardized", clear

merge 1:1 subjectid using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\dimensionality\dataset\mca_scores_full_cluster.dta

drop Dim_3-_merge

merge 1:1 subjectid using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\raw_data\censorship1

drop if m_age_recruitment==.

drop _merge 

//gen interaction term 
gen dim1_sq=Dim_1^2
gen dim2_sq=Dim_2^2

mi set flong 

mi register imputed accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart parity_1 m_income_0 m_occupation_0_1 f_occupation_corrected_0_1 f_monthly_income_0_1 m_place_of_birth_0_2 region ///
ls_m_height_pw26 ls_m_weight_pw26 ls_m_midarm_pw26 ls_m_biceps_pw26 s_m_subscapular_pw26 s_m_suprailiac_pw26 ls_avg_weight_1sttri ls_avg_weight_2ndtri ls_avg_weight_3rdtri ls_last_antenatal_weight

mi register regular m_ethnicity_0 m_age_recruitment s_m_triceps_pw26 w26_quintile dim1_sq dim2_sq Dim_1 Dim_2

/*
mi impute chained ///
(regress) ls_m_height_pw26 ls_m_weight_pw26 ls_m_midarm_pw26 ls_m_biceps_pw26 s_m_subscapular_pw26 s_m_suprailiac_pw26 ls_avg_weight_1sttri ls_avg_weight_2ndtri ls_avg_weight_3rdtri ls_last_antenatal_weight ///
(pmm, knn(3)) ///
accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart parity_1 m_income_0 m_occupation_0_1 f_occupation_corrected_0_1 f_monthly_income_0_1 m_place_of_birth_0_2 region ///
= m_age_recruitment s_m_triceps_pw26  i.w26_quintile dim1_sq dim2_sq Dim_1 Dim_2 if m_ethnicity_0!=4 & s_m_triceps_pw26!=., replace add(10) rseed(53421) by(m_ethnicity_0) dryrun
*/

mi impute chained ///
(regress) ls_m_height_pw26 ls_m_weight_pw26 ls_m_midarm_pw26 ls_m_biceps_pw26 s_m_subscapular_pw26 s_m_suprailiac_pw26 ls_avg_weight_1sttri ls_avg_weight_2ndtri ls_avg_weight_3rdtri ls_last_antenatal_weight ///
(pmm, knn(3)) ///
accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart parity_1 m_income_0 m_occupation_0_1 f_occupation_corrected_0_1 f_monthly_income_0_1 m_place_of_birth_0_2 region ///
= m_age_recruitment s_m_triceps_pw26 i.w26_quintile dim1_sq dim2_sq Dim_1 Dim_2 if m_ethnicity_0!=4 & s_m_triceps_pw26!=., replace add(10) rseed(53421) by(m_ethnicity_0, noreport)

////midiagplots accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart if m_ethnicity_0!=4 & s_m_triceps_pw26!=., m(1) 

save body_measures\s_m_triceps_pw26_mi_weight, replace 

//ls_m_biceps_pw26 
use "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\raw_data\obj_clean_transformed_standardized", clear

merge 1:1 subjectid using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\dimensionality\dataset\mca_scores_full_cluster.dta

drop Dim_3-_merge

merge 1:1 subjectid using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\raw_data\censorship1

drop if m_age_recruitment==.

drop _merge 

//gen interaction term 
gen dim1_sq=Dim_1^2
gen dim2_sq=Dim_2^2

mi set flong 

mi register imputed accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart parity_1 m_income_0 m_occupation_0_1 f_occupation_corrected_0_1 f_monthly_income_0_1 m_place_of_birth_0_2 region ///
ls_m_height_pw26 ls_m_weight_pw26 ls_m_midarm_pw26 s_m_triceps_pw26 s_m_subscapular_pw26 s_m_suprailiac_pw26 ls_avg_weight_1sttri ls_avg_weight_2ndtri ls_avg_weight_3rdtri ls_last_antenatal_weight

mi register regular m_ethnicity_0 m_age_recruitment ls_m_biceps_pw26 w26_quintile dim1_sq dim2_sq Dim_1 Dim_2

/*
mi impute chained ///
(regress) ls_m_height_pw26 ls_m_weight_pw26 ls_m_midarm_pw26 s_m_triceps_pw26 s_m_subscapular_pw26 s_m_suprailiac_pw26 ls_avg_weight_1sttri ls_avg_weight_2ndtri ls_avg_weight_3rdtri ls_last_antenatal_weight ///
(pmm, knn(3)) ///
accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart parity_1 m_income_0 m_occupation_0_1 f_occupation_corrected_0_1 f_monthly_income_0_1 m_place_of_birth_0_2 region ///
= m_age_recruitment ls_m_biceps_pw26 i.w26_quintile dim1_sq dim2_sq Dim_1 Dim_2 if m_ethnicity_0!=4 & ls_m_biceps_pw26!=., replace add(10) rseed(53421) by(m_ethnicity_0) dryrun
*/

mi impute chained ///
(regress) ls_m_height_pw26 ls_m_weight_pw26 ls_m_midarm_pw26 s_m_triceps_pw26 s_m_subscapular_pw26 s_m_suprailiac_pw26 ls_avg_weight_1sttri ls_avg_weight_2ndtri ls_avg_weight_3rdtri ls_last_antenatal_weight ///
(pmm, knn(3)) ///
accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart parity_1 m_income_0 m_occupation_0_1 f_occupation_corrected_0_1 f_monthly_income_0_1 m_place_of_birth_0_2 region ///
= m_age_recruitment ls_m_biceps_pw26 i.w26_quintile dim1_sq dim2_sq Dim_1 Dim_2 if m_ethnicity_0!=4 & ls_m_biceps_pw26!=., replace add(10) rseed(53421) by(m_ethnicity_0, noreport)


////midiagplots accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart if m_ethnicity_0!=4 & ls_m_biceps_pw26!=., m(1) 

save body_measures\ls_m_biceps_pw26_mi_weight, replace 

//s_m_subscapular_pw26 
use "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\raw_data\obj_clean_transformed_standardized", clear

merge 1:1 subjectid using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\dimensionality\dataset\mca_scores_full_cluster.dta

drop Dim_3-_merge

merge 1:1 subjectid using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\raw_data\censorship1

drop if m_age_recruitment==.

drop _merge 

//gen interaction term 
gen dim1_sq=Dim_1^2
gen dim2_sq=Dim_2^2

mi set flong 

mi register imputed accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart parity_1 m_income_0 m_occupation_0_1 f_occupation_corrected_0_1 f_monthly_income_0_1 m_place_of_birth_0_2 region ///
ls_m_height_pw26 ls_m_weight_pw26 ls_m_midarm_pw26 s_m_triceps_pw26 ls_m_biceps_pw26 s_m_suprailiac_pw26 ls_avg_weight_1sttri ls_avg_weight_2ndtri ls_avg_weight_3rdtri ls_last_antenatal_weight

mi register regular m_ethnicity_0 m_age_recruitment s_m_subscapular_pw26 w26_quintile dim1_sq dim2_sq Dim_1 Dim_2

/*
mi impute chained ///
(regress) ls_m_height_pw26 ls_m_weight_pw26 ls_m_midarm_pw26 s_m_triceps_pw26 ls_m_biceps_pw26 s_m_suprailiac_pw26 ls_avg_weight_1sttri ls_avg_weight_2ndtri ls_avg_weight_3rdtri ls_last_antenatal_weight ///
(pmm, knn(3)) ///
accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart parity_1 m_income_0 m_occupation_0_1 f_occupation_corrected_0_1 f_monthly_income_0_1 m_place_of_birth_0_2 region ///
= m_age_recruitment s_m_subscapular_pw26 i.w26_quintile dim1_sq dim2_sq Dim_1 Dim_2 if m_ethnicity_0!=4 & s_m_subscapular_pw26!=., replace add(2) rseed(53421) by(m_ethnicity_0) dryrun
*/

mi impute chained ///
(regress) ls_m_height_pw26 ls_m_weight_pw26 ls_m_midarm_pw26 s_m_triceps_pw26 ls_m_biceps_pw26 s_m_suprailiac_pw26 ls_avg_weight_1sttri ls_avg_weight_2ndtri ls_avg_weight_3rdtri ls_last_antenatal_weight ///
(pmm, knn(3)) ///
accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart parity_1 m_income_0 m_occupation_0_1 f_occupation_corrected_0_1 f_monthly_income_0_1 m_place_of_birth_0_2 region ///
= m_age_recruitment s_m_subscapular_pw26 i.w26_quintile dim1_sq dim2_sq Dim_1 Dim_2 if m_ethnicity_0!=4 & s_m_subscapular_pw26!=., replace add(10) rseed(53421) by(m_ethnicity_0, noreport)

////midiagplots accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart if m_ethnicity_0!=4 & s_m_subscapular_pw26!=., m(1) 

save body_measures\s_m_subscapular_pw26_mi_weight, replace 

//s_m_suprailiac_pw26 
use "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\raw_data\obj_clean_transformed_standardized", clear

merge 1:1 subjectid using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\dimensionality\dataset\mca_scores_full_cluster.dta

drop Dim_3-_merge

merge 1:1 subjectid using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\raw_data\censorship1

drop if m_age_recruitment==.

drop _merge 

//gen interaction term 
gen dim1_sq=Dim_1^2
gen dim2_sq=Dim_2^2

mi set flong 

mi register imputed accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart parity_1 m_income_0 m_occupation_0_1 f_occupation_corrected_0_1 f_monthly_income_0_1 m_place_of_birth_0_2 region ///
ls_m_height_pw26 ls_m_weight_pw26 ls_m_midarm_pw26 s_m_triceps_pw26 ls_m_biceps_pw26 s_m_subscapular_pw26 ls_avg_weight_1sttri ls_avg_weight_2ndtri ls_avg_weight_3rdtri ls_last_antenatal_weight

mi register regular m_ethnicity_0 m_age_recruitment s_m_suprailiac_pw26 w26_quintile dim1_sq dim2_sq Dim_1 Dim_2

/*
mi impute chained ///
(regress) ls_m_height_pw26 ls_m_weight_pw26 ls_m_midarm_pw26 s_m_triceps_pw26 ls_m_biceps_pw26 s_m_subscapular_pw26 ls_avg_weight_1sttri ls_avg_weight_2ndtri ls_avg_weight_3rdtri ls_last_antenatal_weight ///
(pmm, knn(3)) ///
accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart parity_1 m_income_0 m_occupation_0_1 f_occupation_corrected_0_1 f_monthly_income_0_1 m_place_of_birth_0_2 region ///
= m_age_recruitment s_m_suprailiac_pw26 i.w26_quintile dim1_sq dim2_sq Dim_1 Dim_2 if m_ethnicity_0!=4 & s_m_suprailiac_pw26!=., replace add(2) rseed(53421) by(m_ethnicity_0) dryrun
*/

mi impute chained ///
(regress) ls_m_height_pw26 ls_m_weight_pw26 ls_m_midarm_pw26 s_m_triceps_pw26 ls_m_biceps_pw26 s_m_subscapular_pw26 ls_avg_weight_1sttri ls_avg_weight_2ndtri ls_avg_weight_3rdtri ls_last_antenatal_weight ///
(pmm, knn(3) include(s_m_suprailiac_pw26)) ///
accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart parity_1 m_income_0 m_occupation_0_1 f_occupation_corrected_0_1 f_monthly_income_0_1 m_place_of_birth_0_2 region ///
= m_age_recruitment s_m_suprailiac_pw26 i.w26_quintile dim1_sq dim2_sq Dim_1 Dim_2 if m_ethnicity_0!=4 & s_m_suprailiac_pw26!=., replace add(10) rseed(53421) by(m_ethnicity_0, noreport)

////midiagplots accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart if m_ethnicity_0!=4 & s_m_suprailiac_pw26!=., m(1) 

save body_measures\s_m_suprailiac_pw26_mi_weight, replace 

//ls_avg_weight_1sttri 
use "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\raw_data\obj_clean_transformed_standardized", clear

merge 1:1 subjectid using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\dimensionality\dataset\mca_scores_full_cluster.dta

drop Dim_3-_merge

merge 1:1 subjectid using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\raw_data\censorship1

drop if m_age_recruitment==.

drop _merge 

//gen interaction term 
gen dim1_sq=Dim_1^2
gen dim2_sq=Dim_2^2

mi set flong 

mi register imputed accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart parity_1 m_income_0 m_occupation_0_1 f_occupation_corrected_0_1 f_monthly_income_0_1 m_place_of_birth_0_2 region ///
ls_m_height_pw26 ls_m_weight_pw26 ls_m_midarm_pw26 s_m_triceps_pw26 ls_m_biceps_pw26 s_m_subscapular_pw26 s_m_suprailiac_pw26 ls_avg_weight_2ndtri ls_avg_weight_3rdtri ls_last_antenatal_weight

mi register regular m_ethnicity_0 m_age_recruitment ls_avg_weight_1sttri wdel_quintile dim1_sq dim2_sq Dim_1 Dim_2

/*
mi impute chained ///
(regress) ls_m_height_pw26 ls_m_weight_pw26 ls_m_midarm_pw26 s_m_triceps_pw26 ls_m_biceps_pw26 s_m_subscapular_pw26 s_m_suprailiac_pw26 ls_avg_weight_2ndtri ls_avg_weight_3rdtri ls_last_antenatal_weight ///
(pmm, knn(3)) ///
accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart parity_1 m_income_0 m_occupation_0_1 f_occupation_corrected_0_1 f_monthly_income_0_1 m_place_of_birth_0_2 region ///
= m_age_recruitment ls_avg_weight_1sttri i.w26_quintile dim1_sq dim2_sq Dim_1 Dim_2 if m_ethnicity_0!=4 & ls_avg_weight_1sttri!=., replace add(2) rseed(53421) by(m_ethnicity_0) dryrun
*/

mi impute chained ///
(regress) ls_m_height_pw26 ls_m_weight_pw26 ls_m_midarm_pw26 s_m_triceps_pw26 ls_m_biceps_pw26 s_m_subscapular_pw26 s_m_suprailiac_pw26 ls_avg_weight_2ndtri ls_avg_weight_3rdtri ls_last_antenatal_weight ///
(pmm, knn(3)) ///
accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart parity_1 m_income_0 m_occupation_0_1 f_occupation_corrected_0_1 f_monthly_income_0_1 m_place_of_birth_0_2 region ///
= m_age_recruitment ls_avg_weight_1sttri i.wdel_quintile dim1_sq dim2_sq Dim_1 Dim_2 if m_ethnicity_0!=4 & ls_avg_weight_1sttri!=., replace add(10) rseed(53421) by(m_ethnicity_0, noreport)


//midiagplots accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart if m_ethnicity_0!=4 & ls_avg_weight_1sttri!=., m(1) 

save body_measures\ls_avg_weight_1sttri_mi_weight, replace 

//ls_avg_weight_2ndtri 
use "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\raw_data\obj_clean_transformed_standardized", clear

merge 1:1 subjectid using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\dimensionality\dataset\mca_scores_full_cluster.dta

drop Dim_3-_merge

merge 1:1 subjectid using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\raw_data\censorship1

drop if m_age_recruitment==.

drop _merge 

//gen interaction term 
gen dim1_sq=Dim_1^2
gen dim2_sq=Dim_2^2

mi set flong 

mi register imputed accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart parity_1 m_income_0 m_occupation_0_1 f_occupation_corrected_0_1 f_monthly_income_0_1 m_place_of_birth_0_2 region ///
ls_m_height_pw26 ls_m_weight_pw26 ls_m_midarm_pw26 s_m_triceps_pw26 ls_m_biceps_pw26 s_m_subscapular_pw26 s_m_suprailiac_pw26 ls_avg_weight_1sttri ls_avg_weight_3rdtri ls_last_antenatal_weight

mi register regular m_ethnicity_0 m_age_recruitment ls_avg_weight_2ndtri wdel_quintile dim1_sq dim2_sq Dim_1 Dim_2

/*
mi impute chained ///
(regress) ls_m_height_pw26 ls_m_weight_pw26 ls_m_midarm_pw26 s_m_triceps_pw26 ls_m_biceps_pw26 s_m_subscapular_pw26 s_m_suprailiac_pw26 ls_avg_weight_1sttri ls_avg_weight_3rdtri ls_last_antenatal_weight ///
(pmm, knn(3)) ///
accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart parity_1 m_income_0 m_occupation_0_1 f_occupation_corrected_0_1 f_monthly_income_0_1 m_place_of_birth_0_2 region ///
= m_age_recruitment ls_avg_weight_2ndtri i.w26_quintile dim1_sq dim2_sq Dim_1 Dim_2 if m_ethnicity_0!=4 & ls_avg_weight_2ndtri!=., replace add(2) rseed(53421) by(m_ethnicity_0) dryrun
*/

mi impute chained ///
(regress) ls_m_height_pw26 ls_m_weight_pw26 ls_m_midarm_pw26 s_m_triceps_pw26 ls_m_biceps_pw26 s_m_subscapular_pw26 s_m_suprailiac_pw26 ls_avg_weight_1sttri ls_avg_weight_3rdtri ls_last_antenatal_weight ///
(pmm, knn(3)) ///
accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart parity_1 m_income_0 m_occupation_0_1 f_occupation_corrected_0_1 f_monthly_income_0_1 m_place_of_birth_0_2 region ///
= m_age_recruitment ls_avg_weight_2ndtri i.wdel_quintile dim1_sq dim2_sq Dim_1 Dim_2 if m_ethnicity_0!=4 & ls_avg_weight_2ndtri!=., replace add(10) rseed(53421) by(m_ethnicity_0, noreport)

//midiagplots accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart if m_ethnicity_0!=4 & ls_avg_weight_2ndtri!=., m(1) 

save body_measures\ls_avg_weight_2ndtri_mi_weight, replace 

//ls_avg_weight_3rdtri 
use "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\raw_data\obj_clean_transformed_standardized", clear

merge 1:1 subjectid using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\dimensionality\dataset\mca_scores_full_cluster.dta

drop Dim_3-_merge

merge 1:1 subjectid using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\raw_data\censorship1

drop if m_age_recruitment==.

drop _merge 

//gen interaction term 
gen dim1_sq=Dim_1^2
gen dim2_sq=Dim_2^2

mi set flong 

mi register imputed accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart parity_1 m_income_0 m_occupation_0_1 f_occupation_corrected_0_1 f_monthly_income_0_1 m_place_of_birth_0_2 region ///
ls_m_height_pw26 ls_m_weight_pw26 ls_m_midarm_pw26 s_m_triceps_pw26 ls_m_biceps_pw26 s_m_subscapular_pw26 s_m_suprailiac_pw26 ls_avg_weight_1sttri ls_avg_weight_2ndtri ls_last_antenatal_weight

mi register regular m_ethnicity_0 m_age_recruitment ls_avg_weight_3rdtri wdel_quintile dim1_sq dim2_sq Dim_1 Dim_2

/*
mi impute chained ///
(regress) ls_m_height_pw26 ls_m_weight_pw26 ls_m_midarm_pw26 s_m_triceps_pw26 ls_m_biceps_pw26 s_m_subscapular_pw26 s_m_suprailiac_pw26 ls_avg_weight_1sttri ls_avg_weight_2ndtri ls_last_antenatal_weight ///
(pmm, knn(3)) ///
accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart parity_1 m_income_0 m_occupation_0_1 f_occupation_corrected_0_1 f_monthly_income_0_1 m_place_of_birth_0_2 region ///
= m_age_recruitment ls_avg_weight_3rdtri i.w26_quintile dim1_sq dim2_sq Dim_1 Dim_2 if m_ethnicity_0!=4 & ls_avg_weight_3rdtri!=., replace add(2) rseed(53421) by(m_ethnicity_0) dryrun
*/

mi impute chained ///
(regress) ls_m_height_pw26 ls_m_weight_pw26 ls_m_midarm_pw26 s_m_triceps_pw26 ls_m_biceps_pw26 s_m_subscapular_pw26 s_m_suprailiac_pw26 ls_avg_weight_1sttri ls_avg_weight_2ndtri ls_last_antenatal_weight ///
(pmm, knn(3)) ///
accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart parity_1 m_income_0 m_occupation_0_1 f_occupation_corrected_0_1 f_monthly_income_0_1 m_place_of_birth_0_2 region ///
= m_age_recruitment ls_avg_weight_3rdtri i.wdel_quintile dim1_sq dim2_sq Dim_1 Dim_2 if m_ethnicity_0!=4 & ls_avg_weight_3rdtri!=., replace add(10) rseed(53421) by(m_ethnicity_0, noreport)

mi desc

//midiagplots accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart if m_ethnicity_0!=4 & ls_avg_weight_3rdtri!=., m(1) 

save body_measures\ls_avg_weight_3rdtri_mi_weight, replace 

//ls_last_antenatal_weight
use "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\raw_data\obj_clean_transformed_standardized", clear

merge 1:1 subjectid using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\dimensionality\dataset\mca_scores_full_cluster.dta

drop Dim_3-_merge

merge 1:1 subjectid using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\raw_data\censorship1

drop if m_age_recruitment==.

drop _merge 

//gen interaction term 
gen dim1_sq=Dim_1^2
gen dim2_sq=Dim_2^2

mi set flong 

mi register imputed accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart parity_1 m_income_0 m_occupation_0_1 f_occupation_corrected_0_1 f_monthly_income_0_1 m_place_of_birth_0_2 region ///
ls_m_height_pw26 ls_m_weight_pw26 ls_m_midarm_pw26 s_m_triceps_pw26 ls_m_biceps_pw26 s_m_subscapular_pw26 s_m_suprailiac_pw26 ls_avg_weight_1sttri ls_avg_weight_2ndtri ls_avg_weight_3rdtri

mi register regular m_ethnicity_0 m_age_recruitment wdel_quintile dim1_sq dim2_sq Dim_1 Dim_2

/*
mi impute chained ///
(regress) ls_m_height_pw26 ls_m_weight_pw26 ls_m_midarm_pw26 s_m_triceps_pw26 ls_m_biceps_pw26 s_m_subscapular_pw26 s_m_suprailiac_pw26 ls_avg_weight_1sttri ls_avg_weight_2ndtri ls_avg_weight_3rdtri ///
(pmm, knn(3)) ///
accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart parity_1 m_income_0 m_occupation_0_1 f_occupation_corrected_0_1 f_monthly_income_0_1 m_place_of_birth_0_2 region ///
= m_age_recruitment ls_last_antenatal_weight i.w26_quintile dim1_sq dim2_sq Dim_1 Dim_2 if m_ethnicity_0!=4 & ls_last_antenatal_weight!=., replace add(2) rseed(53421) by(m_ethnicity_0) dryrun
*/

mi impute chained ///
(regress) ls_m_height_pw26 ls_m_weight_pw26 ls_m_midarm_pw26 s_m_triceps_pw26 ls_m_biceps_pw26 s_m_subscapular_pw26 s_m_suprailiac_pw26 ls_avg_weight_1sttri ls_avg_weight_2ndtri ls_avg_weight_3rdtri ///
(pmm, knn(3)) ///
accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart parity_1 m_income_0 m_occupation_0_1 f_occupation_corrected_0_1 f_monthly_income_0_1 m_place_of_birth_0_2 region ///
= m_age_recruitment ls_last_antenatal_weight i.wdel_quintile dim1_sq dim2_sq Dim_1 Dim_2 if m_ethnicity_0!=4 & ls_last_antenatal_weight!=., replace add(10) rseed(53421) by(m_ethnicity_0, noreport)

mi desc

//midiagplots accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart if m_ethnicity_0!=4 & ls_last_antenatal_weight!=., m(1) 

save body_measures\ls_last_antenatal_weight_mi_weight, replace 

*minerals
*********

//min w/o tr
use "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\raw_data\blood_col_inv", clear

keep subjectid timecollected1 timecollected_cat hospital dh 

merge 1:1 subjectid using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\raw_data\obj_clean_transformed_standardized"

keep if _merge==3

drop _merge

merge 1:1 subjectid using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\dimensionality\dataset\mca_scores_full_cluster.dta"

drop Dim_3-_merge

merge 1:1 subjectid using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\raw_data\censorship1

drop if m_age_recruitment==.

drop _merge 

//gen interaction term 
gen dim1_sq=Dim_1^2
gen dim2_sq=Dim_2^2
gen th=timecollected1*hospital

mi set flong 

mi register imputed accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart parity_1 m_income_0 m_occupation_0_1 f_occupation_corrected_0_1 f_monthly_income_0_1 m_place_of_birth_0_2 region col_mo col_yr ls_mpm3tr th timecollected1

mi register regular m_ethnicity_0 m_age_recruitment ls_mpm3na ls_mpm3mg ls_mpm3p ls_mpm3k ls_mpm3ca ls_mpm3fe ls_mpm3fr ls_mpm3cu ls_mpm3zn s_mpm3se w26_quintile dim1_sq dim2_sq Dim_1 Dim_2 hospital 

mi impute chained ///
(regress) ls_mpm3tr ///
(pmm, knn(3)) ///
accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart parity_1 m_income_0 m_occupation_0_1 f_occupation_corrected_0_1 f_monthly_income_0_1 m_place_of_birth_0_2 region col_mo col_yr th timecollected1 ///
= m_age_recruitment ls_mpm3na ls_mpm3mg ls_mpm3p ls_mpm3k ls_mpm3ca ls_mpm3fe ls_mpm3fr ls_mpm3cu ls_mpm3zn s_mpm3se i.w26_quintile dim1_sq dim2_sq Dim_1 Dim_2 hospital if m_ethnicity_0!=4 & ls_mpm3na!=., replace add(10) rseed(53421) by(m_ethnicity_0, noreport) 

//midiagplots accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart if m_ethnicity_0!=4 & ls_mpm3na!=., m(1) 

save minerals\min_mi_weight, replace 

//tr
use "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\raw_data\blood_col_inv", clear

keep subjectid timecollected1 timecollected_cat hospital dh 

merge 1:1 subjectid using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\raw_data\obj_clean_transformed_standardized"

keep if _merge==3

drop _merge

merge 1:1 subjectid using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\dimensionality\dataset\mca_scores_full_cluster.dta

drop Dim_3-_merge

merge 1:1 subjectid using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\raw_data\censorship1

drop if m_age_recruitment==.

drop _merge 

//gen interaction term 
gen dim1_sq=Dim_1^2
gen dim2_sq=Dim_2^2
gen th=timecollected1*hospital

mi set flong 

mi register imputed accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart parity_1 m_income_0 m_occupation_0_1 f_occupation_corrected_0_1 f_monthly_income_0_1 m_place_of_birth_0_2 region col_mo col_yr th timecollected1 ///
ls_mpm3na ls_mpm3mg ls_mpm3p ls_mpm3k ls_mpm3ca ls_mpm3fe ls_mpm3fr ls_mpm3cu ls_mpm3zn s_mpm3se

mi register regular m_ethnicity_0 m_age_recruitment ls_mpm3tr w26_quintile dim1_sq dim2_sq Dim_1 Dim_2 hospital

mi impute chained ///
(regress) ls_mpm3na ls_mpm3mg ls_mpm3p ls_mpm3k ls_mpm3ca ls_mpm3fe ls_mpm3fr ls_mpm3cu ls_mpm3zn s_mpm3se ///
(pmm, knn(3)) ///
accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart parity_1 m_income_0 m_occupation_0_1 f_occupation_corrected_0_1 f_monthly_income_0_1 m_place_of_birth_0_2 region col_mo col_yr th timecollected1 ///
= m_age_recruitment ls_mpm3tr i.w26_quintile dim1_sq dim2_sq Dim_1 Dim_2 hospital if m_ethnicity_0!=4 & ls_mpm3tr!=., replace add(10) rseed(53421) by(m_ethnicity_0, noreport) 

//midiagplots accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart if m_ethnicity_0!=4 & ls_mpm3tr!=., m(1) 

save minerals\tr_mi_weight, replace 

*fa
******
use "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\raw_data\blood_col_inv", clear

keep subjectid timecollected1 timecollected_cat hospital dh 

merge 1:1 subjectid using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\raw_data\obj_clean_transformed_standardized"

keep if _merge==3

drop _merge

merge 1:1 subjectid using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\dimensionality\dataset\mca_scores_full_cluster.dta

drop Dim_3-_merge

merge 1:1 subjectid using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\raw_data\censorship1

drop if m_age_recruitment==.

drop _merge 

//gen interaction term 
gen dim1_sq=Dim_1^2
gen dim2_sq=Dim_2^2
gen th=timecollected1*hospital

mi set flong 

mi register imputed accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart parity_1 m_income_0 m_occupation_0_1 f_occupation_corrected_0_1 f_monthly_income_0_1 m_place_of_birth_0_2 region col_mo col_yr ls_mpm3n62 th timecollected1

mi register regular m_ethnicity_0 m_age_recruitment w26_quintile dim1_sq dim2_sq Dim_1 Dim_2 hospital

mi impute chained ///
(regress) ls_mpm3n62 ///
(pmm, knn(3)) ///
accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart parity_1 m_income_0 m_occupation_0_1 f_occupation_corrected_0_1 f_monthly_income_0_1 m_place_of_birth_0_2 region col_mo col_yr th timecollected1 ///
= m_age_recruitment ls_mpm3my ls_mpm3pal ls_mpm3pl ls_mpm3st ls_mpm3ol ls_mpm3cv ls_mpm3li ls_mpm3li6 ls_mpm3li3 ls_mpm320 ls_mpm3n9 s_mpm32n6 ls_mpm33n6 ls_mpm3ar6 ls_mpm322 ls_mpm3n3 ls_mpm3epa ls_mpm3dpa ls_mpm3tfa ls_mpm3tn3 ls_mpm3tn6 ls_mpm3sfa ls_mpm3muf ls_mpm3puf i.w26_quintile dim1_sq dim2_sq Dim_1 Dim_2 hospital if m_ethnicity_0!=4 & ls_mpm3my!=., replace add(10) rseed(53421) by(m_ethnicity_0, noreport) 

//midiagplots accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart if m_ethnicity_0!=4 & ls_mpm3my!=., m(1) 

save fa_mi_weight, replace 

*vit
*****

//all other vit b (980)
use "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\raw_data\blood_col_inv", clear

keep subjectid timecollected1 timecollected_cat hospital dh 

merge 1:1 subjectid using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\raw_data\obj_clean_transformed_standardized"

keep if _merge==3

drop _merge

merge 1:1 subjectid using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\dimensionality\dataset\mca_scores_full_cluster.dta

drop Dim_3-_merge

merge 1:1 subjectid using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\raw_data\censorship1

drop if m_age_recruitment==.

drop _merge 

//gen interaction term 
gen dim1_sq=Dim_1^2
gen dim2_sq=Dim_2^2
gen th=timecollected1*hospital

mi set flong 

mi register imputed accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart m_income_0 m_occupation_0_1 f_occupation_corrected_0_1 f_monthly_income_0_1 m_place_of_birth_0_2 col_mo col_yr  s_mpm3vd3 parity_1 region ls_mpm3fo ls_mpm3b12p th timecollected1

mi register regular m_ethnicity_0 m_age_recruitment ls_mpm3fmn2 ls_mpm3neo2 ls_mpm3ribo2 ls_mpm3mnam2 ls_mpm3nam2 ls_mpm3trig2 ls_mpm3py2 ls_mpm3plpb2 ls_mpm3pabe2 w26_quintile dim1_sq dim2_sq Dim_1 Dim_2 hospital

/*
mi impute chained ///
(regress) ls_mpm3fo ls_mpm3b12p s_mpm3vd3 ///
(pmm, knn(3)) ///
accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart m_income_0 m_occupation_0_1 f_occupation_corrected_0_1 f_monthly_income_0_1 m_place_of_birth_0_2 col_mo col_yr parity_1 region ///
= m_age_recruitment ls_mpm3fmn2 ls_mpm3neo2 ls_mpm3ribo2 ls_mpm3mnam2 ls_mpm3nam2 ls_mpm3trig2 ls_mpm3py2 ls_mpm3plpb2 ls_mpm3pabe2 i.w26_quintile dim1_sq dim2_sq Dim_1 Dim_2 if m_ethnicity_0!=4 & ls_mpm3fmn2!=., replace add(10) rseed(53421) by(m_ethnicity_0) dryrun
*/

*only missing for malay not chinese and indian: ls_mpm3fo ls_mpm3b12p parity_1 region
mi impute chained ///
(regress) ls_mpm3fo ls_mpm3b12p s_mpm3vd3 ///
(pmm, knn(3)) ///
accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart m_income_0 m_occupation_0_1 f_occupation_corrected_0_1 f_monthly_income_0_1 m_place_of_birth_0_2 col_mo col_yr parity_1 region th timecollected1 ///
= m_age_recruitment ls_mpm3fmn2 ls_mpm3neo2 ls_mpm3ribo2 ls_mpm3mnam2 ls_mpm3nam2 ls_mpm3trig2 ls_mpm3py2 ls_mpm3plpb2 ls_mpm3pabe2 i.w26_quintile dim1_sq dim2_sq Dim_1 Dim_2 hospital if m_ethnicity_0!=4 & ls_mpm3fmn2!=., replace add(10) rseed(53421) by(m_ethnicity_0, noreport) 

//midiagplots accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart if m_ethnicity_0!=4 & ls_mpm3fmn2!=., m(1) 

save vit\vitb_mi_weight, replace 

//folate and b12
use "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\raw_data\blood_col_inv", clear

keep subjectid timecollected1 timecollected_cat hospital dh 

merge 1:1 subjectid using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\raw_data\obj_clean_transformed_standardized"

keep if _merge==3

drop _merge

merge 1:1 subjectid using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\dimensionality\dataset\mca_scores_full_cluster.dta

drop Dim_3-_merge

merge 1:1 subjectid using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\raw_data\censorship1

drop if m_age_recruitment==.

drop _merge 

//gen interaction term 
gen dim1_sq=Dim_1^2
gen dim2_sq=Dim_2^2
gen th=timecollected1*hospital

mi set flong 

mi register imputed accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart m_income_0 m_occupation_0_1 f_occupation_corrected_0_1 f_monthly_income_0_1 m_place_of_birth_0_2  col_mo col_yr ls_mpm3fmn2 ls_mpm3neo2 ls_mpm3ribo2 ls_mpm3mnam2 ls_mpm3nam2 ls_mpm3trig2 ls_mpm3py2 ls_mpm3plpb2 ls_mpm3pabe2 s_mpm3vd3 th timecollected1

mi register regular m_ethnicity_0 m_age_recruitment ls_mpm3fo ls_mpm3b12p parity_1 region w26_quintile dim1_sq dim2_sq Dim_1 Dim_2 hospital 

/*
mi impute chained ///
(regress) ls_mpm3fmn2 ls_mpm3neo2 ls_mpm3ribo2 ls_mpm3mnam2 ls_mpm3nam2 ls_mpm3nia2 ls_mpm3trig2 ls_mpm3py2 ls_mpm3plpb2  ls_mpm3pabe2 s_mpm3vd3 ///
(pmm, knn(3)) ///
accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart parity_1 m_income_0 m_occupation_0_1 f_occupation_corrected_0_1 f_monthly_income_0_1 m_place_of_birth_0_2 region col_mo col_yr ///
= m_age_recruitment ls_mpm3fo ls_mpm3b12p i.w26_quintile dim1_sq dim2_sq Dim_1 Dim_2 if m_ethnicity_0!=4 & ls_mpm3fo!=., replace add(10) rseed(53421) by(m_ethnicity_0) dryrun
*/

*not missing parity and region 
mi impute chained ///
(regress) ls_mpm3fmn2 ls_mpm3neo2 ls_mpm3ribo2 ls_mpm3mnam2 ls_mpm3nam2 ls_mpm3trig2 ls_mpm3py2 ls_mpm3plpb2 ls_mpm3pabe2 s_mpm3vd3 ///
(pmm, knn(3)) ///
accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart m_income_0 m_occupation_0_1 f_occupation_corrected_0_1 f_monthly_income_0_1 m_place_of_birth_0_2 col_mo col_yr th timecollected1 ///
= m_age_recruitment ls_mpm3fo ls_mpm3b12p parity_1 region i.w26_quintile dim1_sq dim2_sq Dim_1 Dim_2 hospital if m_ethnicity_0!=4 & ls_mpm3fo!=., replace add(10) rseed(53421) by(m_ethnicity_0, noreport) 

//midiagplots accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart if m_ethnicity_0!=4 & ls_mpm3fo!=., m(1) 

save vit\fo_mi_weight, replace 

//vd3
use "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\raw_data\blood_col_inv", clear

keep subjectid timecollected1 timecollected_cat hospital dh 

merge 1:1 subjectid using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\raw_data\obj_clean_transformed_standardized"

keep if _merge==3

drop _merge

merge 1:1 subjectid using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\dimensionality\dataset\mca_scores_full_cluster.dta

drop Dim_3-_merge

merge 1:1 subjectid using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\raw_data\censorship1

drop if m_age_recruitment==.

drop _merge 

//gen interaction term 
gen dim1_sq=Dim_1^2
gen dim2_sq=Dim_2^2
gen th=timecollected1*hospital

mi set flong 

mi register imputed accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart parity_1 m_income_0 m_occupation_0_1 f_occupation_corrected_0_1 f_monthly_income_0_1 m_place_of_birth_0_2 region col_mo col_yr ls_mpm3fmn2 ls_mpm3neo2 ls_mpm3ribo2 ls_mpm3mnam2 ls_mpm3nam2 ls_mpm3trig2 ls_mpm3py2 ls_mpm3plpb2  ls_mpm3pabe2 ls_mpm3fo ls_mpm3b12p th timecollected1

mi register regular m_ethnicity_0 m_age_recruitment s_mpm3vd3 w26_quintile dim1_sq dim2_sq Dim_1 Dim_2 hospital 

/*
mi impute chained ///
(regress) ls_mpm3fmn2 ls_mpm3neo2 ls_mpm3ribo2 ls_mpm3mnam2 ls_mpm3nam2 ls_mpm3trig2 ls_mpm3py2 ls_mpm3plpb2  ls_mpm3pabe2 ls_mpm3fo ls_mpm3b12p ///
(pmm, knn(3)) ///
accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart parity_1 m_income_0 m_occupation_0_1 f_occupation_corrected_0_1 f_monthly_income_0_1 m_place_of_birth_0_2 region col_mo col_yr ///
= m_age_recruitment s_mpm3vd3 i.w26_quintile dim1_sq dim2_sq Dim_1 Dim_2 if m_ethnicity_0!=4 & s_mpm3vd3!=., replace add(10) rseed(53421) by(m_ethnicity_0) dryrun
*/

mi impute chained ///
(regress) ls_mpm3fmn2 ls_mpm3neo2 ls_mpm3ribo2 ls_mpm3mnam2 ls_mpm3nam2 ls_mpm3trig2 ls_mpm3py2 ls_mpm3plpb2  ls_mpm3pabe2 ls_mpm3fo ls_mpm3b12p ///
(pmm, knn(3)) ///
accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart parity_1 m_income_0 m_occupation_0_1 f_occupation_corrected_0_1 f_monthly_income_0_1 m_place_of_birth_0_2 region col_mo col_yr th timecollected1 ///
= m_age_recruitment s_mpm3vd3 i.w26_quintile dim1_sq dim2_sq Dim_1 Dim_2 hospital if m_ethnicity_0!=4 & s_mpm3vd3!=., replace add(10) rseed(53421) by(m_ethnicity_0, noreport nostop)

//midiagplots accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart if m_ethnicity_0!=4 & s_mpm3vd3!=., m(1) 

save vit\vd3_mi_weight, replace 

*aa
****
use "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\raw_data\blood_col_inv", clear

keep subjectid timecollected1 timecollected_cat hospital dh 

merge 1:1 subjectid using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\raw_data\obj_clean_transformed_standardized"

keep if _merge==3

drop _merge

merge 1:1 subjectid using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\dimensionality\dataset\mca_scores_full_cluster.dta

drop Dim_3-_merge

merge 1:1 subjectid using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\raw_data\censorship1

drop if m_age_recruitment==.

drop _merge 

//gen interaction term 
gen dim1_sq=Dim_1^2
gen dim2_sq=Dim_2^2
gen th=timecollected1*hospital

mi set flong 

mi register imputed accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart parity_1 m_income_0 m_occupation_0_1 f_occupation_corrected_0_1 f_monthly_income_0_1 m_place_of_birth_0_2 region col_mo col_yr th timecollected1 ///
ls_mpm3arg2 ls_mpm3adma2 s_mpm3crn2 s_mpm3crea2 ls_mpm3harg2 ls_mpm3sdma2 ls_mpm3tml2 ls_mpm3hcy2 s_mpm3tcys2 ls_mpm3m1hs2 ls_mpm3m3hs2 ls_mpm3hist2 ls_mpm3met2 ls_mpm3mtso2

mi register regular m_ethnicity_0 m_age_recruitment ls_mpm3csta2 ls_mpm3haa2 ls_mpm3hk2 ls_mpm3aa2 ls_mpm3ka2 ls_mpm3kyn2 ls_mpm3qa2 s_mpm3trp2 ls_mpm3xa2 hospital 

mi impute chained ///
(regress) ls_mpm3arg2 ls_mpm3adma2 s_mpm3crn2 s_mpm3crea2 ls_mpm3harg2 ls_mpm3sdma2 ls_mpm3tml2 ls_mpm3hcy2 s_mpm3tcys2 ls_mpm3m1hs2 ls_mpm3m3hs2 ls_mpm3hist2 ls_mpm3met2 ls_mpm3mtso2 ///
(pmm, knn(3)) ///
accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart parity_1 m_income_0 m_occupation_0_1 f_occupation_corrected_0_1 f_monthly_income_0_1 m_place_of_birth_0_2 region col_mo col_yr timecollected1 th ///
= m_age_recruitment ls_mpm3csta2 ls_mpm3haa2 ls_mpm3hk2 ls_mpm3aa2 ls_mpm3ka2 ls_mpm3kyn2 ls_mpm3qa2 s_mpm3trp2 ls_mpm3xa2 i.w26_quintile dim1_sq dim2_sq Dim_1 Dim_2 hospital if m_ethnicity_0!=4 & ls_mpm3csta2!=., replace add(10) rseed(53421) by(m_ethnicity_0, noreport) 

//midiagplots accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart if m_ethnicity_0!=4 & ls_mpm3csta2!=., m(1) 

save aa_mi_weight, replace 

*choline
*********
use "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\raw_data\blood_col_inv", clear

keep subjectid timecollected1 timecollected_cat hospital dh 

merge 1:1 subjectid using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\raw_data\obj_clean_transformed_standardized"

keep if _merge==3

drop _merge

merge 1:1 subjectid using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\dimensionality\dataset\mca_scores_full_cluster.dta

drop Dim_3-_merge

merge 1:1 subjectid using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\raw_data\censorship1

drop if m_age_recruitment==.

drop _merge 

//gen interaction term 
gen dim1_sq=Dim_1^2
gen dim2_sq=Dim_2^2
gen th=timecollected1*hospital

mi set flong 

mi register imputed accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart parity_1 m_income_0 m_occupation_0_1 f_occupation_corrected_0_1 f_monthly_income_0_1 m_place_of_birth_0_2 region col_mo col_yr timecollected1 th

mi register regular m_ethnicity_0 m_age_recruitment ls_mpm3betn2 ls_mpm3chol2 ls_mpm3dmg2 ls_mpm3tmao2 w26_quintile dim1_sq dim2_sq Dim_1 Dim_2 hospital

mi impute chained (pmm, knn(3)) ///
accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart parity_1 m_income_0 m_occupation_0_1 f_occupation_corrected_0_1 f_monthly_income_0_1 m_place_of_birth_0_2 region col_mo col_yr th timecollected1 ///
= m_age_recruitment ls_mpm3betn2 ls_mpm3chol2 ls_mpm3dmg2 ls_mpm3tmao2 i.w26_quintile dim1_sq dim2_sq Dim_1 Dim_2 hospital if m_ethnicity_0!=4 & ls_mpm3betn2!=., replace add(10) rseed(53421) by(m_ethnicity_0, noreport) 

//midiagplots accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart if m_ethnicity_0!=4 & ls_mpm3betn2!=., m(1) 

save choline_mi_weight, replace 

*glu
*****
use "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\raw_data\obj_clean_transformed_standardized", clear

merge 1:1 subjectid using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\dimensionality\dataset\mca_scores_full_cluster.dta

drop Dim_3-_merge

merge 1:1 subjectid using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\raw_data\censorship1

drop if m_age_recruitment==.

drop _merge 

//gen interaction term 
gen dim1_sq=Dim_1^2
gen dim2_sq=Dim_2^2

mi set flong 

mi register imputed accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart parity_1 m_income_0 m_occupation_0_1 f_occupation_corrected_0_1 f_monthly_income_0_1 m_place_of_birth_0_2 region col_mo col_yr

mi register regular m_ethnicity_0 m_age_recruitment ls_m_ogtt_fasting_pw26 ls_m_ogtt_2hour_pw26 w26_quintile dim1_sq dim2_sq Dim_1 Dim_2

mi impute chained (pmm, knn(3)) ///
accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart parity_1 m_income_0 m_occupation_0_1 f_occupation_corrected_0_1 f_monthly_income_0_1 m_place_of_birth_0_2 region col_mo col_yr ///
= m_age_recruitment ls_m_ogtt_fasting_pw26  ls_m_ogtt_2hour_pw26 i.w26_quintile dim1_sq dim2_sq Dim_1 Dim_2 if m_ethnicity_0!=4 & ls_m_ogtt_fasting_pw26!=., replace add(10) rseed(53421) by(m_ethnicity_0, noreport) 

//midiagplots accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart if m_ethnicity_0!=4 & ls_m_ogtt_fasting_pw26!=., m(1) 

save glu_mi_weight, replace 

*air_pollutants
*****************

// PSI
use "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\raw_data\obj_clean_transformed_standardized", clear

merge 1:1 subjectid using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\dimensionality\dataset\mca_scores_full_cluster.dta

drop Dim_3-_merge

merge 1:1 subjectid using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\raw_data\censorship1

drop if m_age_recruitment==.

drop _merge 

//gen interaction term 
gen dim1_sq=Dim_1^2
gen dim2_sq=Dim_2^2

mi set flong 

mi register imputed accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart parity_1 m_income_0 m_occupation_0_1 f_occupation_corrected_0_1 f_monthly_income_0_1 m_place_of_birth_0_2 region dob_mo dob_yr s_pm25_1st s_pm25_2nd s_pm25_3rd s_pm25_avg_daily_1

mi register regular m_ethnicity_0 m_age_recruitment s_psi_tri1 s_psi_tri2 s_psi_tri3 s_psi_pregnancy wdel_quintile dim1_sq dim2_sq Dim_1 Dim_2

mi impute chained ///
(regress) s_pm25_1st s_pm25_2nd s_pm25_3rd s_pm25_avg_daily_1 ///
(pmm, knn(3)) ///
accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart parity_1 m_income_0 m_occupation_0_1 f_occupation_corrected_0_1 f_monthly_income_0_1 m_place_of_birth_0_2 region dob_mo dob_yr ///
= m_age_recruitment s_psi_tri1 s_psi_tri2 s_psi_tri3 s_psi_pregnancy i.wdel_quintile dim1_sq dim2_sq Dim_1 Dim_2 if m_ethnicity_0!=4 & s_psi_tri1!=., replace add(10) rseed(53421) by(m_ethnicity_0, noreport)

//midiagplots accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart  if m_ethnicity_0!=4 & s_psi_tri1!=., m(1) 

save air_pollutants\psi_mi_weight, replace 


//PM2.5
use "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\raw_data\obj_clean_transformed_standardized", clear

merge 1:1 subjectid using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\dimensionality\dataset\mca_scores_full_cluster.dta

drop Dim_3-_merge

merge 1:1 subjectid using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\raw_data\censorship1

drop if m_age_recruitment==.

drop _merge 

//gen interaction term 
gen dim1_sq=Dim_1^2
gen dim2_sq=Dim_2^2

mi set flong 

mi register imputed accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart parity_1 m_income_0 m_occupation_0_1 f_occupation_corrected_0_1 f_monthly_income_0_1 m_place_of_birth_0_2 region dob_mo dob_yr s_psi_tri1 s_psi_tri2 s_psi_tri3 s_psi_pregnancy s_pm25_3rd

mi register regular m_ethnicity_0 m_age_recruitment s_pm25_1st s_pm25_2nd s_pm25_avg_daily_1 wdel_quintile dim1_sq dim2_sq Dim_1 Dim_2

mi impute chained ///
(regress) s_psi_tri1 s_psi_tri2 s_psi_tri3 s_psi_pregnancy s_pm25_3rd ///
(pmm, knn(3)) ///
accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart parity_1 m_income_0 m_occupation_0_1 f_occupation_corrected_0_1 f_monthly_income_0_1 m_place_of_birth_0_2 region dob_mo dob_yr ///
= m_age_recruitment s_pm25_1st s_pm25_2nd s_pm25_avg_daily_1 i.wdel_quintile dim1_sq dim2_sq Dim_1 Dim_2 if m_ethnicity_0!=4 & s_pm25_1st!=., replace add(10) rseed(53421) by(m_ethnicity_0, noreport)

//midiagplots accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart if m_ethnicity_0!=4 & s_pm25_1st!=., m(1) 

save air_pollutants\pm25_mi_weight, replace 

log close 

	  