/* e:\sumkk\ses-exposome\data\raw_data\
DO file e:\sumkk\ses-exposome\data\do_files\MI_pfas_corrected
Multiple imputation 
27 Jan 2021, Ka Kei Sum
Dataset: 
  e:\sumkk\ses-exposome\data\raw_data\pfas_corrected_merged (1193 vars, 1,344 obs)
*/

cd "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\raw_data"
capture log close  
log using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\log_files\mi_pfas_corrected_weight.log", replace 
set more off

use pfas_corrected_merged, clear

merge 1:1 subjectid using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\dimensionality\dataset\mca_scores_full_cluster.dta"

drop Dim_3-_merge

merge 1:1 subjectid using censorship1

drop _merge

drop if m_age_recruitment==.

//gen interaction term 
gen dim1_sq=Dim_1^2
gen dim2_sq=Dim_2^2

//exclude pfdoda pfpea pfhxa (too much LOD and LOQ)

//generate interval 
//LOD 
foreach var of varlist pfba-pfda pfhpa pfhxs-pfos pfunda {
    gen ll_log2_`var'=log2_`var'
}

gen ul_log2_pfba=log2_pfba
replace ul_log2_pfba=log(0.41/1.5)/log(2) if log2_pfba==. & pfba_lod_loq!=. 

gen ul_log2_pfhpa=log2_pfhpa
replace ul_log2_pfhpa=log(0.05/1.5)/log(2) if log2_pfhpa==. & pfhpa_lod_loq!=. 

gen ul_log2_pfoa=log2_pfoa
replace ul_log2_pfoa=log(0.009/1.5)/log(2) if log2_pfoa==. & pfoa_lod_loq!=. 

gen ul_log2_pfna=log2_pfna
replace ul_log2_pfna=log(0.016/1.5)/log(2) if log2_pfna==. & pfna_lod_loq!=.

gen ul_log2_pfda=log2_pfda
replace ul_log2_pfda=log(0.01/1.5)/log(2) if log2_pfda==. & pfda_lod_loq!=. 

gen ul_log2_pfunda=log2_pfunda
replace ul_log2_pfunda=log(0.011/1.5)/log(2) if log2_pfunda==. & pfunda_lod_loq!=. 

gen ul_log2_pfbs=log2_pfbs // no LOD
replace ul_log2_pfbs=log(0.078/1.5)/log(2) if log2_pfbs==. & pfbs_lod_loq!=. 

gen ul_log2_pfhxs=log2_pfhxs
replace ul_log2_pfhxs=log(0.024/1.5)/log(2) if log2_pfhxs==. & pfhxs_lod_loq!=.

gen ul_log2_pfos=log2_pfos
replace ul_log2_pfos=log(0.027/1.5)/log(2) if log2_pfos==. & pfos_lod_loq!=.

//LOQ
gen lloq_log2_pfba=log2_pfba
replace lloq_log2_pfba=log(0.41/1.5)/log(2) if log2_pfba==. & pfba_lod_loq!=.

gen lloq_log2_pfhpa=log2_pfhpa
replace lloq_log2_pfhpa=log(0.05/1.5)/log(2) if log2_pfhpa==. & pfhpa_lod_loq!=.

gen lloq_log2_pfoa=log2_pfoa // no LOQ
replace lloq_log2_pfoa=log(0.009/1.5)/log(2) if log2_pfoa==. & pfoa_lod_loq!=. 

gen lloq_log2_pfna=log2_pfna // no LOQ
replace lloq_log2_pfna=log(0.016/1.5)/log(2) if log2_pfna==. & pfna_lod_loq!=. 

gen lloq_log2_pfda=log2_pfda // no LOQ
replace lloq_log2_pfda=log(0.01/1.5)/log(2) if log2_pfda==. & pfda_lod_loq!=. 

gen lloq_log2_pfunda=log2_pfunda
replace lloq_log2_pfunda=log(0.011/1.5)/log(2) if log2_pfunda==. & pfunda_lod_loq!=. 

gen lloq_log2_pfbs=log2_pfbs
replace lloq_log2_pfbs=log(0.078/1.5)/log(2) if log2_pfbs==. & pfbs_lod_loq!=. 

gen lloq_log2_pfhxs=log2_pfhxs
replace lloq_log2_pfhxs=log(0.024/1.5)/log(2) if log2_pfhxs==. & pfhxs_lod_loq!=. 

gen lloq_log2_pfos=log2_pfos // no LOQ
replace lloq_log2_pfos=log(0.027/1.5)/log(2) if log2_pfos==. & pfos_lod_loq!=. 


gen uloq_log2_pfba=log2_pfba
replace uloq_log2_pfba=log(0.5/1.5)/log(2) if log2_pfba==. & pfba_lod_loq!=. 

gen uloq_log2_pfhpa=log2_pfhpa
replace uloq_log2_pfhpa=log(0.1/1.5)/log(2) if log2_pfhpa==. & pfhpa_lod_loq!=. 

gen uloq_log2_pfoa=log2_pfoa // no LOQ
replace uloq_log2_pfoa=log(0.1/1.5)/log(2) if log2_pfoa==. & pfoa_lod_loq!=.

gen uloq_log2_pfna=log2_pfna // no LOQ
replace uloq_log2_pfna=log(0.1/1.5)/log(2) if log2_pfna==. & pfna_lod_loq!=. 

gen uloq_log2_pfda=log2_pfda // no LOQ
replace uloq_log2_pfda=log(0.1/1.5)/log(2) if log2_pfda==. & pfda_lod_loq!=. 

gen uloq_log2_pfunda=log2_pfunda
replace uloq_log2_pfunda=log(0.1/1.5)/log(2) if log2_pfunda==. & pfunda_lod_loq!=.

gen uloq_log2_pfbs=log2_pfbs
replace uloq_log2_pfbs=log(5/1.5)/log(2) if log2_pfbs==. & pfbs_lod_loq!=. 

gen uloq_log2_pfhxs=log2_pfhxs
replace uloq_log2_pfhxs=log(0.1/1.5)/log(2) if log2_pfhxs==. & pfhxs_lod_loq!=. 

gen uloq_log2_pfos=log2_pfos // no LOQ
replace uloq_log2_pfos=log(0.1/1.5)/log(2) if log2_pfos==. & pfos_lod_loq!=. 

//MI
mi set flong 

mi register imputed log2_pfba-log2_pfda log2_pfhxs-log2_pfos log2_pfunda ///
accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart m_place_of_birth_0_2 m_income_0 m_occupation_0_1 region f_occupation_corrected_0_1 f_monthly_income_0_1 

mi register regular m_ethnicity_0 m_age_recruitment dob_mo dob_yr parity_1 wdel_quintile dim1_sq dim2_sq Dim_1 Dim_2

mi impute chained ///
(intreg, ll(ll_log2_pfba) ul(ul_log2_pfba)) log2_pfba_mi ///
(intreg, ll(ll_log2_pfoa) ul(ul_log2_pfoa)) log2_pfoa_mi ///
(intreg, ll(ll_log2_pfna) ul(ul_log2_pfna)) log2_pfna_mi ///
(intreg, ll(ll_log2_pfda) ul(ul_log2_pfda)) log2_pfda_mi ///
(intreg, ll(lloq_log2_pfunda) ul(uloq_log2_pfunda)) log2_pfunda_mi ///
(intreg, ll(ll_log2_pfhxs) ul(ul_log2_pfhxs)) log2_pfhxs_mi ///
(intreg, ll(ll_log2_pfos) ul(ul_log2_pfos)) log2_pfos_mi ///
(intreg, ll(lloq_log2_pfbs) ul(uloq_log2_pfbs)) log2_pfbs_mi2 ///
(pmm, knn(3)) accommodation_0_2 m_highest_education_0_1 f_education_corrected_0_1 household_income_0_1 sai_quart sedi_quart m_income_0 m_occupation_0_1 m_place_of_birth_0_2 region f_occupation_corrected_0_1 f_monthly_income_0_1 ///
= m_age_recruitment dob_mo dob_yr parity_1 if m_ethnicity_0!=4 & pfba_lod_loq!=., replace add(5) rseed(53421) by(m_ethnicity_0 wdel_quintile) dryrun

mi impute chained ///
(intreg, ll(ll_log2_pfba) ul(ul_log2_pfba)) log2_pfba_mi ///
(intreg, ll(ll_log2_pfoa) ul(ul_log2_pfoa)) log2_pfoa_mi ///
(intreg, ll(ll_log2_pfna) ul(ul_log2_pfna)) log2_pfna_mi ///
(intreg, ll(ll_log2_pfda) ul(ul_log2_pfda)) log2_pfda_mi ///
(intreg, ll(lloq_log2_pfunda) ul(uloq_log2_pfunda)) log2_pfunda_mi ///
(intreg, ll(ll_log2_pfhxs) ul(ul_log2_pfhxs)) log2_pfhxs_mi ///
(intreg, ll(ll_log2_pfos) ul(ul_log2_pfos)) log2_pfos_mi ///
(intreg, ll(lloq_log2_pfbs) ul(uloq_log2_pfbs)) log2_pfbs_mi ///
(pmm, knn(3)) accommodation_0_2 m_highest_education_0_1 f_education_corrected_0_1 household_income_0_1 sai_quart sedi_quart m_income_0 m_occupation_0_1 m_place_of_birth_0_2 region f_occupation_corrected_0_1 f_monthly_income_0_1 ///
= m_age_recruitment dob_mo dob_yr parity_1 dim1_sq dim2_sq Dim_1 Dim_2 i.wdel_quintile if m_ethnicity_0!=4 & pfba_lod_loq!=., replace add(10) rseed(53421) by(m_ethnicity_0, noreport) force 
 
midiagplots log2_pfba_mi log2_pfunda_mi log2_pfhxs_mi log2_pfos_mi

midiagplots accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart if m_ethnicity_0!=4 & pfba_lod_loq!=., m(1) 

save "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\mi_data\pfas_mi_corrected_weight", replace 

//convergence diagnostics
mi impute chained ///
(intreg, ll(ll_log2_pfba) ul(ul_log2_pfba)) log2_pfba_mi ///
(intreg, ll(ll_log2_pfoa) ul(ul_log2_pfoa)) log2_pfoa_mi ///
(intreg, ll(ll_log2_pfna) ul(ul_log2_pfna)) log2_pfna_mi ///
(intreg, ll(ll_log2_pfda) ul(ul_log2_pfda)) log2_pfda_mi ///
(intreg, ll(lloq_log2_pfunda) ul(uloq_log2_pfunda)) log2_pfunda_mi ///
(intreg, ll(ll_log2_pfhxs) ul(ul_log2_pfhxs)) log2_pfhxs_mi ///
(intreg, ll(ll_log2_pfos) ul(ul_log2_pfos)) log2_pfos_mi ///
(intreg, ll(lloq_log2_pfbs) ul(uloq_log2_pfbs)) log2_pfbs_mi ///
(pmm, knn(3)) accommodation_0_2 m_highest_education_0_1 f_education_corrected_0_1 household_income_0_1 sai_quart sedi_quart m_income_0 m_occupation_0_1 m_place_of_birth_0_2 region f_occupation_corrected_0_1 f_monthly_income_0_1 ///
= m_age_recruitment dob_mo dob_yr parity_1 if m_ethnicity_0!=4 & pfba_lod_loq!=., add(3) burnin(100) savetrace("C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\mi_data\convergence\impstats\pfas_corrected", replace) rseed(53421)

use "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\mi_data\convergence\impstats\pfas_corrected", clear
desc
rename f_occupation_corrected_0_1_mean f_occupation_corr_0_1_mean 
reshape wide *mean *sd, i(iter) j(m)
tsset iter

tsline log2_pfba_mi_mean*, name(log2_pfba_mi_mean,replace) legend(off) ytitle("log2_pfba_mi mean")
tsline log2_pfba_mi_sd*, name(log2_pfba_mi_sd, replace) legend(off) ytitle("log2_pfba_mi sd")

tsline log2_pfunda_mi_mean*, name(log2_pfunda_mi_mean,replace) legend(off) ytitle("log2_pfunda_mi mean")
tsline log2_pfunda_mi_sd*, name(log2_pfunda_mi_sd, replace) legend(off) ytitle("log2_pfunda_mi sd")

tsline log2_pfhxs_mi_mean*, name(log2_pfhxs_mi_mean,replace) legend(off) ytitle("log2_pfhxs_mi mean")
tsline log2_pfhxs_mi_sd*, name(log2_pfhxs_mi_sd, replace) legend(off) ytitle("log2_pfhxs_mi sd")

tsline accommodation_0_2_mean*, name(accommodation_0_2_mean,replace) legend(off) ytitle("accommodation_0_2 mean")
tsline accommodation_0_2_sd*, name(accommodation_0_2_sd, replace) legend(off) ytitle("accommodation_0_2 sd")
tsline m_highest_education_0_1_mean*, name(m_highest_education_0_1_mean,replace) legend(off) ytitle("m_highest_education_0_1 mean")
tsline m_highest_education_0_1_sd*, name(m_highest_education_0_1_sd, replace) legend(off) ytitle("m_highest_education_0_1 sd")
tsline household_income_0_1_mean*, name(household_income_0_1_mean, replace) legend(off) ytitle("household_income_0_1 mean")
tsline household_income_0_1_sd*, name(household_income_0_1_sd, replace) legend(off) ytitle("household_income_0_1 sd")
tsline household_income_0_1_mean*, name(f_education_corrected_0_1_mean, replace) legend(off) ytitle("f_education_corrected_0_1 mean")
tsline household_income_0_1_sd*, name(f_education_corrected_0_1_sd, replace) legend(off) ytitle("f_education_corrected_0_1 sd")
tsline household_income_0_1_mean*, name(sai_quart_mean, replace) legend(off) ytitle("sai_quart mean")
tsline household_income_0_1_sd*, name(sai_quart_sd, replace) legend(off) ytitle("sai_quart sd")
tsline household_income_0_1_mean*, name(sedi_quart_mean, replace) legend(off) ytitle("sedi_quart mean")
tsline household_income_0_1_sd*, name(sedi_quart_sd, replace) legend(off) ytitle("sedi_quart sd")

graph combine log2_pfba_mi_mean log2_pfba_mi_sd ///
log2_pfunda_mi_mean log2_pfunda_mi_sd ///
log2_pfhxs_mi_mean log2_pfhxs_mi_sd 

graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\mi_data\convergence\graphs\pfas/pfas_mi_corrected.png", replace

graph combine accommodation_0_2_mean accommodation_0_2_sd ///
m_highest_education_0_1_mean m_highest_education_0_1_sd 

graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\mi_data\convergence\graphs\pfas/acc_medu_corrected.png", replace

graph combine household_income_0_1_mean household_income_0_1_sd ///
f_education_corrected_0_1_mean f_education_corrected_0_1_sd 

graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\mi_data\convergence\graphs\pfas/hh_income_fedu_corrected.png", replace

graph combine sai_quart_mean sai_quart_sd ///
sedi_quart_mean sedi_quart_sd

graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\mi_data\convergence\graphs\pfas/sai_sedi_corrected.png", replace


log close 



