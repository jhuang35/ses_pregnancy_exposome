/* e:\sumkk\ses-exposome\data\raw_data\
DO file e:\sumkk\ses-exposome\data\do_files\data_management_obj
Data management
26 May 2020, Ka Kei Sum
Dataset: 
  e:\sumkk\ses-exposome\data\raw_data\merged_obj_updated (2027 vars, 1,445 obs)
*/

cd "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\raw_data"
capture log close  
*log using e:\sumkk\ses-exposome\data\raw_data\merged_obj_updated.log, replace 
set more off 

*****************
*DATA MANAGEMENT*
*****************
use merged_obj_updated, clear 

*check duplicates
******************
duplicates report 
duplicates report subjectid // no duplicates

*check number of participants 
******************************
tab participant_statusy7

participant |
  _statusy7 |      Freq.     Percent        Cum.
------------+-----------------------------------
     active |      1,018       70.45       70.45
      death |          1        0.07       70.52
    dropout |        218       15.09       85.61
 ineligible |        208       14.39      100.00
------------+-----------------------------------
      Total |      1,445      100.00

di 1445-208 // 1237 eligibles (main gusto + IVF)

tab participant_statusy8

participant_statu |
              sy8 |      Freq.     Percent        Cum.
------------------+-----------------------------------
           active |      1,012       70.03       70.03
       ineligible |          5        0.35       70.38
lost to follow up |        428       29.62      100.00
------------------+-----------------------------------
            Total |      1,445      100.00

// 5 ineligibles were removed from the flowchart, thus 1440 total (main GUSTO + IVF) instead of 1445 here  

tab participant_statusy8 if substr(subjectid, 1,3) == "019" //total=88, active=63
tab participant_statusy8 if substr(subjectid, 1,3) == "029" // toatl=10, active=9
// 63+9=72 active IVF

di 1012-72 //940 main GUSTO (number aligned with year 8 f/u)

/* Based on eligible status coded previously 
tab participant_statusy8 if substr(subjectid, 1,3) == "019" & participant_statusy7 == "ineligible" // 13

tab participant_statusy8 if substr(subjectid, 1,3) == "029" & participant_statusy7 == "ineligible" // none 

// 13 ineligibles among IVF, 98-13=85 eligibles among IVF 

*drop ineligibles and IVF 

drop if participant_statusy7=="ineligible" // (208 deleted, 1237 obs)

drop if substr(subjectid, 1,3) == "019" // (75 deleted, 1162 obs)

drop if substr(subjectid, 1,3) == "029" // (10 deleted, 1152 obs)

// 1152 eligibles and without IVF 
*/

*Based on updated eligible status
tab participant_statusy8 if substr(subjectid, 1,3) == "019" & participant_statusy8 == "ineligible" // 2

tab participant_statusy8 if substr(subjectid, 1,3) == "029" & participant_statusy8 == "ineligible" // none 

// 2 ineligibles among IVF, 98-2=96 eligibles among IVF 

*drop ineligibles and IVF 

drop if participant_statusy8=="ineligible" // (5 deleted, 1440 obs)

drop if substr(subjectid, 1,3) == "019" // (86 deleted, 1354 obs)

drop if substr(subjectid, 1,3) == "029" // (10 deleted, 1344 obs)

// 1344 eligibles and without IVF 

*drop all child outcomes, non-objective measures and measures beyond pregnancy (only inlcude objective measures here)
********************************************************************************
drop ethnicity_remarks duration_anybf_cat_new-childcare_arr_3_recoded family_history_dm_binary_pw11-family_history_cvd_binary_yr4 father_age_delivery htn_clean alcohol_consumption_pp-total_alcohol_perday_g_preg sbp_discharge-map_est_discharge m_fac1_1_wk3-flag_job_changing_during_pregnan self_reported_smoking_pw26-mother_births_incl_still dr1sta-indication3_y4 m_gdm_treatment-yr6_hearing_problem_specify // 1086 vars remaining)

*rename variables
****************** 
//those contain prefix mother to m
rename mother* m*
//partner_ethnicity  
rename partner_ethnicity f_ethnicity
//those contain prefix father to f
rename father* f*

rename GA2, lower

rename first pm25_1st 
rename second pm25_2nd
rename third pm25_3rd

*check variables type
********************* 
desc 

*convert string vars to numeric
******************************* 
foreach var of varlist participant_statusy7-m_citizenship m_highest_education-accommodation ga_source f_education-f_visit mhc1cr1 mhc1cs1 mhc1cr2 mhc1cs2 mhc1cr3 mhc1cs3 mhc1cr4 mhc1cs4 mhc1cr5 mhc1cs5 mhc1cr6 mhc1cs6 mhc1cr7 mhc1cs7 mhc1ar1 mhc1as1 mhc1ar2 mhc1as2 mhc1ar3 mhc1as3 mhc1ar4 mhc1as4 mhc1ar5 mhc1as5 mhc1ar6 mhc1as6 mpm3mgd mpm3fed mpm3frd mpm3cud mpm3znd mpm3fod mpm3plpc mpm3b12d mpm3b12e ppbmi_whoclass m_birth_place m_birth_place_others m_ogtt_lab_pw26 labid pa { 
	encode `var', gen(`var'_0)
}
 
*mpm3pa contains text "low detection", need to replace value with 0.5LOD then destring 
replace mpm3pa="1.5" if mpm3pa=="low detection" // 7 changes 

destring mpm3pa, replace 

foreach var of varlist psi_tri1-psi_tri3 psi_l7d {
	destring `var', replace
}

*all neighborhoodses vars (except PA) contains text "NA" 
foreach var of varlist sai-sedi_ub {
	replace `var'="." if `var'=="NA" 
} // 23 changes 

foreach var of varlist sai-sedi_ub {
	destring `var', replace  
}

*check for abnormal range, missing data, recode
***********************************************  
codebook m_age_recruitment parity f_age_recruitment mhc1lohm-mhc1asm6 sbp_first_antenatal- m_height_pw26 m_midarm_pw26-mpm3mg 

codebook mpm3p-mpm3fe mpm3fr mpm3cu mpm3zn mpm3se mpm3fo mpm3tr-mpm3bplp mpm3pabe-mpm3b12p mpm3vd3-gestationalweek9 m_ogtt_gestationalweek 

codebook m_ogtt_fasting_pw26-m_gdm_iadpsg_2018_cat pfba-oxybenzone sai-insulin 

codebook participant_statusy8_0-pa_0

codebook psi_tri1-avgpm25week1 pm251

*resolve dob discrepancies 
****************************
//identified abnormality when merging
replace dob_mo=month(dob) if subjectid=="010-10002"
replace dob_yr=year(dob) if subjectid=="010-10002"

//1096 dob but 1093 dob_mo and dob_yr; 1098 main GUSTO at delivery 

list subjectid participant_statusy8 dob if dob!=. & dob_mo==. & dob_yr==.

 +-------------------------------------------+
      | subjectid   participant_sta~8         dob |
      |-------------------------------------------|
 335. | 010-20691   lost to follow up   23-Aug-10 |
 836. | 010-21792   lost to follow up   13-Oct-10 |
1200. | 020-50141   lost to follow up    3-Dec-10 |
      +-------------------------------------------+

replace dob_mo=month(dob) if dob!=. & dob_mo==.
replace dob_yr=year(dob) if dob!=. & dob_yr==.

//check if there is any inconsistency
list subjectid if month(dob)!=dob_mo 
list subjectid if year(dob)!=dob_yr

*check for inconsistencies for sample collection dates
*******************************************************
list subjectid if month(col)!=col_mo 
list subjectid if year(col)!=col_yr

*relabel variables: mpm3mgd_0 mpm3fed_0 mpm3frd_0 mpm3cud_0 mpm3znd_0 mpm3fod_0 mpm3plpc_0 mpm3b12d_0 mpm3b12e_0 mpm3vd3d mpm3vd3e ppbmi_whoclass_0 mode_of_delivery
*******************************************

label define mpm3mgd_0lab 1"D(<18.25mg/L)" 2 "MD(>=18.25mg/L or <20.68mg/L )" 3"S(>=20.68mg/L)"
label values mpm3mgd_0 mpm3mgd_0lab

label define mpm3fed_0lab 1"D(<558.6ug/L)" 2"S(>=558.8ug/L)" 
label values mpm3fed_0 mpm3fed_0lab

label define mpm3frd_0lab 1"D(<15ng/mL)" 2"(>=15ng/mL)" 
label values mpm3frd_0 mpm3frd_0lab

label define mpm3cud_0lab 1"S(>=900ug/L)" 
label values mpm3cud_0 mpm3cud_0lab

label define mpm3znd_0lab 1"D(<700ug/L)" 2"S(>=700ug/L)" 
label values mpm3znd_0 mpm3znd_0lab

label define mpm3fod_0lab 1"D(<6ng/mL)" 2">6ng/mL" 
label values mpm3fod_0 mpm3fod_0lab

label define mpm3plpc_0lab 1"D(<20nmol/L)" 2"S(>=20nmol/L)" 
label values mpm3plpc_0 mpm3plpc_0lab

label define mpm3b12d_0lab 1"D(<200pg/mL)" 2"MD(200-299pg/mL)" 3"S(>=300pg/mL)"
label values mpm3b12d_0 mpm3b12d_0lab

label define mpm3b12e_0lab 1"D(<300pg/mL)" 2"S(>=300pg/mL)" 
label values mpm3b12e_0 mpm3b12e_0lab

label define mpm3vd3dlab 0"D(<30nmol/L)" 1"MD(30-49nmol/L)" 2"S(>=50nmol/L)"
label values mpm3vd3d mpm3vd3dlab

label define mpm3vd3elab 0"D(<50nmol/L)" 1"MD(50-75nmol/L)" 2"S(>75nmol/L)"
label values mpm3vd3e mpm3vd3elab

label define ppbmi_whoclass_0lab 1"normal 18.5-24.9" 2"obese >=30.0"  3"overweight 25.0-29.9" 4"underweight <18.5"
label values ppbmi_whoclass_0 ppbmi_whoclass_0lab

label define mode_of_deliverylab 0"spontaneous vaginal" 1"assisted/intrumental vaginal" 2"intrapartum C-section" 3"elective c-section" 4"emergency c-section"
label values mode_of_delivery mode_of_deliverylab

*Create variables 
*****************

// Avg bp 

egen sbp_avg=rowmean(sbp_first_antenatal sbp_pw26_antenatal sbp_last_antenatal)
egen dbp_avg=rowmean(dbp_first_antenatal dbp_pw26_antenatal dbp_last_antenatal)
egen map_avg=rowmean(map_est_first_antenatal map_est_pw26_antenatal map_est_last_antenatal)

// Country of birth (mother_birth_place all SG except others; mother_birth_place_others-- identify different countries; gen a new var based on the 2 vars)

gen m_cob=m_birth_place_others_0
replace m_cob=200 if m_birth_place_0==1 //64
replace m_cob=200 if m_birth_place_0==2 //2  
replace m_cob=200 if m_birth_place_0==3 //42  
replace m_cob=200 if m_birth_place_0==4 //316 
replace m_cob=200 if m_birth_place_0==5 //17 
replace m_cob=200 if m_birth_place_0==6 //3
replace m_cob=200 if m_birth_place_0==7 //13  
replace m_cob=200 if m_birth_place_0==8 //8  
replace m_cob=200 if m_birth_place_0==9 //3  
replace m_cob=200 if m_birth_place_0==10 //2  
// 470 Sg born

recode m_cob 6/8 10=1 ///
5 13/16 18/24 35 95 99=2 ///
39/41 44/45 47/51=3 ///
9 12 42/43 52 55/56=4 ///
54=5 ///
63=6 ///
11 32/34 36 53 57/58 61/62 64/85 90 92/94 97=7 ///
89=8 ///
103=9 ///
2=10 ///
100/101=11 ///
105=12 ///
107=13 ///
27=14 ///
1 3 4 28 29 31 88 96 46 109 87 26 17 104 37 86 102 91 25=. ///
30 38 59 60 98 106 108=200 

// 338 changes 

label define m_coblab 1"Bangladesh" 2"China" 3"India" 4"Indonesia" 5"Ireland" 6"Kuwait" 7"Malaysia" 8"Pakistan" 9"Philippines" 10"Argentina" 11"Sri Lanka" 12"Taiwan" 13"Thailand" 14"Vietnam" 200"Singapore"
label values m_cob m_coblab 

/*
// Weight gain during pregnancy (last antenatal weight -ppweight=final weight gain, need to verify w GA of last antenatal weight and GA of infant)

gen ga_diff=ga-last_antenatal_weight_ga
summ ga_diff, detail 

gen last_weight_gain_2ndtri=last_antenatal_weight-ppweight if inrange(last_antenatal_weight_ga,13,28)
summ last_weight_gain_2ndtri, detail //4 obs 

gen last_weight_gain_3rdtri=last_antenatal_weight-ppweight if inrange(last_antenatal_weight_ga,29,41.14)
summ last_weight_gain_3rdtri, detail // negative values? range -11.9 to 40.5, mean=13.57 median=13.3 SD=5.53

gen weight_gain_pw26= m_weight_pw26-ppweight
summ weight_gain_pw26, detail // range= -10.95 to 38.7 mean=8.59 SD=4.65 median=8.3 

********due to ppweight is self-reported won't consider weight gain as a var
*/

//Avg weight for trimester 

*1st trimester
gen weight1_1sttri=weight1 if inrange(gestationalweek1,1,12.99)
gen weight2_1sttri=weight2 if inrange(gestationalweek2,1,12.99)
gen weight3_1sttri=weight3 if inrange(gestationalweek3,1,12.99)

egen avg_weight_1sttri=rowmean(weight1_1sttri weight2_1sttri weight3_1sttri) 

*2nd trimester 
gen weight1_2ndtri=weight1 if inrange(gestationalweek1,13,28.99)
gen weight2_2ndtri=weight2 if inrange(gestationalweek2,13,28.99)
gen weight3_2ndtri=weight3 if inrange(gestationalweek3,13,28.99)
gen weight4_2ndtri=weight4 if inrange(gestationalweek4,13,28.99)
gen weight5_2ndtri=weight5 if inrange(gestationalweek5,13,28.99)
gen weight6_2ndtri=weight6 if inrange(gestationalweek6,13,28.99)

egen avg_weight_2ndtri=rowmean(weight1_2ndtri weight2_2ndtri weight3_2ndtri weight4_2ndtri weight5_2ndtri weight6_2ndtri)

*3rd trimester 
gen weight1_3rdtri=weight1 if inrange(gestationalweek1,29,42)
gen weight2_3rdtri=weight2 if inrange(gestationalweek2,29,42)
gen weight3_3rdtri=weight3 if inrange(gestationalweek3,29,42)
gen weight4_3rdtri=weight4 if inrange(gestationalweek4,29,42)
gen weight5_3rdtri=weight5 if inrange(gestationalweek5,29,42)
gen weight6_3rdtri=weight6 if inrange(gestationalweek6,29,42)
gen weight7_3rdtri=weight7 if inrange(gestationalweek7,29,42)
gen weight8_3rdtri=weight8 if inrange(gestationalweek8,29,42)
gen weight9_3rdtri=weight9 if inrange(gestationalweek9,29,42)

egen avg_weight_3rdtri=rowmean(weight1_3rdtri weight2_3rdtri weight3_3rdtri weight4_3rdtri weight5_3rdtri weight6_3rdtri weight7_3rdtri weight8_3rdtri weight9_3rdtri)

*look for max_weight
egen highest_antenatal_weight=rowmax(weight1_1sttri-weight9_3rdtri)

egen highest_antenatal_weight_3rd=rowmax(weight1_3rdtri-weight9_3rdtri)

count if highest_antenatal_weight!=highest_antenatal_weight_3rd //47

br highest_antenatal_weight highest_antenatal_weight_3rd if highest_antenatal_weight!=highest_antenatal_weight_3rd 

count if highest_antenatal_weight_3rd!=float(last_antenatal_weight) //221

summ last_antenatal_weight_ga if highest_antenatal_weight!=float(last_antenatal_weight)

br last_antenatal_weight highest_antenatal_weight_3rd if highest_antenatal_weight_3rd!=float(last_antenatal_weight)

//total gwg

gen gwg=last_antenatal_weight-ppweight
summ gwg 

count if gwg<0 // 11

//Month and year since Sg arrival 
codebook q1_6_arrival_to_singapore_year q1_6_arrival_to_singapore_month

format q1_6_arrival_to_singapore_year %ty

encode q1_6_arrival_to_singapore_month, gen(sg_arrival_month_0)
recode sg_arrival_month_0 5=1 4=2 8=3 1=4 9=5 7=6 6=7 2=8 12=9 11=10 10=11 3=12 

label define sg_arrival_month_0lab 1"jan" 2"feb" 3"mar" 4"apr" 5"may" 6"jun" 7"jul" 8"aug" 9"sep" 10"oct" 11"nov" 12"dec"
label values sg_arrival_month_0 sg_arrival_month_0lab

gen monthyear_sg_arrival=ym(q1_6_arrival_to_singapore_year, sg_arrival_month_0)

format monthyear_sg_arrival %tm

gen monthyear_sg_arrival_1=monthyear_sg_arrival
replace monthyear_sg_arrival_1=1 if inrange(monthyear_sg_arrival, ym(1971,1), ym(1990,12))
replace monthyear_sg_arrival_1=2 if inrange(monthyear_sg_arrival, ym(1991,1), ym(1995,12))
replace monthyear_sg_arrival_1=3 if inrange(monthyear_sg_arrival, ym(1996,1), ym(2000,12))
replace monthyear_sg_arrival_1=4 if inrange(monthyear_sg_arrival, ym(2001,1), ym(2005,12))
replace monthyear_sg_arrival_1=5 if inrange(monthyear_sg_arrival, ym(2006,1), ym(2010,12))

label define monthyear_sg_arrival_1lab 1"1971-1990" 2"1991-1995" 3"1996-2000" 4"2001-2005" 5"2006-2010"
label values monthyear_sg_arrival_1 monthyear_sg_arrival_1lab

recode monthyear_sg_arrival_1 1/2=1 3=2 4=3 5=4, gen( monthyear_sg_arrival_2)

label define monthyear_sg_arrival_2lab 1"<=1995" 2"1996-2000" 3"2001-2005" 4"2006-2010"
label values monthyear_sg_arrival_2 monthyear_sg_arrival_2lab

/*
//highest occupation reported 
gen highest_occupation=m_occupation_0_1
replace highest_occupation=1 if m_occupation_0_1==2 & f_occupation_corrected_0_1==1 
replace highest_occupation=1 if m_occupation_0_1==3 & f_occupation_corrected_0_1==1
replace highest_occupation=1 if m_occupation_0_1==4 & f_occupation_corrected_0_1==1
replace highest_occupation=1 if m_occupation_0_1==. & f_occupation_corrected_0_1==1
replace highest_occupation=2 if m_occupation_0_1==3 & f_occupation_corrected_0_1==2
replace highest_occupation=2 if m_occupation_0_1==4 & f_occupation_corrected_0_1==2
replace highest_occupation=2 if m_occupation_0_1==. & f_occupation_corrected_0_1==2=
*/ 

//pm2.5 trimester 

/*
*old data
egen pm25_tri1= rowmean(avgpm25week1-avgpm25week12) 

egen pm25_tri2= rowmean(avgpm25week13-avgpm25week28)

egen pm25_tri3= rowmean(avgpm25week29-avgpm25week42)


*new data 
egen pm25_tri1_1= rowmean(day_1-day_90)  

egen pm25_tri2_1= rowmean(day_91-day_195)

egen pm25_tri3_1= rowmean(day_196-day_295) 
*/

*missing pm25_tri3 but not tri1 and tri2
list subjectid ga2 if pm25_tri2!=. & pm25_tri3==.

+-----------------+
      | subjectid   ga2 |
      |-----------------|
 500. | 010-21064    28 |
 836. | 010-21792    28 |
1246. | 020-66052    28 |
1253. | 020-66069    26 |
      +-----------------+

// avg pm2.5 across pregnancy period using trimester 
/*
egen pm25_avg_tri= rowmean(pm25_tri1-pm25_tri3)
egen pm25_avg_daily=rowmean(pm251-pm25294)
*/

egen pm25_avg_daily_1=rowmean(day_1-day_295)

*Recat/group variables 
******************
//mpm3cot mpm3cot2 mpm3c3hc mpm3c3hc22 pfpea pfhxa mmp mcpp mbzp coded as binary due to >80% undetected 

gen mpm3cot_bin=mpm3cot
replace mpm3cot_bin=1 if mpm3cot!=0 & mpm3cot!=.

label define mpm3cot_binlab 0 "undetected" 1 "detected"
label values mpm3cot_bin mpm3cot_binlab

gen mpm3cot2_bin=mpm3cot2
replace mpm3cot2_bin=1 if mpm3cot2!=0 & mpm3cot2!=.

label define mpm3cot2_binlab 0 "undetected" 1 "detected"
label values mpm3cot2_bin mpm3cot2_binlab

gen mpm3c3hc_bin=mpm3c3hc
replace mpm3c3hc_bin=1 if mpm3c3hc!=0 & mpm3c3hc!=.

label define mpm3c3hc_binlab 0 "undetected" 1 "detected"
label values mpm3c3hc_bin mpm3c3hc_binlab

gen mpm3c3hc2_bin=mpm3c3hc2
replace mpm3c3hc2_bin=1 if mpm3c3hc2!=0 & mpm3c3hc2!=.

label define mpm3c3hc2_binlab 0 "undetected" 1 "detected"
label values mpm3c3hc2_bin mpm3c3hc2_binlab

/*foreach var of varlist pfpea pfhxa mmp mcpp mbzp {
	gen `var'_bin=`var'
	replace `var'_bin=0 if `var'==. & labid_0!=. & labid_0!=668
	replace `var'_bin=1 if `var'!=. & `var'_bin!=0 
	label define `var'_binlab 0 "undetected" 1 "detected"
	label values `var'_bin `var'_binlab
	tab `var'_bin
}
*/

//m_place_of_birth_0
recode m_place_of_birth_0 3=1 5=2 6=3 9=4 12=5 1 2 4 7 8 10 11 13/15=6, gen(m_place_of_birth_0_1)

label define m_place_of_birth_0_1lab 1"China" 2"India" 3"Indonesia" 4"Malaysia" 5"Singapore" 6"Others" 
label values m_place_of_birth_0_1 m_place_of_birth_0_1lab

//m_highest_education_0
recode m_highest_education_0 3/4=1 2 5=2 1=3 6=4, gen(m_highest_education_0_1)

label define m_highest_education_0_1lab 1"None/primary" 2"Secondary/ITE" 3"A-level/poly/diploma" 4"University/Postgrad"
label values m_highest_education_0_1 m_highest_education_0_1lab

recode m_highest_education_0 3/4=1 5=2 2=3 1=4 6=5, gen(m_highest_education_0_2)

label define m_highest_education_0_2lab 1"None/primary" 2"Secondary" 3"ITE" 4"A-level/poly/diploma" 5"University/Postgrad"
label values m_highest_education_0_2 m_highest_education_0_2lab

//m_occupation_0
recode m_occupation_0 4/6=1 7/11=2 12=3 1/3=4, gen(m_occupation_0_1)

label define m_occupation_0_1lab 1"High" 2"Medium" 3"Homemaker"4"Student/unemployed/others"
label values m_occupation_0_1 m_occupation_0_1lab

recode m_occupation_0 1/3=1 9/11=2 12=3, gen(m_occupation_0_2)

label define m_occupation_0_2lab 1"Student/unemployed/others" 2"Agri/craftman/operator" 3"Homemaker" 4 "Legislator/senior official" 5"Professional" 6"Technician/associated professional" 7"Clerical worker" 8"Service worker" 
label values m_occupation_0_2 m_occupation_0_2lab

//accomodation_0
recode accommodation_0 4/6=4 7=5, gen (accommodation_0_1)

label define accommodation_0_1lab 1"1-2-room hdb" 2"3-room hdb" 3"4-room hdb" 4 "condo/hudc/landed" 5"others"
label values accommodation_0_1 accommodation_0_1lab

//accomodation_0_1
recode accommodation_0_1 5=., gen(accommodation_0_2)

label define accommodation_0_2lab 1"1-2-room hdb" 2"3-room hdb" 3"4-room hdb" 4 "condo/hudc/landed" 
label values accommodation_0_2 accommodation_0_2lab

//parity
recode parity 3/7=3, gen(parity_1)
label define parity_1lab 3">=3"
label values parity_1 parity_1lab

//f_education_corrected_0
recode f_education_corrected_0 1/2=1 3/4=2 5=3 6=4, gen(f_education_corrected_0_1)

label define f_education_corrected_0_1lab 1"None/primary" 2"Secondary/ITE" 3"A-level/poly/diploma" 4"University/Postgrad"
label values f_education_corrected_0_1 f_education_corrected_0_1lab

recode f_education_corrected_0 1/2=1 3=2 4=3 5=4 6=5, gen(f_education_corrected_0_2)

label define f_education_corrected_0_2lab 1"None/primary" 2"Secondary" 3"ITE" 4"A-level/poly/diploma" 5"University/Postgrad"
label values f_education_corrected_0_2 f_education_corrected_0_2lab

//f_occupation_corrected_0
recode f_occupation_corrected_0 5/7=1 8/12=2 1/3 13=3 4=., gen(f_occupation_corrected_0_1)

label define f_occupation_corrected_0_1lab 1"high" 2"medium" 3"student/unemployed/others/homemaker" 
label values f_occupation_corrected_0_1 f_occupation_corrected_0_1lab

recode f_occupation_corrected_0 1/3 13=1 10/12=2 5=3 6=4 7=5 8=6 9=7 4=. , gen(f_occupation_corrected_0_2)

labe define f_occupation_corrected_0_2lab 1"student/unemployed/others/homemaker" 2"agri/prod/operator" 3"legislator/senior official" 4"professional" 5"technician/associated professional" 6"clerical" 7"service"
label values f_occupation_corrected_0_2 f_occupation_corrected_0_2lab

//f_monthly_income_0
recode f_monthly_income_0 1/2=1 3=2 4=3 5=4, gen(f_monthly_income_0_1)

label define f_monthly_income_0_1lab 1"<2000" 2"2000-3999" 3"4000-5999" 4">=6000"
label values f_monthly_income_0_1 f_monthly_income_0_1lab

//f_household_income_0
recode f_household_income_0 1/2=1 3=2 4=3 5=4, gen(f_household_income_0_1)

label define f_household_income_0_1lab 1"<2000" 2"2000-3999" 3"4000-5999" 4">=6000"
label values f_household_income_0_1 f_household_income_0_1lab

//household_income_0
recode household_income_0 1/2=1 3=2 4=3 5=4, gen(household_income_0_1)
label define household_income_0_1lab 1 "<2000" 2 "2000-3999" 3 "4000-5999" 4 ">6000"
label value household_income_0_1 household_income_0_1lab


//mhc1hmn 
list subjectid mhc1hmn if mhc1lohm==0 & mhc1hmn!=0

      +---------------------+
      | subjectid   mhc1hmn |
      |---------------------|
1049. | 020-00018         1 |
      +---------------------+

list mhc1hmcn mhc1hman mhc1hmn mhc1lohm mhc1ar1 if subjectid=="020-00018"

*need to recode mhc1lohm of subject 020-00018 due to discrepancies in mhc1hmn (living with husband but answered no for iving with others)
recode mhc1lohm 0=1 if subjectid=="020-00018"

recode mhc1hmn 6/11=6, gen(mhc1hmn_1)

label define mhc1hmn_1lab 6">5"
label values mhc1hmn_1 mhc1hmn_1lab

//mhc1hmcn
recode mhc1hmcn 3/7=3, gen(mhc1hmcn_1)

label define mhc1hmcn_1lab 3">2"
label values mhc1hmcn_1 mhc1hmcn_1lab

//mhc1hman 
recode mhc1hman 4/7=4, gen(mhc1hman_1)

label define mhc1hman_1lab 4">3"
label values mhc1hman_1 mhc1hman_1lab

//sai
xtile sai_quart=sai, nq(4)

label define sai_quartlab 1"=<93.5" 2"93.6-95" 3"95.1-97.2" 4">97.2"
label values sai_quart sai_quartlab

//sedi
xtile sedi_quart=sedi, nq(4)

label define sedi_quartlab 1"=<100.2" 2"100.3-101.6" 3"101.7-105.6" 4">105.6"
label values sedi_quart sedi_quartlab

//PA
recode pa_0 3 5 7 11 12 16 17 18 19 22 23 28=1 24 30 31=2 1 13 21 25 26=3 2 8 20 27=4 4 6 9 10 14 15 29=5, gen(region)

label define regionlab 1 "central" 2 "north" 3 "northeast" 4 "east" 5 "west" 
label values region regionlab

/*
*Correction for blood colletion dates due to swapped month and date 
**************************************************************
// change date 
*1.    010-14007 // 10aug2009 
gen col_corrected=col 
replace col_corrected=td(08oct2009) if subjectid=="010-14007"

*2.    010-20168 // 01jun2010 
replace col_corrected=td(06jan2010) if subjectid=="010-20168"

*3.    010-20171 // 12jul2009 
replace col_corrected=td(07dec2009) if subjectid=="010-20171"

*4.    010-20343 // 02mar2010 
replace col_corrected=td(03feb2010) if subjectid=="010-20343"

*5.    010-20346 // 02nov2010
replace col_corrected=td(11feb2010) if subjectid=="010-20346"

*6.    010-20351 // 02nov2010
replace col_corrected=td(11feb2010) if subjectid=="010-20351"

*7.    010-20359 // 02mar2010
replace col_corrected=td(03feb2010) if subjectid=="010-20359"

*8.    010-20380 // 03may2010
replace col_corrected=td(05mar2010) if subjectid=="010-20380"

*9.    010-20393 // 03may2010
replace col_corrected=td(05mar2010) if subjectid=="010-20393"

*10.   010-20440 // 03feb2010 
replace col_corrected=td(02mar2010) if subjectid=="010-20440"

*11.   010-20474 //  02aug2010
replace col_corrected=td(08feb2010) if subjectid=="010-20474"

*12.   010-20487 //  03aug2010
replace col_corrected=td(08mar2010) if subjectid=="010-20487"

*13.   010-20494 //  10nov2010 
replace col_corrected=td(11oct2010) if subjectid=="010-20494"

*14.   010-20500 //  02dec2010
replace col_corrected=td(12feb2010) if subjectid=="010-20500"

*15.   010-20501 //  03jan2010 
replace col_corrected=td(01mar2010) if subjectid=="010-20501"

*16.   010-20536 // 04dec2010 
replace col_corrected=td(12apr2010) if subjectid=="010-20536"

*17.   010-20542 // 04jul2010
replace col_corrected=td(07apr2010) if subjectid=="010-20542"

*18.   010-20548 // 03dec2010
replace col_corrected=td(12mar2010) if subjectid=="010-20548" 

*19.   010-20558 // 04aug2010 
replace col_corrected=td(08apr2010) if subjectid=="010-20558"

*20.   010-21332 // 08apr2010 
replace col_corrected=td(04aug2010) if subjectid=="010-21332"

*21.   010-21340 // 08oct2010 
replace col_corrected=td(10aug2010) if subjectid=="010-21340" 

*22.   010-21348 // 08mar2010
replace col_corrected=td(03aug2010) if subjectid=="010-21348" 

*23.   010-21366 // 08may2010 
replace col_corrected=td(05aug2010) if subjectid=="010-21366"

*24.   010-21426 // 08apr2010 
replace col_corrected=td(04aug2010) if subjectid=="010-21426" 

*25.   010-21438 // 08nov2010
replace col_corrected=td(11aug2010) if subjectid=="010-21438"

*26.   010-21443 // 09mar2010
replace col_corrected=td(03sep2010) if subjectid=="010-21443"

*27.   010-21495 // 09jun2010 
replace col_corrected=td(06sep2010) if subjectid=="010-21495" 

*28.   010-21887 // 11dec2010 
replace col_corrected=td(12nov2010) if subjectid=="010-21887"

format col_corrected %td

// change month
gen col_mo_corrected=col_mo 
replace col_mo_corrected=month(col_corrected)

*/

*Discrepancies in country of birth 
**********************************
/*
tab m_cob m_place_of_birth_0

list subjectid m_place_of_birth_0 m_birth_place_0 m_birth_place_others_0 if m_place_of_birth_0==3 & m_cob==7   

+-----------------------------------------------------------------+
      | subjectid   m_plac~0   m_bi~e_0          m_birth_place_others_0 |
      |-----------------------------------------------------------------|
   3. | 010-04006      China   9_others   Kuala Lumpur General Hospital |
      +-----------------------------------------------------------------+

list subjectid m_place_of_birth_0 m_birth_place_0 m_birth_place_others_0 if m_place_of_birth_0==3 & m_cob==200 

 +-----------------------------------------------+
      | subjectid   m_plac~0   m_birth~e_0   m_bi~s_0 |
      |-----------------------------------------------|
 609. | 010-21322      China   1_kk_womens          . |
      +-----------------------------------------------+


list subjectid m_place_of_birth_0 m_birth_place_0 m_birth_place_others_0 if m_place_of_birth_0==4 & m_cob==200    
+-----------------------------------------------+
      | subjectid   m_plac~0   m_birth~e_0   m_bi~s_0 |
      |-----------------------------------------------|
 330. | 010-20672   HongKong   1_kk_womens          . |
      +-----------------------------------------------+

list subjectid m_place_of_birth_0 m_birth_place_0 m_birth_place_others_0 if m_place_of_birth_0==5 & m_cob==200 

+-----------------------------------------------+
      | subjectid   m_plac~0   m_birth~e_0   m_bi~s_0 |
      |-----------------------------------------------|
 658. | 010-21426      India   1_kk_womens          . |
      +-----------------------------------------------+


list subjectid m_place_of_birth_0 m_birth_place_0 m_birth_place_others_0 if m_place_of_birth_0==6 & m_cob==200 

 +------------------------------------------------+
      | subjectid   m_place~0   m_birth~e_0   m_bi~s_0 |
      |------------------------------------------------|
  23. | 010-04076   Indonesia   1_kk_womens          . |
 596. | 010-21285   Indonesia   1_kk_womens          . |
1041. | 010-22184   Indonesia   1_kk_womens          . |
      +------------------------------------------------+

list subjectid m_place_of_birth_0 m_birth_place_0 m_birth_place_others_0 if m_place_of_birth_0==9 & m_cob==200 

 +-----------------------------------------------+
      | subjectid   m_plac~0   m_birth~e_0   m_bi~s_0 |
      |-----------------------------------------------|
  52. | 010-14012   Malaysia   1_kk_womens          . |
  54. | 010-14020   Malaysia   1_kk_womens          . |
 265. | 010-20501   Malaysia   1_kk_womens          . |
 459. | 010-20993   Malaysia   1_kk_womens          . |
 650. | 010-21403   Malaysia   1_kk_womens          . |
      +-----------------------------------------------+

list subjectid m_place_of_birth_0 m_birth_place_0 m_birth_place_others_0 if m_place_of_birth_0==10 & m_cob==13 
	  
	   +--------------------------------------------+
      | subjectid   m_plac~0   m_bi~e_0   m_bi~s_0 |
      |--------------------------------------------|
 455. | 010-20986    Myanmar   9_others   Thailand |
      +--------------------------------------------+
	  
list subjectid m_place_of_birth_0 m_birth_place_0 m_birth_place_others_0 if m_place_of_birth_0==12 & m_cob==2 

 +----------------------------------------------------+
      | subjectid   m_place~0   m_bi~e_0   m_birth_pla~s_0 |
      |----------------------------------------------------|
 532. | 010-21153   Singapore   9_others        CHINA-BORN |
 732. | 010-21580   Singapore   9_others   China Guangdong |
1036. | 010-22175   Singapore   9_others    China hospital |
      +----------------------------------------------------+

list subjectid m_place_of_birth_0 m_birth_place_0 m_birth_place_others_0 if m_place_of_birth_0==12 & m_cob==3 

 +---------------------------------------------+
      | subjectid   m_place~0   m_bi~e_0   m_bi~s_0 |
      |---------------------------------------------|
 481. | 010-21035   Singapore   9_others      India |
 889. | 010-21921   Singapore   9_others      India |
      +---------------------------------------------+

list subjectid m_place_of_birth_0 m_birth_place_0 m_birth_place_others_0 if m_place_of_birth_0==12 & m_cob==7 

 +---------------------------------------------------------------+
      | subjectid   m_place~0   m_bi~e_0       m_birth_place_others_0 |
      |---------------------------------------------------------------|
  97. | 010-20102   Singapore   9_others   Hospital Segamat, Malaysia |
 243. | 010-20443   Singapore   9_others                     Malaysia |
 356. | 010-20746   Singapore   9_others                     Malaysia |
 482. | 010-21036   Singapore   9_others                     Malaysia |
 586. | 010-21263   Singapore   9_others            MALAYSIA HOSPITAL |
      |---------------------------------------------------------------|
 681. | 010-21478   Singapore   9_others                     Malaysia |
      +---------------------------------------------------------------+

list subjectid m_place_of_birth_0 m_birth_place_0 m_birth_place_others_0 if m_place_of_birth_0==13 & m_cob==200 

 +-----------------------------------------------+
      | subjectid   m_plac~0   m_birth~e_0   m_bi~s_0 |
      |-----------------------------------------------|
 104. | 010-20117   SriLanka   1_kk_womens          . |
      +-----------------------------------------------+

// 25 discrepancies 	  
	  
list subjectid m_place_of_birth_0 m_birth_place_0 m_birth_place_others_0 if m_place_of_birth_0!=. & m_birth_place_others_0!=. & m_cob==. 

 +-------------------------------------------------------------+
      | subjectid   m_place~0   m_bi~e_0     m_birth_place_others_0 |
      |-------------------------------------------------------------|
  16. | 010-04048   Indonesia   9_others                 Don't know |
  18. | 010-04063   Indonesia   9_others                    At home |
  69. | 010-20001   Singapore   9_others          Memorial hospital |
 181. | 010-20301       China   9_others              Not in S'pore |
 184. | 010-20313   Singapore   9_others                       Home |
      |-------------------------------------------------------------|
 360. | 010-20754   Singapore   9_others                    At Home |
 363. | 010-20759   Singapore   9_others                    At home |
 406. | 010-20865   Singapore   9_others                       Home |
 415. | 010-20894       India   9_others                unspecified |
 431. | 010-20944   Singapore   9_others                     Stairs |
      |-------------------------------------------------------------|
 518. | 010-21125   Indonesia   9_others                 Don't know |
 592. | 010-21274   Singapore   9_others   SUBJECT WAS BORN AT HOME |
 631. | 010-21362   Singapore   9_others                       HOME |
 655. | 010-21411   Singapore   9_others                    AT HOME |
 670. | 010-21448   Indonesia   9_others                unspecified |
      |-------------------------------------------------------------|
 677. | 010-21460   Singapore   9_others                    At home |
 716. | 010-21549   Singapore   9_others             Can't remember |
 720. | 010-21561   Singapore   9_others                       Home |
 776. | 010-21672   Singapore   9_others                 In the car |
 801. | 010-21724   Singapore   9_others                       Home |
      |-------------------------------------------------------------|
 835. | 010-21791   Singapore   9_others                    At home |
 850. | 010-21825       China   9_others               Home-midwife |
 885. | 010-21898   Singapore   9_others       Closed down hospital |
 946. | 010-22018   Singapore   9_others                    At home |
1000. | 010-22120   Singapore   9_others                    At home |
      |-------------------------------------------------------------|
1003. | 010-22123    Malaysia   9_others                    At home |
1062. | 020-00052   Singapore   9_others         Hua Khoon Hospital |
1069. | 020-02005   Singapore   9_others                    At home |
1117. | 020-04299   Singapore   9_others                    At home |
1153. | 020-08065   Singapore   9_others                    At home |
      |-------------------------------------------------------------|
1171. | 020-50039   Singapore   9_others                    At home |
1207. | 020-50166   Singapore   9_others           St Mark Hospital |
1235. | 020-66019       China   9_others                  Own house |
1264. | 020-66104   Singapore   9_others                       HOME |
1268. | 020-66115   Singapore   9_others             PRIVATE CLINIC |
      +-------------------------------------------------------------+
*/
	  
**log close 
	  
save merged_obj_clean_updated, replace






