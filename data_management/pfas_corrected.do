/* e:\sumkk\ses-exposome\data\raw_data\
DO file e:\sumkk\ses-exposome\data\do_files\pfas
PFAS
15 Dec 2020, Ka Kei Sum
Dataset: 
  e:\sumkk\ses-exposome\data\raw_data\obj_clean_transformed_standardized (1193 vars, 1,344 obs)
*/

cd "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\raw_data"
capture log close  
log using e:\sumkk\ses-exposome\data\log_files\pfas.log, replace 
set more off

import excel "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\raw_data\EDC_deposit_02Dec2020.xls", sheet("Maternal delivery") firstrow case(lower) clear // (3 vars, 22,649 obs)

rename subject_id subjectid 

reshape wide ang_ml_mraw0, i(subjectid) j(chemical_name) string

foreach var of varlist ang_ml_mraw0BPA-ang_ml_mraw0Propylp {
	rename `var' `=substr("`var'", 13,.)'
}

foreach var of varlist BPA-Propylp {
	rename *, lower
}

foreach var of varlist bpa-propylp {
	gen `var'_lod_loq=0
	replace `var'_lod_loq=1 if `var'=="<LOD"
	replace `var'_lod_loq=2 if `var'=="<LOQ"
	label define `var'_l 0 "detected" 1 "lod" 2 "loq"
	label values `var'_lod_loq `var'_l
	replace `var'="." if `var'=="<LOD" 
	replace `var'="." if `var'=="<LOQ"
	destring `var', replace 
	label var `var' ""
}

save enviro_chemicals_corrected, replace 

count if pfba<0.4 //  1
list pfba if pfba<0.4 // 0.35
count if pfba<0.5 & pfba>0.4 //11
summ pfba if pfba<0.5 & pfba>0.4 // 0.41-0.49

count if pfhxa<0.5 // 23
summ pfhxa if pfhxa<0.5 // 0.33-0.45

count if pfpea<0.1 // 92 
summ pfpea if pfpea<0.1 // 0.07-0.09

count if pfhpa<0.1 //118
summ pfhpa if pfhpa<0.1  // 0.07-0.09
 
count if pfda<0.1 //6
summ pfda if pfda<0.1 //0.07-0.09

count if pfunda<0.1 //11
summ pfunda if pfunda <0.1 //0.07-0.09

count if pfdoda <0.1 //188
summ pfdoda if pfdoda<0.1 //0.07-0.09

count if pfbs <5 //12 
summ pfbs if pfbs<5 // 3.57-4.71
 
count if pfhxs <0.1 // 1
summ pfhxs  if pfhxs <0.1 // 0.09

keep subjectid pfba-pfunda pfba_lod_loq-pfunda_lod_loq

codebook 

foreach var of varlist pfba_lod_loq-pfunda_lod_loq {
	tab `var'
}

foreach var of varlist pfba-pfunda{
	gen log2_`var'=log(`var')/log(2)
	egen ls_`var'=std(log2_`var')
}

save pfas_corrected, replace 

use obj_clean_transformed_standardized, clear

order subjectid accommodation_0_2 household_income_0_1 f_education_corrected_0_1 m_highest_education_0_1 sai_quart sedi_quart parity_1 m_place_of_birth_0_2 m_ethnicity_0 m_age_recruitment col_mo col_yr dob_mo dob_yr region m_income_0 m_occupation_0_1 region f_occupation_corrected_0_1 f_monthly_income_0_1

keep subjectid-f_monthly_income_0_1

merge 1:1 subjectid using pfas_corrected

drop _merge 

save pfas_corrected_merged, replace 


