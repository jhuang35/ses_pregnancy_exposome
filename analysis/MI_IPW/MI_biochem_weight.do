/* e:\sumkk\ses-exposome\data\raw_data\
DO file e:\sumkk\ses-exposome\data\do_files\MI_biochem
Multiple imputation 
28 Jan 2021, Ka Kei Sum
Dataset: 
  e:\sumkk\ses-exposome\data\raw_data\biochemistry_merged (1193 vars, 1,344 obs)
*/

cd "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\raw_data"
capture log close  
log using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\log_files\mi_biochemistry1.log", replace 
set more off

use blood_col_inv, clear

keep subjectid timecollected1 timecollected_cat hospital dh 

merge 1:1 subjectid using biochemistry_merged

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

//those with LOD: CRP(2), ALT(14), UA(2)

//mbc3ldl: 4(0.45%) (invalild)
//mbc3hscp: 2(0.23%) (<0.1)
//mbc3alt: 14(1.59%) (<6)
//mbc3ggt: 463(52.79%) (<10)
//mbc3ura: 2(0.23%) <89 

//generate interval 
//LOD 
foreach var of varlist mbc3hscp_num mbc3alt_num mbc3ura_num mbc3ggt_num {
    gen ll_log2_`var'=log2_`var'
}

gen ul_log2_mbc3hscp_num=log2_mbc3hscp_num
replace ul_log2_mbc3hscp_num=log(0.09)/log(2) if log2_mbc3hscp_num==. & mbc3tc!=.

gen ul_log2_mbc3alt_num=log2_mbc3alt_num
replace ul_log2_mbc3alt_num=log(5)/log(2) if log2_mbc3alt_num==. & mbc3tc!=.

gen ul_log2_mbc3ura_num=log2_mbc3ura_num
replace ul_log2_mbc3ura_num=log(88)/log(2) if log2_mbc3ura_num==. & mbc3tc!=.

gen ul_log2_mbc3ggt_num=log2_mbc3ggt_num
replace ul_log2_mbc3ggt_num=log(9)/log(2) if log2_mbc3ggt_num==. & mbc3tc!=.

//Imputation model 
mi set flong 

mi register imputed mbc3ldl_num mbc3cre log2_mbc3hscp_num log2_mbc3alt_num log2_mbc3ast log2_mbc3ggt_num log2_mbc3ura_num accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart m_place_of_birth_0_2 m_income_0 m_occupation_0_1 region f_occupation_corrected_0_1 f_monthly_income_0_1 col_mo col_yr parity_1 timecollected1 th

mi register regular m_ethnicity_0 m_age_recruitment mbc3tc log2_mbc3tg mbc3hdl log2_mbc3ins w26_quintile dim1_sq dim2_sq Dim_1 Dim_2 hospital

mi impute chained ///
(intreg, ll(ll_log2_mbc3hscp_num) ul(ul_log2_mbc3hscp_num)) log2_mbc3hscp_num_mi ///
(intreg, ll(ll_log2_mbc3alt_num) ul(ul_log2_mbc3alt_num)) log2_mbc3alt_num_mi ///
(intreg, ll(ll_log2_mbc3ura_num) ul(ul_log2_mbc3ura_num)) log2_mbc3ura_num_mi ///
(intreg, ll(ll_log2_mbc3ggt_num) ul(ul_log2_mbc3ggt_num)) log2_mbc3ggt_num_mi ///
(regress) log2_mbc3ast mbc3ldl_num mbc3cre ///
(pmm, knn(3)) accommodation_0_2 m_highest_education_0_1 f_education_corrected_0_1 household_income_0_1 sai_quart sedi_quart m_income_0 m_occupation_0_1 m_place_of_birth_0_2 region f_occupation_corrected_0_1 f_monthly_income_0_1 col_mo col_yr parity_1 ///
= m_age_recruitment mbc3tc log2_mbc3tg mbc3hdl log2_mbc3ins if m_ethnicity_0!=4 & mbc3tc!=., replace add(5) rseed(53421) by(m_ethnicity_0) dryrun

mi impute chained ///
(intreg, ll(ll_log2_mbc3hscp_num) ul(ul_log2_mbc3hscp_num)) log2_mbc3hscp_num_mi ///
(intreg, ll(ll_log2_mbc3alt_num) ul(ul_log2_mbc3alt_num)) log2_mbc3alt_num_mi ///
(intreg, ll(ll_log2_mbc3ura_num) ul(ul_log2_mbc3ura_num)) log2_mbc3ura_num_mi ///
(intreg, ll(ll_log2_mbc3ggt_num) ul(ul_log2_mbc3ggt_num)) log2_mbc3ggt_num_mi ///
(regress) log2_mbc3ast mbc3ldl_num mbc3cre ///
(pmm, knn(3)) accommodation_0_2 m_highest_education_0_1 f_education_corrected_0_1 household_income_0_1 sai_quart sedi_quart m_income_0 m_occupation_0_1 m_place_of_birth_0_2 region f_occupation_corrected_0_1 f_monthly_income_0_1 col_mo col_yr parity_1 th timecollected1 ///
= m_age_recruitment mbc3tc log2_mbc3tg mbc3hdl log2_mbc3ins i.w26_quintile dim1_sq dim2_sq Dim_1 Dim_2 hospital if m_ethnicity_0!=4 & mbc3tc!=., replace add(10) rseed(53421) by(m_ethnicity_0, noreport) force 
 
midiagplots log2_mbc3hscp_num_mi log2_mbc3alt_num_mi log2_mbc3ura_num_mi

midiagplots accommodation_0_2 m_highest_education_0_1 household_income_0_1 f_education_corrected_0_1 sai_quart sedi_quart if m_ethnicity_0!=4 & mbc3tc!=., m(1) 

save "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\mi_data\biochemistry_mi_weight", replace 

//convergence diagnostics
mi impute chained ///
(intreg, ll(ll_log2_mbc3hscp_num) ul(ul_log2_mbc3hscp_num)) log2_mbc3hscp_num_mi ///
(intreg, ll(ll_log2_mbc3alt_num) ul(ul_log2_mbc3alt_num)) log2_mbc3alt_num_mi ///
(intreg, ll(ll_log2_mbc3ura_num) ul(ul_log2_mbc3ura_num)) log2_mbc3ura_num_mi ///
(intreg, ll(ll_log2_mbc3ggt_num) ul(ul_log2_mbc3ggt_num)) log2_mbc3ggt_num_mi ///
(regress) mbc3ldl_num mbc3cre log2_mbc3ast ///
(pmm, knn(3)) accommodation_0_2 m_highest_education_0_1 f_education_corrected_0_1 household_income_0_1 sai_quart sedi_quart m_income_0 m_occupation_0_1 m_place_of_birth_0_2 region f_occupation_corrected_0_1 f_monthly_income_0_1 th timecollected1 ///
= m_age_recruitment col_mo col_yr parity_1 mbc3tc log2_mbc3tg mbc3hdl log2_mbc3ins hospital if m_ethnicity_0!=4 & mbc3tc!=., add(3) burnin(100) savetrace("C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\mi_data\convergence\impstats\biochemistry", replace) rseed(53421) force

use "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\mi_data\convergence\impstats\biochemistry", clear
desc
rename f_occupation_corrected_0_1_mean f_occupation_corr_0_1_mean 
reshape wide *mean *sd, i(iter) j(m)
tsset iter

tsline log2_mbc3hscp_num_mi_mean*, name(log2_mbc3hscp_num_mi_mean,replace) legend(off) ytitle("log2_mbc3hscp_num_mi mean")
tsline log2_mbc3hscp_num_mi_sd*, name(log2_mbc3hscp_num_mi_sd, replace) legend(off) ytitle("log2_mbc3hscp_num_mi sd")

tsline log2_mbc3alt_num_mi_mean*, name( log2_mbc3alt_num_mi_mean,replace) legend(off) ytitle("log2_mbc3alt_num_mi mean")
tsline log2_mbc3alt_num_mi_sd*, name(log2_mbc3alt_num_mi_sd, replace) legend(off) ytitle("log2_mbc3alt_num_mi sd")

tsline log2_mbc3ura_num_mi_mean*, name(log2_mbc3ura_num_mi_mean,replace) legend(off) ytitle("log2_mbc3ura_num_mi mean")
tsline log2_mbc3ura_num_mi_sd*, name(log2_mbc3ura_num_mi_sd, replace) legend(off) ytitle("log2_mbc3ura_num_mi sd")

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

graph combine log2_mbc3hscp_num_mi_mean log2_mbc3hscp_num_mi_sd ///
log2_mbc3alt_num_mi_mean log2_mbc3alt_num_mi_sd ///
log2_mbc3ura_num_mi_mean log2_mbc3ura_num_mi_sd 

graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\mi_data\convergence\graphs\biochem/biochem_mi.png", replace

graph combine accommodation_0_2_mean accommodation_0_2_sd ///
m_highest_education_0_1_mean m_highest_education_0_1_sd 

graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\mi_data\convergence\graphs\biochem/acc_medu.png", replace

graph combine household_income_0_1_mean household_income_0_1_sd ///
f_education_corrected_0_1_mean f_education_corrected_0_1_sd 

graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\mi_data\convergence\graphs\biochem/hh_income_fedu.png", replace

graph combine sai_quart_mean sai_quart_sd ///
sedi_quart_mean sedi_quart_sd

graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\mi_data\convergence\graphs\biochem/sai_sedi.png", replace

log close 