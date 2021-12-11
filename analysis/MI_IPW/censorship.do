/* e:\sumkk\ses-exposome\data\raw_data\
DO file e:\sumkk\ses-exposome\data\do_files\censorship
Censorship
Jan 26 2021, Ka Kei Sum
Dataset: 
  e:\sumkk\ses-exposome\data\raw_data\obj_clean_transformed_standardized (1193 vars, 1,344 obs)
*/

cd "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\raw_data"
capture log close  
log using e:\sumkk\ses-exposome\data\log_files\censorship.log, replace 
set more off

/*
import excel "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\raw_data\LTFU_20210125.xlsx", sheet("Sheet1") firstrow case(lower) clear
// 6 vars, 1,468 obs)

merge 1:1 subjectid using merged_obj_updated

keep subjectid-status_del stress_daily_life_pw11 general_health_pw11 stress_affected_health_pw11 ppbmi self_reported_smoking_pw26

merge 1:1 subjectid using obj_clean_transformed_standardized

keep if _merge==3

keep subjectid-stress_daily_life_pw11 stress_daily_life_pw11 m_age_recruitment general_health_pw11 stress_affected_health_pw11 m_highest_education_0_1 m_place_of_birth_0_2 m_ethnicity_0 m_occupation_0_1 m_citizenship_0 marital_status_0 household_income_0_1 m_income_0 region parity_1 ppbmi self_reported_smoking_pw26 

merge 1:1 subjectid using LTFU_reasons 

keep if _merge==3

drop _merge 

drop if m_age_recruitment==.

save censorship, replace 
*/

use blood_col_inv, clear 

keep subjectid dh 

merge 1:1 subjectid using censorship

keep if _merge==3

drop _merge 

save censorship, replace 

use censorship, clear 

misstable summconvert

/*
gen status_pw26_cens=0
replace status_pw26_cens=1 if status_pw26=="active" 
logit status_pw26_cens m_age_recruitment i.m_ethnicity_0 i.m_highest_education_0_1 i.household_income_0_1 i.m_place_of_birth_0_2 i.m_occupation_0_1 i.m_citizenship_0 
predict pr_status_pw26, pr
*/

foreach var of varlist m_highest_education_0_1 household_income_0_1 m_place_of_birth_0_2 m_income_0 m_occupation_0_1 region m_citizenship_0 marital_status_0 parity_1 {
	tab  status_pw26_cens `var'
}

recode marital_status_0 2/3=2 4/5=3 
label define mar_lab 1 "divorced" 2 "married" 3 "single"
label values marital_status_0 mar_lab

foreach var of varlist self_reported_smoking_pw26 general_health_pw11 stress_affected_health_pw11 stress_daily_life_pw11 {
	encode `var', gen(`var'_1)
	tab `var'_1, nolab 
}

recode stress_affected_health_pw11_1 1 4=1 2=2 3=0 5=3
label define stress_health_lab 0 "none" 1 " very much" 2 "moderately" 3 "slightly"
label values stress_affected_health_pw11_1 stress_health_lab


recode stress_daily_life_pw11_1 2 5=1 1=2 4=0 3=3
label define stress_lab 0 "none" 1 " very much" 2 "moderately" 3 "slightly"
label values stress_daily_life_pw11_1 stress_lab


//impute for missingness in predictor model 

mi set flong 

mi register imputed m_highest_education_0_1 household_income_0_1 m_place_of_birth_0_2 m_occupation_0_1 region m_citizenship_0 marital_status_0 parity_1 stress_daily_life_pw11_1 stress_affected_health_pw11_1 self_reported_smoking_pw26_1 ppbmi dh

mi register regular m_ethnicity_0 m_age_recruitment 

mi impute chained ///
(pmm, knn(3)) m_highest_education_0_1 household_income_0_1 m_place_of_birth_0_2 m_occupation_0_1 region m_citizenship_0 marital_status_0 parity_1 stress_daily_life_pw11_1 stress_affected_health_pw11_1 self_reported_smoking_pw26_1 ppbmi dh ///
= m_age_recruitment m_ethnicity_0, replace add(10) rseed(53421) 

midiagplots m_highest_education_0_1 household_income_0_1 m_place_of_birth_0_2 m_occupation_0_1 region m_citizenship_0 marital_status_0 parity_1 stress_daily_life_pw11_1 stress_affected_health_pw11_1 self_reported_smoking_pw26_1 ppbmi dh, m(1) 

save "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\mi_data\censorship", replace

use "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\mi_data\censorship", clear

//gen a variable indicating those LTFU since baseline 
//covariates that predict missingness: maternal age, ethnicity, nativity, maternal education, maternal occupation, m_citizenship_0, household income, region, marital status, parity, stress in life, stress affected health, ppbmi, smoker 

foreach var of varlist status_pw26 status_del {
	mi xeq: gen `var'_cens=0
	mi xeq: replace `var'_cens=1 if `var'=="active" 
	mi estimate, esampvaryok saving(est_`var', replace): logit `var'_cens m_age_recruitment i.m_ethnicity_0 i.m_highest_education_0_1 i.household_income_0_1 i.m_place_of_birth_0_2 i.m_occupation_0_1 i.region i.m_citizenship_0 i.marital_status_0 i.parity_1 i.stress_daily_life_pw11_1 i.stress_affected_health_pw11_1 i.self_reported_smoking_pw26_1 ppbmi i.dh
	mi predict pr_`var' using est_`var'
	mi xeq: gen prf_`var' = invlogit(pr_`var')
	mi xeq: gen w_`var'=. 
	mi xeq: replace  w_`var'=1/(prf_`var') 
	hist prf_`var', by(`var'_cens)
}

//hist prf_status_del, by(status_del_cens)

// to check for GOF 
/*
qui mi query 
local M=r(M)
scalar r2=0
scalar cstat=0
qui mi xeq 1/`M': logit status_del_cens m_age_recruitment i.m_ethnicity_0 i.m_highest_education_0_1 i.household_income_0_1 i.m_place_of_birth_0_2 i.m_occupation_0_1 i.region i.m_citizenship_0 i.marital_status_0 i.parity_1 i.stress_daily_life_pw11_1 i.stress_affected_health_pw11_1 i.self_reported_smoking_pw26_1 ppbmi; scalar r2=r2+e(r2_p); lroc, nog; scalar cstat=cstat+r(area)
scalar r2=r2/`M'
scalar cstat=cstat/`M'
noi di "Pseudo R=squared over imputed data = " r2
noi di "C statistic over imputed data = " cstat
*/

mi extract 0, clear

save "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\mi_data\censorship_full", replace

tab status_pw26_cens, summ(w_status_pw26) 
summ w_status_pw26 if status_pw26_cens==1
summ w_status_pw26 if status_pw26_cens==0
hist w_status_pw26, by(status_pw26_cens)

tab status_del_cens, summ(w_status_del)
hist w_status_del, by(status_del_cens)

xtile w26_quintile=w_status_pw26, n(5)
xtile wdel_quintile=w_status_del, n(5)

tabstat w_status_pw26, s(n min max) by(w26_quintile)

w26_quintile |         N       min       max
-------------+------------------------------
           1 |       268   1.00831   1.10743
           2 |       268  1.107721  1.137435
           3 |       268   1.13749  1.167921
           4 |       268  1.168052  1.203007
           5 |       267  1.203089  1.718251
-------------+------------------------------
       Total |      1339   1.00831  1.718251
--------------------------------------------


tab w26_quintile, summ(w_status_pw26)

//non-imputed 
5 quantiles |
         of |
w_status_pw |      Summary of w_status_pw26
         26 |        Mean   Std. Dev.       Freq.
------------+------------------------------------
          1 |   1.1024822    .0114395         260
          2 |   1.1318027    .0121746         260
          3 |   1.1548873   .00399714         260
          4 |   1.1715185   .00772276         260
          5 |   1.2256211   .03641524         260
------------+------------------------------------
      Total |   1.1572624   .04519517       1,300

	  
//imputed

5 quantiles |
         of |
w_status_pw |      Summary of w_status_pw26
         26 |        Mean   Std. Dev.       Freq.
------------+------------------------------------
          1 |   1.0792977   .02753471         268
          2 |   1.1243821   .00942646         268
          3 |   1.1544153   .00754181         268
          4 |   1.1843925   .01048587         268
          5 |   1.2787697   .08339262         267
------------+------------------------------------
      Total |   1.1641659   .07788755       1,339

//imputed + dh

5 quantiles |
         of |
w_status_pw |      Summary of w_status_pw26
         26 |        Mean   Std. Dev.       Freq.
------------+------------------------------------
          1 |   1.0781331   .02763003         268
          2 |   1.1226087   .00844541         268
          3 |   1.1522207   .00851313         268
          4 |   1.1838352   .01052299         268
          5 |   1.2831145   .09110991         267
------------+------------------------------------
      Total |   1.1638935   .08130975       1,339


tabstat w_status_del, s(n min max) by(wdel_quintile)


wdel_quintile |         N       min       max
--------------+------------------------------
            1 |       268  1.040754  1.148229
            2 |       268   1.14828  1.184789
            3 |       268  1.184806  1.226701
            4 |       268  1.226733  1.281977
            5 |       267  1.282557  1.971429
--------------+------------------------------
        Total |      1339  1.040754  1.971429
---------------------------------------------


tab wdel_quintile, summ(w_status_del)

//non-imputed 
5 quantiles |
         of |
w_status_de |       Summary of w_status_del
          l |        Mean   Std. Dev.       Freq.
------------+------------------------------------
          1 |   1.1430743   .01113883         260
          2 |   1.1691491    .0095702         260
          3 |   1.2109093   .01015394         260
          4 |   1.2388874   .01011331         260
          5 |   1.3118684   .05424576         260
------------+------------------------------------
      Total |   1.2147777    .0642071       1,300

	  
//imputed

5 quantiles |
         of |
w_status_de |       Summary of w_status_del
          l |        Mean   Std. Dev.       Freq.
------------+------------------------------------
          1 |   1.1248158   .02256056         268
          2 |   1.1688271   .01026326         268
          3 |   1.2085382   .01251437         268
          4 |   1.2526528   .01571301         268
          5 |   1.3805719    .1187194         267
------------+------------------------------------
      Total |   1.2269665   .10334772       1,339

// imputed+dh

5 quantiles |
         of |
w_status_de |       Summary of w_status_del
          l |        Mean   Std. Dev.       Freq.
------------+------------------------------------
          1 |   1.1224851   .02197151         268
          2 |   1.1667471   .01074433         268
          3 |   1.2063677   .01195065         268
          4 |   1.2513654   .01656788         268
          5 |    1.387835    .1255484         267
------------+------------------------------------
      Total |   1.2268399   .10778456       1,339

	  
//keep subjectid-status_del reason status_pw26_cens-wdel_quintile

keep subjectid status_pw26_cens status_del_cens w_status_pw26 w_status_del w26_quintile wdel_quintile

//generate dummy variable
foreach var of varlist w26_quintile wdel_quintile {
	tab `var', gen(`var')
}

save "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\mi_data\censorship1", replace 

//save censorship2, replace 

egen pc90_26=pctile(w_status_pw26) ,p(90)

gen top10=(w_status_pw26 > pc90_26) if w_status_pw26 < .

tabstat w_status_pw26 if top10==1, s(sum)

 variable |       sum
-------------+----------
w_status_~26 |  177.6805
------------------------

tabstat w_status_pw26 if status_pw26_cens==1, s(sum)

 variable |       sum
-------------+----------
w_status_~26 |   1334.13
------------------------

egen pc90_del=pctile(w_status_del) ,p(90)

gen top10_del=(w_status_del > pc90_del) if w_status_del < .

tabstat w_status_del if top10==1, s(sum)

 
    variable |       sum
-------------+----------
w_status_del |  191.4441
------------------------

tabstat w_status_del if status_del_cens==1, s(sum)


    variable |       sum
-------------+----------
w_status_del |  1335.288
------------------------









