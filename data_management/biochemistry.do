/* e:\sumkk\ses-exposome\data\raw_data\
DO file e:\sumkk\ses-exposome\data\do_files\biochemistry 
Biochemistry panel 
17 Dec 2020, Ka Kei Sum
Dataset: 
  e:\sumkk\ses-exposome\data\raw_data\obj_clean_transformed_standardized (1193 vars, 1,344 obs)
*/

cd e:\sumkk\ses-exposome\data\raw_data\
capture log close  
log using e:\sumkk\ses-exposome\data\log_files\biochem.log, replace 
set more off

import excel "E:\sumkk\ses-exposome\data\raw_data\Mother_Biochemistry_pw26_20200424.xlsx", sheet("Sheet 1") firstrow case(lower) clear // (12 vars, 970 obs)


merge 1:1 subjectid using obj_clean_transformed_standardized.dta

drop if _merge==1

drop _merge 

order subjectid accommodation_0_2 household_income_0_1 f_education_corrected_0_1 m_highest_education_0_1 sai_quart sedi_quart parity_1 m_place_of_birth_0_2 m_ethnicity_0 m_age_recruitment col_mo col_yr dob_mo dob_yr region m_income_0 m_occupation_0_1 region f_occupation_corrected_0_1 f_monthly_income_0_1

keep subjectid-mbc3ura

// Identify non-string inputs
foreach var of varlist mbc3ldl mbc3hscp mbc3alt mbc3ggt mbc3ura {
    gen byte notnumeric_`var'= real(`var')==.
	tab notnumeric_`var' if `var'!=""
	list subjectid `var' if notnumeric_`var'==1 & `var'!=""
}

//mbc3ldl: 4(0.45%) (invalild)
//mbc3hscp: 2(0.23%) (<0.1)
//mbc3alt: 14(1.59%) (<6)
//mbc3ggt: 463(52.79%) (<10)
//mbc3ura: 2(0.23%) <89 

foreach var of varlist mbc3ldl mbc3hscp mbc3alt mbc3ggt mbc3ura {
    gen `var'_num=`var'
	replace `var'_num="" if notnumeric_`var'==1
	destring `var'_num, replace 
}

foreach var of varlist mbc3tc-mbc3hdl mbc3ins-mbc3cre mbc3ast mbc3ldl_num-mbc3ura_num {
    summ `var', detail 
	hist `var', freq norm
	graph export "e:\sumkk\ses-exposome\results\graph_norm\biochemistry/`var'.png", replace 
}

//log2 transform and z-standardize right skewed biomarkers
foreach var of varlist mbc3tg mbc3ins mbc3hscp_num mbc3alt_num mbc3ast mbc3ggt_num mbc3ura_num {
	gen log2_`var'=log(`var')/log(2)
	egen ls_`var'=std(log2_`var')
}

//z-standardize non-skewed 
foreach var of varlist mbc3tc mbc3hdl mbc3ldl_num mbc3cre {
	egen s_`var'=std(`var')
}

order ls_mbc3tg ls_mbc3ins ls_mbc3hscp_num ls_mbc3alt_num ls_mbc3ast ls_mbc3ggt_num ls_mbc3ura_num s_mbc3tc s_mbc3hdl s_mbc3ldl_num s_mbc3cre, after(f_monthly_income_0_1)

foreach var of varlist ls_mbc3tg-s_mbc3cre {
    hist `var', freq norm
	graph export "e:\sumkk\ses-exposome\results\graph_norm\biochemistry/`var'.png"
}

save biochemistry_merged, replace 

log close 






