/* e:\sumkk\ses-exposome\data\raw_data\
DO file e:\sumkk\ses-exposome\data\do_files\merged_obj_clean_updated
Descriptive analysis
30 May 2020, Ka Kei Sum
Dataset: 
  e:\sumkk\ses-exposome\data\raw_data\merged_obj_clean_updated (1194 vars, 1,344 obs)
*/


cd e:\sumkk\ses-exposome\data\raw_data\
capture log close  
*log using e:\sumkk\ses-exposome\data\raw_data\merged_obj_clean_updated.log, replace 
set more off

use merged_obj_clean_updated, clear

order subjectid participant_statusy7_0 participant_statusy8_0 m_ethnicity_0 m_place_of_birth_0 m_place_of_birth_0_1 m_citizenship_0 m_highest_education_0_1 m_highest_education_0_2 m_occupation_0_1 m_occupation_0_2 m_income_0 household_income_0 marital_status_0 accommodation_0_1 mhc1hmn_1 parity parity_1 f_ethnicity_0 f_occupation_corrected_0_1 f_occupation_corrected_0_2 f_education_corrected_0_1 f_education_corrected_0_2 f_monthly_income_0_1 f_household_income_0_1 sai_quart sedi_quart ///
mpm3cot_bin mpm3cot2_bin mpm3c3hc_bin mpm3c3hc2_bin pfpea_bin pfhxa_bin mmp_bin mcpp_bin mbzp_bin ///
m_age_recruitment ga f_age_recruitment sai sedi sbp_avg-map_avg m_weight_pw26-m_height_pw26 m_midarm_pw26-m_suprailiac_pw26 avg_weight_1sttri avg_weight_2ndtri avg_weight_3rdtri last_antenatal_weight mpm3na mpm3mg mpm3p-mpm3fe mpm3fr mpm3cu mpm3zn mpm3se mpm3fo mpm3tr mpm3my mpm3pal mpm3pl mpm3st mpm3ol mpm3cv mpm3li mpm3li6 mpm3li3 mpm320 mpm3n9 mpm32n6 mpm33n6 mpm3ar6 mpm322 mpm3n3 mpm3epa mpm3n62 mpm3dpa mpm3dha mpm3tfa mpm3tn3 mpm3tn6 mpm3sfa mpm3muf mpm3puf mpm3fmn2 mpm3neo2 mpm3ribo2 mpm3mnam2 mpm3nam2 mpm3nia2 mpm3trig2 mpm3py2 mpm3plpb2 mpm3bplp mpm3pabe2 mpm3pa mpm3pn2 mpm3b12p mpm3vd3 mpm3arg2 mpm3adma2 mpm3crn2 mpm3crea2 mpm3harg2 mpm3sdma2 mpm3tml2 mpm3csta2 mpm3hcy2 mpm3tcys2 mpm3m1hs2 mpm3m3hs2 mpm3hist2 mpm3met2 mpm3mtso2 mpm3haa2 mpm3hk2 mpm3aa2 mpm3ka2 mpm3kyn2 mpm3qa2 mpm3trp2 mpm3xa2 mpm3betn2 mpm3chol2 mpm3dmg2 mpm3tmao2 m_ogtt_fasting_pw26 m_ogtt_2hour_pw26 pfba-oxybenzone adiponectin-insulin psi_tri1-psi_pregnancy pm25_1st-pm25_3rd pm25_avg_daily_1

// include main GUSTO participants with all data 

*Categorical data 
*****************
foreach var of varlist participant_statusy8_0-sedi_quart {
	tab `var'
}

/*
tab accommodation_0_1 if accommodation_0_1!=5
tab m_ethnicity_0 if m_ethnicity_0!=4
*/

foreach var of varlist participant_statusy8_0-sedi_quart {
	tab `var',m
}

*Binary data
************
foreach var of varlist mpm3cot mpm3cot2 mpm3c3hc mpm3c3hc2 pfpea pfhxa mmp mcpp mbzp {
	tab `var'_bin
}

foreach var of varlist mpm3cot mpm3cot2 mpm3c3hc mpm3c3hc2 pfpea pfhxa mmp mcpp mbzp {
	tab `var'_bin, m
}

*Quantitative data 
****************** 
foreach var of varlist m_age_recruitment-last_antenatal_weight {
    summ `var', detail
}

foreach var of varlist mpm3na-mpm3tmao2 {
    summ `var', detail
}

foreach var of varlist m_ogtt_fasting_pw26-pm25_avg_tri {
    summ `var', detail
}


//Assessing normality 

cd e:\sumkk\ses-exposome\results\graph_norm\

//1. Histogram  
foreach var of varlist sbp_avg-bpa  {
	hist `var', freq norm
	graph save `var', replace
}

foreach var of varlist bps-pm25_avg_daily_1 {
	hist `var', freq norm
	graph save `var', replace
}

//2. Q-Q plot 

foreach var of varlist sbp_avg-bpa  {
	qnorm `var'
	graph save qq-`var', replace
}


foreach var of varlist bps-pm25_avg_daily_1 {
	qnorm `var'
	graph save qq-`var', replace
}


//Assessing transformation 

foreach var of varlist sbp_avg-pm25_avg_daily_1  {
	gladder `var'
	graph save gladder-`var', replace
}

foreach var of varlist sbp_avg-pm25_avg_daily_1  {
	ladder `var'
}

//Log2 transform 
foreach var of varlist sbp_avg-pm25_avg_daily_1  {
	gen log2_`var'=log(`var')/log(2)
}

//z-standardize 
foreach var of varlist sbp_avg-pm25_avg_daily_1  {
	egen ls_`var'=std(log2_`var')
}

//z-standardize non-skewed 
foreach var of varlist sbp_avg m_height_pw26 m_triceps_pw26 m_subscapular_pw26 m_suprailiac_pw26 mpm3se mpm3cv mpm32n6 mpm3vd3 mpm3crn2 mpm3crea2 mpm3tcys2 mpm3trp2 psi_tri1-pm25_avg_daily_1 {
	egen s_`var'=std(`var')
}

/*
// 0,1 
foreach var of varlist sbp_avg-insulin  {
	qui summ log2_`var'
	gen ls01_`var'=(log2_`var'-r(min))/(r(max)-r(min))
}

// 0,1 non-skewed
foreach var of varlist sbp_avg m_height_pw26 m_triceps_pw26 m_subscapular_pw26 m_suprailiac_pw26 mpm3se mpm3cv mpm32n6 mpm3vd3 mpm3crn2 mpm3crea2 mpm3tcys2 mpm3trp2 psi_tri1-pm25_avg_daily_1 {
	qui summ `var'
	gen s01_`var'=(`var'-r(min))/(r(max)-r(min))
}
*/

save obj_clean_transformed_standardized, replace

***********
/*
// relationship between SES 

*1 Maternal income and accomodation 
tab accommodation_0 m_income_0, col
tab accommodation_0_1 m_income_0, col chi //  

*2 Maternal income occupation 
tab m_income_0 m_occupation_0_1, col // majority homemaker hard to tell SES 
tab m_income_0 m_occupation_0_2, col

*3 Maternal income education 
tab m_income_0 m_highest_education_0_1, col
tab m_income_0 m_highest_education_0_2, col 

*4 Maternal education occupation 
tab m_highest_education_0_1 m_occupation_0_1, col
tab m_highest_education_0_1 m_occupation_0_2, col
tab m_highest_education_0_2 m_occupation_0_1, col
tab m_highest_education_0_2 m_occupation_0_2, col 

*5 Paternal occupation income 
tab f_occupation_corrected_0_1 f_monthly_income_0_1, col // better cat 
tab f_occupation_corrected_0_2 f_monthly_income_0_1, col 

*6 Peternal income accomodation
tab accommodation_0_1 f_monthly_income_0_1, col

tab accommodation_0_1 household_income_0, col
tab household_income_0 f_household_income_0_1, col chi

tab m_occupation_0_1 f_occupation_corrected_0_1

//country of birth, citizenship, year moved to Sg 

tab monthyear_sg_arrival_1 if m_place_of_birth_0_1 !=5 // 372 total for year_arrival, one born in Sg??? 

tab m_place_of_birth_0_1 if m_place_of_birth_0_1 !=5 // 464 not born in Sg 

tab m_citizenship_0 if m_place_of_birth_0_1 !=5 & m_place_of_birth_0_1 !=. // 88 became citizen and 356 were PR

tab m_citizenship_0 if m_place_of_birth_0_1 ==5 // 7 born in Sg but PR

tab m_citizenship_ monthyear_sg_arrival_1 

tab m_citizenship_ monthyear_sg_arrival_1 if m_place_of_birth_0_1 !=5
*/



