/* e:\sumkk\ses-exposome\data\raw_data\
DO file e:\sumkk\ses-exposome\data\do_files\obj_clean_transformed_standardized
Multiple imputation 
28 Jan 2021, Ka Kei Sum
Dataset: 
  e:\sumkk\ses-exposome\data\raw_data\obj_clean_transformed_standardized (1193 vars, 1,344 obs)
*/

cd "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\raw_data"
capture log close  
log using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\log_files\mi_luminex_weight.log", replace 
set more off

use blood_col_inv, clear

keep subjectid timecollected1 timecollected_cat hospital dh 

merge 1:1 subjectid using obj_clean_transformed_standardized

keep if _merge==3

drop _merge

merge 1:1 subjectid using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\dimensionality\dataset\mca_scores_full_cluster.dta"

drop Dim_3-_merge

merge 1:1 subjectid using censorship1

drop if m_age_recruitment==.

drop _merge 

//gen interaction term 
gen dim1_sq=Dim_1^2
gen dim2_sq=Dim_2^2
gen th=timecollected1*hospital

*luminex panel 
***************
/*
misstable summ adiponectin-insulin if adiponectin_bin-insulin_bin!=. if accommodation_0_1!=5 & m_ethnicity_0!=4
misstable pattern adiponectin-insulin if adiponectin_bin-insulin_bin!=. if accommodation_0_1!=5 & m_ethnicity_0!=4

misstable summ accommodation_0_1 m_highest_education_0_1 household_income_0 f_education_corrected_0_1 sai_quart sedi_quart m_place_of_birth_0_2 if accommodation_0_1!=5 & m_ethnicity_0!=4
misstable pattern accommodation_0_1 m_highest_education_0_1 household_income_0 f_education_corrected_0_1 sai_quart sedi_quart m_place_of_birth_0_2 if accommodation_0_1!=5 & m_ethnicity_0!=4
*/

//recode accommodation_0_1 5=., gen(accommodation_0_2)
//recode m_ethnicity_0 4=., gen(m_ethnicity_0_1)
 
// generate intervals 
foreach var of varlist adiponectin-insulin {
    gen ll_log2_`var'= log2_`var'
	egen ul_log2_`var'= min(log2_`var')
	replace ll_log2_`var'=. if log2_`var'==. & `var'_bin!=. // wouldnt make any difference since the undetected is already set to missing in the dataset but have it here just so I know 
	replace ul_log2_`var'=log2_`var' if log2_`var'!=. & `var'_bin!=.
	replace ul_log2_`var'=. if log2_`var'==. & `var'_bin==.
}

/*
foreach var of varlist adiponectin-insulin{
    codebook ul_log2_`var' if `var'_bin!=.
}

foreach var of varlist adiponectin-insulin{
    codebook ll_log2_`var' if log2_`var'==. & `var'_bin!=.
}
*/


//imputation
mi set flong 

mi register imputed log2_adiponectin-log2_lh log2_igfii-log2_igfbp1 log2_cpeptide-log2_insulin accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart parity_1 m_income_0 m_occupation_0_1 f_occupation_corrected_0_1 f_monthly_income_0_1 m_place_of_birth_0_2 region col_mo col_yr timecollected1 th

mi register regular m_ethnicity_0 m_age_recruitment log2_tsh log2_igfi log2_igfbp3 log2_igfbp7 w26_quintile dim1_sq dim2_sq Dim_1 Dim_2 hospital 

mi impute chained ///
(intreg, ll(ll_log2_adiponectin) ul(ul_log2_adiponectin)) log2_adiponectin_mi ///
(intreg, ll(ll_log2_pai1) ul(ul_log2_pai1)) log2_pai1_mi ///
(intreg, ll(ll_log2_resistin) ul(ul_log2_resistin)) log2_resistin_mi ///
(intreg, ll(ll_log2_mcp1) ul(ul_log2_mcp1)) log2_mcp1_mi ///
(intreg, ll(ll_log2_fsh) ul(ul_log2_fsh)) log2_fsh_mi ///
(intreg, ll(ll_log2_gh ) ul(ul_log2_gh)) log2_gh_mi ///
(intreg, ll(ll_log2_lh) ul(ul_log2_lh)) log2_lh_mi /// 
(intreg, ll(ll_log2_igfii) ul(ul_log2_igfii)) log2_igfii_mi ///
(intreg, ll(ll_log2_igfbp1) ul(ul_log2_igfbp1)) log2_igfbp1_mi ///
(intreg, ll(ll_log2_cpeptide) ul(ul_log2_cpeptide)) log2_cpeptide_mi ///
(intreg, ll(ll_log2_leptin) ul(ul_log2_leptin)) log2_leptin_mi ///
(intreg, ll(ll_log2_crp) ul(ul_log2_crp)) log2_crp_mi ///
(intreg, ll(ll_log2_ifng) ul(ul_log2_ifng)) log2_ifng_mi ///
(intreg, ll(ll_log2_tnfa) ul(ul_log2_tnfa)) log2_tnfa_mi ///
//(intreg, ll(ll_log2_vegf) ul(ul_log2_vegf)) log2_vegf_mi ///
(intreg, ll(ll_log2_igfbp4 ) ul(ul_log2_igfbp4)) log2_igfbp4_mi ///
(intreg, ll(ll_log2_insulin) ul(ul_log2_insulin)) log2_insulin_mi ///
(pmm, knn(3)) accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart parity_1 m_income_0 m_occupation_0_1 f_occupation_corrected_0_1 f_monthly_income_0_1 m_place_of_birth_0_2 region col_mo col_yr ///
= m_age_recruitment log2_tsh log2_igfi log2_igfbp3 log2_igfbp7 if m_ethnicity_0!=4 & adiponectin_bin!=., replace add(10) rseed(53421) by(m_ethnicity_0) dryrun
	  
mi impute chained ///
(intreg, ll(ll_log2_adiponectin) ul(ul_log2_adiponectin)) log2_adiponectin_mi ///
(intreg, ll(ll_log2_pai1) ul(ul_log2_pai1)) log2_pai1_mi ///
(intreg, ll(ll_log2_resistin) ul(ul_log2_resistin)) log2_resistin_mi ///
(intreg, ll(ll_log2_mcp1) ul(ul_log2_mcp1)) log2_mcp1_mi ///
(intreg, ll(ll_log2_fsh) ul(ul_log2_fsh)) log2_fsh_mi ///
(intreg, ll(ll_log2_gh ) ul(ul_log2_gh)) log2_gh_mi ///
(intreg, ll(ll_log2_lh) ul(ul_log2_lh)) log2_lh_mi /// 
(intreg, ll(ll_log2_igfii) ul(ul_log2_igfii)) log2_igfii_mi ///
(intreg, ll(ll_log2_igfbp1) ul(ul_log2_igfbp1)) log2_igfbp1_mi ///
(intreg, ll(ll_log2_cpeptide) ul(ul_log2_cpeptide)) log2_cpeptide_mi ///
(intreg, ll(ll_log2_leptin) ul(ul_log2_leptin)) log2_leptin_mi ///
(intreg, ll(ll_log2_crp) ul(ul_log2_crp)) log2_crp_mi ///
(intreg, ll(ll_log2_ifng) ul(ul_log2_ifng)) log2_ifng_mi ///
(intreg, ll(ll_log2_tnfa) ul(ul_log2_tnfa)) log2_tnfa_mi ///
(intreg, ll(ll_log2_igfbp4 ) ul(ul_log2_igfbp4)) log2_igfbp4_mi ///
(intreg, ll(ll_log2_insulin) ul(ul_log2_insulin)) log2_insulin_mi ///
(pmm, knn(3)) accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart parity_1 m_income_0 m_occupation_0_1 f_occupation_corrected_0_1 f_monthly_income_0_1 m_place_of_birth_0_2 region col_mo col_yr th timecollected1 ///
= m_age_recruitment log2_tsh log2_igfi log2_igfbp3 log2_igfbp7 i.w26_quintile dim1_sq dim2_sq Dim_1 Dim_2 hospital if m_ethnicity_0!=4 & adiponectin_bin!=., replace add(10) rseed(53421) by(m_ethnicity_0, noreport) force

midiagplots log2_pai1_mi log2_fsh_mi log2_gh_mi log2_lh_mi log2_igfii_mi log2_cpeptide_mi log2_leptin_mi log2_ifng_mi log2_tnfa_mi log2_igfbp4_mi log2_insulin_mi 

midiagplots accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart if m_ethnicity_0!=4 & adiponectin_bin!=., m(1) 

save "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\mi_data\luminex_novegf_mi_weight", replace 

//convergence diagnostics
mi impute chained ///
(intreg, ll(ll_log2_adiponectin) ul(ul_log2_adiponectin)) log2_adiponectin_mi ///
(intreg, ll(ll_log2_pai1) ul(ul_log2_pai1)) log2_pai1_mi ///
(intreg, ll(ll_log2_resistin) ul(ul_log2_resistin)) log2_resistin_mi ///
(intreg, ll(ll_log2_mcp1) ul(ul_log2_mcp1)) log2_mcp1_mi ///
(intreg, ll(ll_log2_fsh) ul(ul_log2_fsh)) log2_fsh_mi ///
(intreg, ll(ll_log2_gh ) ul(ul_log2_gh)) log2_gh_mi ///
(intreg, ll(ll_log2_lh) ul(ul_log2_lh)) log2_lh_mi /// 
(intreg, ll(ll_log2_igfii) ul(ul_log2_igfii)) log2_igfii_mi ///
(intreg, ll(ll_log2_igfbp1) ul(ul_log2_igfbp1)) log2_igfbp1_mi ///
(intreg, ll(ll_log2_cpeptide) ul(ul_log2_cpeptide)) log2_cpeptide_mi ///
(intreg, ll(ll_log2_leptin) ul(ul_log2_leptin)) log2_leptin_mi ///
(intreg, ll(ll_log2_crp) ul(ul_log2_crp)) log2_crp_mi ///
(intreg, ll(ll_log2_ifng) ul(ul_log2_ifng)) log2_ifng_mi ///
(intreg, ll(ll_log2_tnfa) ul(ul_log2_tnfa)) log2_tnfa_mi ///
(intreg, ll(ll_log2_igfbp4 ) ul(ul_log2_igfbp4)) log2_igfbp4_mi ///
(intreg, ll(ll_log2_insulin) ul(ul_log2_insulin)) log2_insulin_mi ///
(pmm, knn(3)) accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart parity_1 m_income_0 m_occupation_0_1 f_occupation_corrected_0_1 f_monthly_income_0_1 m_place_of_birth_0_2 region col_mo col_yr th timecollected1 ///
= m_age_recruitment log2_tsh log2_igfi log2_igfbp3 log2_igfbp7 hospital if m_ethnicity_0!=4 & adiponectin_bin!=., add(3) burnin(100) savetrace("C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\mi_data\convergence\impstats\luminex_novegf", replace) rseed(53421)

use "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\mi_data\convergence\impstats\luminex_novegf", clear
desc
rename f_occupation_corrected_0_1_mean f_occupation_corr_0_1_mean
reshape wide *mean *sd, i(iter) j(m)
tsset iter

tsline log2_pai1_mi_mean*, name(log2_pai1_mi_mean,replace) legend(off) ytitle("log2_pai1_mi mean")
tsline log2_pai1_mi_sd*, name(log2_pai1_mi_sd, replace) legend(off) ytitle("log2_pai1_mi mean")

tsline log2_fsh_mi_mean*, name(log2_fsh_mi_mean,replace) legend(off) ytitle("log2_fsh_mi mean")
tsline log2_fsh_mi_sd*, name(log2_fsh_mi_sd, replace) legend(off) ytitle("log2_fsh_mi sd")

tsline log2_gh_mi_mean*, name(log2_gh_mi_mean,replace) legend(off) ytitle("log2_gh_mi mean")
tsline log2_gh_mi_sd*, name(log2_gh_mi_sd, replace) legend(off) ytitle("log2_gh_mi sd")

tsline log2_lh_mi_mean*, name(log2_lh_mi_mean,replace) legend(off) ytitle("log2_lh_mi mean")
tsline log2_lh_mi_sd*, name(log2_lh_mi_sd, replace) legend(off) ytitle("log2_lh_mi sd")

tsline log2_igfii_mi_mean*, name(log2_igfii_mi_mean,replace) legend(off) ytitle("log2_igfii_mi mean")
tsline log2_igfii_mi_sd*, name(log2_igfii_mi_sd, replace) legend(off) ytitle("log2_igfii_mi sd")

tsline log2_leptin_mi_mean*, name(log2_leptin_mi_mean,replace) legend(off) ytitle("log2_leptin_mi mean")
tsline log2_leptin_mi_sd*, name(log2_leptin_mi_sd, replace) legend(off) ytitle("log2_leptin_mi sd")

tsline log2_ifng_mi_mean*, name(log2_ifng_mi_mean,replace) legend(off) ytitle("log2_ifng_mi mean")
tsline log2_ifng_mi_sd*, name(log2_ifng_mi_sd, replace) legend(off) ytitle("log2_ifng_mi sd")

tsline log2_tnfa_mi_mean*, name(log2_tnfa_mi_mean,replace) legend(off) ytitle("log2_tnfa_mi mean")
tsline log2_tnfa_mi_sd*, name(log2_tnfa_mi_sd, replace) legend(off) ytitle("log2_tnfa_mi sd")

tsline log2_igfbp4_mi_mean*, name(log2_igfbp4_mi_mean,replace) legend(off) ytitle("log2_igfbp4_mi mean")
tsline log2_igfbp4_mi_sd*, name(log2_igfbp4_mi_sd, replace) legend(off) ytitle("log2_igfbp4_mi sd")

tsline log2_insulin_mi_mean*, name(log2_insulin_mi_mean,replace) legend(off) ytitle("log2_insulin_mi mean")
tsline log2_insulin_mi_sd*, name(log2_insulin_mi_sd, replace) legend(off) ytitle("log2_insulin_mi sd")

tsline accommodation_0_2_mean*, name(accommodation_0_2_mean,replace) legend(off) ytitle("accommodation_0_2 mean")
tsline accommodation_0_2_sd*, name(accommodation_0_2_sd, replace) legend(off) ytitle("accommodation_0_2 sd")
tsline m_highest_education_0_1_mean*, name(m_highest_education_0_1_mean,replace) legend(off) ytitle("m_highest_education_0_1 mean")
tsline m_highest_education_0_1_sd*, name(m_highest_education_0_1_sd, replace) legend(off) ytitle("m_highest_education_0_1 sd")
tsline household_income_0_1_mean*, name(household_income_0_1_mean, replace) legend(off) ytitle("household_income_0_1 mean")
tsline household_income_0_1_sd*, name(household_income_0_1_sd, replace) legend(off) ytitle("household_income_0_1 sd")
tsline household_income_0_1_mean*, name(f_education_corr_0_1_mean, replace) legend(off) ytitle("f_education_corrected_0_1 mean")
tsline household_income_0_1_sd*, name(f_education_corrected_0_1_sd, replace) legend(off) ytitle("f_education_corrected_0_1 sd")
tsline household_income_0_1_mean*, name(sai_quart_mean, replace) legend(off) ytitle("sai_quart mean")
tsline household_income_0_1_sd*, name(sai_quart_sd, replace) legend(off) ytitle("sai_quart sd")
tsline household_income_0_1_mean*, name(sedi_quart_mean, replace) legend(off) ytitle("sedi_quart mean")
tsline household_income_0_1_sd*, name(sedi_quart_sd, replace) legend(off) ytitle("sedi_quart sd")

graph combine log2_pai1_mi_mean log2_pai1_mi_sd ///
log2_fsh_mi_mean log2_fsh_mi_sd 

graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\mi_data\convergence\graphs\luminex_novegf/pai1_fsh.png", replace

graph combine log2_gh_mi_mean log2_gh_mi_sd ///
log2_lh_mi_mean log2_lh_mi_sd 

graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\mi_data\convergence\graphs\luminex_novegf/gh_lh.png", replace

graph combine log2_igfii_mi_mean log2_igfii_mi_sd ///
log2_leptin_mi_mean log2_leptin_mi_sd 

graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\mi_data\convergence\graphs\luminex_novegf/igfii_leptin.png", replace

graph combine log2_ifng_mi_mean log2_ifng_mi_sd ///
log2_tnfa_mi_mean log2_tnfa_mi_sd 

graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\mi_data\convergence\graphs\luminex_novegf/ifng_tnfa.png", replace

graph combine log2_igfbp4_mi_mean log2_igfbp4_mi_sd ///
log2_insulin_mi_mean log2_insulin_mi_sd 

graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\mi_data\convergence\graphs\luminex_novegf/igfbp4_insulin.png", replace

graph combine accommodation_0_2_mean accommodation_0_2_sd ///
m_highest_education_0_1_mean m_highest_education_0_1_sd 

graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\mi_data\convergence\graphs\luminex_novegf/acc_medu.png", replace

graph combine household_income_0_1_mean household_income_0_1_sd ///
f_education_corr_0_1_mean f_education_corrected_0_1_sd 

graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\mi_data\convergence\graphs\luminex_novegf/hh_income_fedu.png", replace

graph combine sai_quart_mean sai_quart_sd ///
sedi_quart_mean sedi_quart_sd

graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\mi_data\convergence\graphs\luminex_novegf/sai_sedi.png", replace

	  	  
/*		  
foreach var of varlist ls_adiponectin-ls_lh ls_igfii-ls_igfbp1 ls_cpeptide-ls_insulin {
    mi estimate, saving(ps_`var'): regress `var' accommodation_0_2 m_highest_education_0_1 household_income_0 sai_quart sedi_quart dob_mo dob_yr parity_1 m_income_0 m_occupation_0_1 mhc1hmn_1 m_place_of_birth_0_2 region if adiponectin_bin!=.
	mi predict p_`var' using ps_`var' 
	mi xeq: gen w_`var'=.
	mi xeq: replace w_`var'=1/p_`var' if adiponectin_bin!=.
	mi xeq: replace w_`var'=1/(1-p_`var') if adiponectin_bin==.
}
*/

log close




