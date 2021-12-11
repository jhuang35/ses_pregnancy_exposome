/* "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\raw_data\
DO file "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\do_files\mc2##cob_mi
MI mi estimate: regression mc2#cob
23 Feb 2020, Ka Kei Sum
Dataset: 
*/

cd "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\mi_data\mi_clean_full"
capture log close  
log using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\log_files\mc2#cob_mi_full.log", replace 
set more off

/*
s_sbp_avg ls_dbp_avg ls_map_avg /// 
ls_m_weight_pw26 ls_m_height_pw26 ls_m_midarm_pw26 s_m_triceps_pw26 ls_m_biceps_pw26 s_m_subscapular_pw26 s_m_suprailiac_pw26 ls_avg_weight_1sttri ls_avg_weight_2ndtri ls_avg_weight_3rdtri ls_last_antenatal_weight ///
ls_mpm3na ls_mpm3mg ls_mpm3p ls_mpm3k ls_mpm3ca ls_mpm3fe ls_mpm3fr ls_mpm3cu ls_mpm3zn s_mpm3se ls_mpm3tr ///
ls_mpm3my ls_mpm3pal ls_mpm3pl ls_mpm3st ls_mpm3ol ls_mpm3cv ls_mpm3li ls_mpm3li6 ls_mpm3li3 ls_mpm320 ls_mpm3n9 s_mpm32n6 ls_mpm33n6 ls_mpm3ar6 ls_mpm322 ls_mpm3n3 ls_mpm3epa ls_mpm3n62 ls_mpm3dpa ls_mpm3dha ls_mpm3tfa ls_mpm3tn3 ls_mpm3tn6 ls_mpm3sfa ls_mpm3muf ls_mpm3puf ///
ls_mpm3fmn2 ls_mpm3neo2 ls_mpm3ribo2 ls_mpm3mnam2 ls_mpm3nam2 ls_mpm3trig2 ls_mpm3py2 ls_mpm3plpb2 ls_mpm3pabe2 ls_mpm3fo ls_mpm3b12p s_mpm3vd3 ///
ls_mpm3arg2 ls_mpm3adma2 s_mpm3crn2 s_mpm3crea2 ls_mpm3harg2 ls_mpm3sdma2 ls_mpm3tml2 ls_mpm3csta2 ls_mpm3hcy2 s_mpm3tcys2 ls_mpm3m1hs2 ls_mpm3m3hs2 ls_mpm3hist2 ls_mpm3met2 ls_mpm3mtso2 ls_mpm3haa2 ls_mpm3hk2 ls_mpm3aa2 ls_mpm3ka2 ls_mpm3kyn2 ls_mpm3qa2 s_mpm3trp2 ls_mpm3xa2 ls_mpm3betn2 ls_mpm3chol2 ls_mpm3dmg2 ls_mpm3tmao2 ///
ls_m_ogtt_fasting_pw26  ls_m_ogtt_2hour_pw26 ///
ls_adiponectin ls_pai1 ls_resistin ls_mcp1 ls_fsh ls_gh ls_lh ls_tsh ls_igfi ls_igfii ls_igfbp1 ls_igfbp3 ls_igfbp7 ls_cpeptide ls_leptin ls_crp ls_ifng ls_tnfa ls_igfbp4 ls_insulin ///
ls_pfba ls_pfhpa ls_pfna ls_pfda ls_pfunda ls_pfdoda ls_pfhxs ls_pfoa ls_pfbs ls_pfos ///
s_psi_tri1 s_psi_tri2 s_psi_tri3 s_psi_pregnancy s_pm25_1st s_pm25_2nd s_pm25_3rd s_pm25_avg_daily_1 
*/

*mc2
******

*BP 

use bp, clear

local all s_sbp_avg ls_dbp_avg ls_map_avg /// 
ls_m_weight_pw26 ls_m_height_pw26 ls_m_midarm_pw26 s_m_triceps_pw26 ls_m_biceps_pw26 s_m_subscapular_pw26 s_m_suprailiac_pw26 ls_avg_weight_1sttri ls_avg_weight_2ndtri ls_avg_weight_3rdtri ls_last_antenatal_weight ///
ls_mpm3na ls_mpm3mg ls_mpm3p ls_mpm3k ls_mpm3ca ls_mpm3fe ls_mpm3fr ls_mpm3cu ls_mpm3zn s_mpm3se ls_mpm3tr ///
ls_mpm3my ls_mpm3pal ls_mpm3pl ls_mpm3st ls_mpm3ol ls_mpm3cv ls_mpm3li ls_mpm3li6 ls_mpm3li3 ls_mpm320 ls_mpm3n9 s_mpm32n6 ls_mpm33n6 ls_mpm3ar6 ls_mpm322 ls_mpm3n3 ls_mpm3epa ls_mpm3n62 ls_mpm3dpa ls_mpm3dha ls_mpm3tfa ls_mpm3tn3 ls_mpm3tn6 ls_mpm3sfa ls_mpm3muf ls_mpm3puf ///
ls_mpm3fmn2 ls_mpm3neo2 ls_mpm3ribo2 ls_mpm3mnam2 ls_mpm3nam2 ls_mpm3trig2 ls_mpm3py2 ls_mpm3plpb2 ls_mpm3pabe2 ls_mpm3fo ls_mpm3b12p s_mpm3vd3 ///
ls_mpm3arg2 ls_mpm3adma2 s_mpm3crn2 s_mpm3crea2 ls_mpm3harg2 ls_mpm3sdma2 ls_mpm3tml2 ls_mpm3csta2 ls_mpm3hcy2 s_mpm3tcys2 ls_mpm3m1hs2 ls_mpm3m3hs2 ls_mpm3hist2 ls_mpm3met2 ls_mpm3mtso2 ls_mpm3haa2 ls_mpm3hk2 ls_mpm3aa2 ls_mpm3ka2 ls_mpm3kyn2 ls_mpm3qa2 s_mpm3trp2 ls_mpm3xa2 ls_mpm3betn2 ls_mpm3chol2 ls_mpm3dmg2 ls_mpm3tmao2 ///
ls_m_ogtt_fasting_pw26  ls_m_ogtt_2hour_pw26 ///
ls_adiponectin ls_pai1 ls_resistin ls_mcp1 ls_fsh ls_gh ls_lh ls_tsh ls_igfi ls_igfii ls_igfbp1 ls_igfbp3 ls_igfbp7 ls_cpeptide ls_leptin ls_crp ls_ifng ls_tnfa ls_igfbp4 ls_insulin ///
ls_mbc3tg ls_mbc3ins ls_mbc3ast ls_mbc3hscp ls_mbc3alt ls_mbc3ura s_mbc3tc s_mbc3hdl s_mbc3ldl s_mbc3cre ///
ls_pfba ls_pfna ls_pfda ls_pfunda ls_pfhxs ls_pfoa ls_pfbs ls_pfos ///
s_psi_tri1 s_psi_tri2 s_psi_tri3 s_psi_pregnancy s_pm25_1st s_pm25_2nd s_pm25_3rd s_pm25_avg_daily_1 

local nX_all: word count `all'
di `nX_all'
matrix mc2_storep= J(`nX_all',3,.)
matrix rownames mc2_storep=`all'
matrix colnames mc2_storep="p_value_int" "p_value_xsg" "p_value_sg" 
local n=0

local replace replace

foreach var of varlist s_sbp_avg-ls_map_avg {
    loc n=`n'+1
	mi estimate: regress `var' c.Dim_2##i.m_place_of_birth_0_2 m_age_recruitment [pweight=w_status_del] , base vce(robust)
	regsave using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\dimensionality\coef\mca\mc_mi\raw/coef_mi2_xsg", ci `replace' table(`var', format(%9.2f))
	local replace append
	/*predict y1 
	twoway (scatter `var' mc2_quart##i.m_place_of_birth_0_2, ms(oh)) (line y1 mc2_quart##i.m_place_of_birth_0_2, sort) 
	graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\predicted_values\mv/lod_`var'.png", replace
	predict rs1, rstandard 
	qnorm rs1
	graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\residuals\qq\mv/lod_`var'.png", replace
	hist rs1
	graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\residuals\hist\mv/lod_`var'.png", replace
	twoway scatter rs1 y1, yline(0)
	graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\scatter_rs_y\mv/lod_`var'.png", replace
	drop y1 rs1*/
	mi test 1.m_place_of_birth_0_2#c.Dim_2 
	matrix mc2_storep[`n',1]=r(p)
	mi test c.Dim_2
	matrix mc2_storep[`n',2]=r(p)
}

local n=0
local replace replace

foreach var of varlist s_sbp_avg-ls_map_avg {
    loc n=`n'+1
    mi estimate: regress `var' c.Dim_2##ib1.m_place_of_birth_0_2 m_age_recruitment [pweight=w_status_del] , base vce(robust)
	regsave using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\dimensionality\coef\mca\mc_mi\raw/coef_mi2_sg", ci `replace' table(`var', format(%9.2f))
	local replace append 
	mi test c.Dim_2
	matrix mc2_storep[`n',3]=r(p)
}


*ANTHRO

use ls_m_weight_pw26, clear

mi estimate: regress ls_m_weight_pw26 c.Dim_2##i.m_place_of_birth_0_2 m_age_recruitment [pweight=w_status_pw26] , base vce(robust)
regsave using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\dimensionality\coef\mca\mc_mi\raw/coef_mi2_xsg", ci append table(ls_m_weight_pw26, format(%9.2f))
/*predict y1 
twoway (scatter `var' mc2_quart##i.m_place_of_birth_0_2, ms(oh)) (line y1 mc2_quart##i.m_place_of_birth_0_2, sort) 
graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\predicted_values\mv/lod_`var'.png", replace
predict rs1, rstandard 
qnorm rs1
graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\residuals\qq\mv/lod_`var'.png", replace
hist rs1
graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\residuals\hist\mv/lod_`var'.png", replace
twoway scatter rs1 y1, yline(0)
graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\scatter_rs_y\mv/lod_`var'.png", replace
drop y1 rs1*/
mi test 1.m_place_of_birth_0_2#c.Dim_2 
matrix mc2_storep[4,1]=r(p)
mi test c.Dim_2
matrix mc2_storep[4,2]=r(p)

mi estimate: regress ls_m_weight_pw26 c.Dim_2##ib1.m_place_of_birth_0_2 m_age_recruitment [pweight=w_status_pw26] , base vce(robust)
regsave using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\dimensionality\coef\mca\mc_mi\raw/coef_mi2_sg", ci append table(ls_m_weight_pw26, format(%9.2f))
mi test c.Dim_2
matrix mc2_storep[4,3]=r(p)

*******************************
use ls_m_height_pw26, clear

mi estimate: regress ls_m_height_pw26 c.Dim_2##i.m_place_of_birth_0_2 m_age_recruitment [pweight=w_status_pw26] , base vce(robust)
regsave using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\dimensionality\coef\mca\mc_mi\raw/coef_mi2_xsg", ci append table(ls_m_height_pw26, format(%9.2f))
/*predict y1 
twoway (scatter `var' mc2_quart##i.m_place_of_birth_0_2, ms(oh)) (line y1 mc2_quart##i.m_place_of_birth_0_2, sort) 
graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\predicted_values\mv/lod_`var'.png", replace
predict rs1, rstandard 
qnorm rs1
graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\residuals\qq\mv/lod_`var'.png", replace
hist rs1
graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\residuals\hist\mv/lod_`var'.png", replace
twoway scatter rs1 y1, yline(0)
graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\scatter_rs_y\mv/lod_`var'.png", replace
drop y1 rs1*/
mi test 1.m_place_of_birth_0_2#c.Dim_2 
matrix mc2_storep[5,1]=r(p)
mi test c.Dim_2
matrix mc2_storep[5,2]=r(p)

mi estimate: regress ls_m_height_pw26 c.Dim_2##ib1.m_place_of_birth_0_2 m_age_recruitment [pweight=w_status_pw26] , base vce(robust)
regsave using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\dimensionality\coef\mca\mc_mi\raw/coef_mi2_sg", ci append table(ls_m_height_pw26, format(%9.2f))
mi test c.Dim_2
matrix mc2_storep[5,3]=r(p)

*******************************
use ls_m_midarm_pw26, clear 

mi estimate: regress ls_m_midarm_pw26 c.Dim_2##i.m_place_of_birth_0_2 m_age_recruitment [pweight=w_status_pw26] , base vce(robust)
regsave using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\dimensionality\coef\mca\mc_mi\raw/coef_mi2_xsg", ci append table(ls_m_midarm_pw26, format(%9.2f))
/*predict y1 
twoway (scatter `var' mc2_quart##i.m_place_of_birth_0_2, ms(oh)) (line y1 mc2_quart##i.m_place_of_birth_0_2, sort) if mc2_quart##i.m_place_of_birth_0_2!=5
graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\predicted_values\mv/lod_`var'.png", replace
predict rs1, rstandard 
qnorm rs1
graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\residuals\qq\mv/lod_`var'.png", replace
hist rs1
graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\residuals\hist\mv/lod_`var'.png", replace
twoway scatter rs1 y1, yline(0)
graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\scatter_rs_y\mv/lod_`var'.png", replace
drop y1 rs1*/
mi test 1.m_place_of_birth_0_2#c.Dim_2 
matrix mc2_storep[6,1]=r(p)
mi test c.Dim_2
matrix mc2_storep[6,2]=r(p)

mi estimate: regress ls_m_midarm_pw26 c.Dim_2##ib1.m_place_of_birth_0_2 m_age_recruitment [pweight=w_status_pw26] , base vce(robust)
regsave using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\dimensionality\coef\mca\mc_mi\raw/coef_mi2_sg", ci append table(ls_m_midarm_pw26, format(%9.2f))
mi test c.Dim_2
matrix mc2_storep[6,3]=r(p)

*******************************
use s_m_triceps_pw26, clear

mi estimate: regress s_m_triceps_pw26 c.Dim_2##i.m_place_of_birth_0_2 m_age_recruitment [pweight=w_status_pw26] , base vce(robust)
regsave using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\dimensionality\coef\mca\mc_mi\raw/coef_mi2_xsg", ci append table(s_m_triceps_pw26, format(%9.2f))
/*predict y1 
twoway (scatter `var' mc2_quart##i.m_place_of_birth_0_2, ms(oh)) (line y1 mc2_quart##i.m_place_of_birth_0_2, sort) if mc2_quart##i.m_place_of_birth_0_2!=5
graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\predicted_values\mv/lod_`var'.png", replace
predict rs1, rstandard 
qnorm rs1
graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\residuals\qq\mv/lod_`var'.png", replace
hist rs1
graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\residuals\hist\mv/lod_`var'.png", replace
twoway scatter rs1 y1, yline(0)
graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\scatter_rs_y\mv/lod_`var'.png", replace
drop y1 rs1*/
mi test 1.m_place_of_birth_0_2#c.Dim_2 
matrix mc2_storep[7,1]=r(p)
mi test c.Dim_2
matrix mc2_storep[7,2]=r(p)

mi estimate: regress s_m_triceps_pw26 c.Dim_2##ib1.m_place_of_birth_0_2 m_age_recruitment [pweight=w_status_pw26] , base vce(robust)
regsave using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\dimensionality\coef\mca\mc_mi\raw/coef_mi2_sg", ci append table(s_m_triceps_pw26, format(%9.2f))
mi test c.Dim_2
matrix mc2_storep[7,3]=r(p)

*******************************
use ls_m_biceps_pw26, clear

mi estimate: regress ls_m_biceps_pw26 c.Dim_2##i.m_place_of_birth_0_2 m_age_recruitment [pweight=w_status_pw26] , base vce(robust)
regsave using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\dimensionality\coef\mca\mc_mi\raw/coef_mi2_xsg", ci append table(ls_m_biceps_pw26, format(%9.2f))
/*predict y1 
twoway (scatter `var' mc2_quart##i.m_place_of_birth_0_2, ms(oh)) (line y1 mc2_quart##i.m_place_of_birth_0_2, sort) if mc2_quart##i.m_place_of_birth_0_2!=5
graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\predicted_values\mv/lod_`var'.png", replace
predict rs1, rstandard 
qnorm rs1
graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\residuals\qq\mv/lod_`var'.png", replace
hist rs1
graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\residuals\hist\mv/lod_`var'.png", replace
twoway scatter rs1 y1, yline(0)
graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\scatter_rs_y\mv/lod_`var'.png", replace
drop y1 rs1*/
mi test 1.m_place_of_birth_0_2#c.Dim_2 
matrix mc2_storep[8,1]=r(p)
mi test c.Dim_2
matrix mc2_storep[8,2]=r(p)

mi estimate: regress ls_m_biceps_pw26 c.Dim_2##ib1.m_place_of_birth_0_2 m_age_recruitment [pweight=w_status_pw26] , base vce(robust)
regsave using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\dimensionality\coef\mca\mc_mi\raw/coef_mi2_sg", ci append table(ls_m_biceps_pw26, format(%9.2f))
mi test c.Dim_2
matrix mc2_storep[8,3]=r(p)

*******************************
use s_m_subscapular_pw26, clear 

mi estimate: regress s_m_subscapular_pw26 c.Dim_2##i.m_place_of_birth_0_2 m_age_recruitment [pweight=w_status_pw26] , base vce(robust)
regsave using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\dimensionality\coef\mca\mc_mi\raw/coef_mi2_xsg", ci append table(s_m_subscapular_pw26, format(%9.2f))
/*predict y1 
twoway (scatter `var' mc2_quart##i.m_place_of_birth_0_2, ms(oh)) (line y1 mc2_quart##i.m_place_of_birth_0_2, sort) if mc2_quart##i.m_place_of_birth_0_2!=5
graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\predicted_values\mv/lod_`var'.png", replace
predict rs1, rstandard 
qnorm rs1
graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\residuals\qq\mv/lod_`var'.png", replace
hist rs1
graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\residuals\hist\mv/lod_`var'.png", replace
twoway scatter rs1 y1, yline(0)
graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\scatter_rs_y\mv/lod_`var'.png", replace
drop y1 rs1*/
mi test 1.m_place_of_birth_0_2#c.Dim_2 
matrix mc2_storep[9,1]=r(p)
mi test c.Dim_2
matrix mc2_storep[9,2]=r(p)

mi estimate: regress s_m_subscapular_pw26 c.Dim_2##ib1.m_place_of_birth_0_2 m_age_recruitment [pweight=w_status_pw26] , base vce(robust)
regsave using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\dimensionality\coef\mca\mc_mi\raw/coef_mi2_sg", ci append table(s_m_subscapular_pw26, format(%9.2f))
mi test c.Dim_2
matrix mc2_storep[9,3]=r(p)


*******************************
use s_m_suprailiac_pw26, clear

mi estimate: regress s_m_suprailiac_pw26 c.Dim_2##i.m_place_of_birth_0_2 m_age_recruitment [pweight=w_status_pw26] , base vce(robust)
regsave using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\dimensionality\coef\mca\mc_mi\raw/coef_mi2_xsg", ci append table(s_m_suprailiac_pw26, format(%9.2f))
/*predict y1 
twoway (scatter `var' mc2_quart##i.m_place_of_birth_0_2, ms(oh)) (line y1 mc2_quart##i.m_place_of_birth_0_2, sort) if mc2_quart##i.m_place_of_birth_0_2!=5
graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\predicted_values\mv/lod_`var'.png", replace
predict rs1, rstandard 
qnorm rs1
graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\residuals\qq\mv/lod_`var'.png", replace
hist rs1
graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\residuals\hist\mv/lod_`var'.png", replace
twoway scatter rs1 y1, yline(0)
graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\scatter_rs_y\mv/lod_`var'.png", replace
drop y1 rs1*/
mi test 1.m_place_of_birth_0_2#c.Dim_2  
matrix mc2_storep[10,1]=r(p)
mi test c.Dim_2
matrix mc2_storep[10,2]=r(p)

mi estimate: regress s_m_suprailiac_pw26 c.Dim_2##ib1.m_place_of_birth_0_2 m_age_recruitment [pweight=w_status_pw26] , base vce(robust)
regsave using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\dimensionality\coef\mca\mc_mi\raw/coef_mi2_sg", ci append table(s_m_suprailiac_pw26, format(%9.2f))
mi test c.Dim_2
matrix mc2_storep[10,3]=r(p)

*******************************
use ls_avg_weight_1sttri, clear

mi estimate: regress ls_avg_weight_1sttri c.Dim_2##i.m_place_of_birth_0_2 m_age_recruitment [pweight=w_status_del] , base vce(robust)
regsave using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\dimensionality\coef\mca\mc_mi\raw/coef_mi2_xsg", ci append table(ls_avg_weight_1sttri, format(%9.2f))
/*predict y1 
twoway (scatter `var' mc2_quart##i.m_place_of_birth_0_2, ms(oh)) (line y1 mc2_quart##i.m_place_of_birth_0_2, sort) if mc2_quart##i.m_place_of_birth_0_2!=5
graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\predicted_values\mv/lod_`var'.png", replace
predict rs1, rstandard 
qnorm rs1
graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\residuals\qq\mv/lod_`var'.png", replace
hist rs1
graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\residuals\hist\mv/lod_`var'.png", replace
twoway scatter rs1 y1, yline(0)
graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\scatter_rs_y\mv/lod_`var'.png", replace
drop y1 rs1*/
mi test 1.m_place_of_birth_0_2#c.Dim_2 
matrix mc2_storep[11,1]=r(p)
mi test c.Dim_2
matrix mc2_storep[11,2]=r(p)

mi estimate: regress ls_avg_weight_1sttri c.Dim_2##ib1.m_place_of_birth_0_2 m_age_recruitment [pweight=w_status_del] , base vce(robust)
regsave using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\dimensionality\coef\mca\mc_mi\raw/coef_mi2_sg", ci append table(ls_avg_weight_1sttri, format(%9.2f))
mi test c.Dim_2
matrix mc2_storep[11,3]=r(p)

*******************************
use ls_avg_weight_2ndtri,  clear

mi estimate: regress ls_avg_weight_2ndtri c.Dim_2##i.m_place_of_birth_0_2 m_age_recruitment [pweight=w_status_del] , base vce(robust)
regsave using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\dimensionality\coef\mca\mc_mi\raw/coef_mi2_xsg", ci append table(ls_avg_weight_2ndtri, format(%9.2f))
/*predict y1 
twoway (scatter `var' mc2_quart##i.m_place_of_birth_0_2, ms(oh)) (line y1 mc2_quart##i.m_place_of_birth_0_2, sort) if mc2_quart##i.m_place_of_birth_0_2!=5
graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\predicted_values\mv/lod_`var'.png", replace
predict rs1, rstandard 
qnorm rs1
graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\residuals\qq\mv/lod_`var'.png", replace
hist rs1
graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\residuals\hist\mv/lod_`var'.png", replace
twoway scatter rs1 y1, yline(0)
graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\scatter_rs_y\mv/lod_`var'.png", replace
drop y1 rs1*/
mi test 1.m_place_of_birth_0_2#c.Dim_2  
matrix mc2_storep[12,1]=r(p)
mi test c.Dim_2
matrix mc2_storep[12,2]=r(p)

mi estimate: regress ls_avg_weight_2ndtri c.Dim_2##ib1.m_place_of_birth_0_2 m_age_recruitment [pweight=w_status_del] , base vce(robust)
regsave using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\dimensionality\coef\mca\mc_mi\raw/coef_mi2_sg", ci append table(ls_avg_weight_2ndtri, format(%9.2f))
mi test c.Dim_2
matrix mc2_storep[12,3]=r(p)

*******************************
use ls_avg_weight_3rdtri, clear

mi estimate: regress ls_avg_weight_3rdtri c.Dim_2##i.m_place_of_birth_0_2 m_age_recruitment [pweight=w_status_del] , base vce(robust)
regsave using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\dimensionality\coef\mca\mc_mi\raw/coef_mi2_xsg", ci append table(ls_avg_weight_3rdtri, format(%9.2f))
/*predict y1 
twoway (scatter `var' mc2_quart##i.m_place_of_birth_0_2, ms(oh)) (line y1 mc2_quart##i.m_place_of_birth_0_2, sort) if mc2_quart##i.m_place_of_birth_0_2!=5
graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\predicted_values\mv/lod_`var'.png", replace
predict rs1, rstandard 
qnorm rs1
graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\residuals\qq\mv/lod_`var'.png", replace
hist rs1
graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\residuals\hist\mv/lod_`var'.png", replace
twoway scatter rs1 y1, yline(0)
graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\scatter_rs_y\mv/lod_`var'.png", replace
drop y1 rs1*/
mi test 1.m_place_of_birth_0_2#c.Dim_2  
matrix mc2_storep[13,1]=r(p)
mi test c.Dim_2
matrix mc2_storep[13,2]=r(p)

mi estimate: regress ls_avg_weight_3rdtri c.Dim_2##ib1.m_place_of_birth_0_2 m_age_recruitment [pweight=w_status_del] , base vce(robust)
regsave using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\dimensionality\coef\mca\mc_mi\raw/coef_mi2_sg", ci append table(ls_avg_weight_3rdtri, format(%9.2f))
mi test c.Dim_2
matrix mc2_storep[13,3]=r(p)

*******************************
use ls_last_antenatal_weight, clear

mi estimate: regress ls_last_antenatal_weight c.Dim_2##i.m_place_of_birth_0_2 m_age_recruitment [pweight=w_status_del] , base vce(robust)
regsave using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\dimensionality\coef\mca\mc_mi\raw/coef_mi2_xsg", ci append table(ls_last_antenatal_weight, format(%9.2f))
/*predict y1 
twoway (scatter `var' mc2_quart##i.m_place_of_birth_0_2, ms(oh)) (line y1 mc2_quart##i.m_place_of_birth_0_2, sort) if mc2_quart##i.m_place_of_birth_0_2!=5
graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\predicted_values\mv/lod_`var'.png", replace
predict rs1, rstandard 
qnorm rs1
graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\residuals\qq\mv/lod_`var'.png", replace
hist rs1
graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\residuals\hist\mv/lod_`var'.png", replace
twoway scatter rs1 y1, yline(0)
graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\scatter_rs_y\mv/lod_`var'.png", replace
drop y1 rs1*/
mi test 1.m_place_of_birth_0_2#c.Dim_2  
matrix mc2_storep[14,1]=r(p)
mi test c.Dim_2
matrix mc2_storep[14,2]=r(p)

mi estimate: regress ls_last_antenatal_weight c.Dim_2##ib1.m_place_of_birth_0_2 m_age_recruitment [pweight=w_status_del] , base vce(robust)
regsave using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\dimensionality\coef\mca\mc_mi\raw/coef_mi2_sg", ci append table(ls_last_antenatal_weight, format(%9.2f))
mi test c.Dim_2
matrix mc2_storep[14,3]=r(p)


*MINERALS 
use min_wo_tr, clear 

local n=14

foreach var of varlist ls_mpm3na-s_mpm3se {
    loc n=`n'+1
	mi estimate: regress `var' c.Dim_2##i.m_place_of_birth_0_2 m_age_recruitment col_mo col_yr c.timecollected1##i.hospital [pweight=w_status_pw26] if m_ogtt_source_pw26=="GUSTO_visit", base vce(robust)
	regsave using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\dimensionality\coef\mca\mc_mi\raw/coef_mi2_xsg", ci append table(`var', format(%9.2f))
	/*predict y1 
	twoway (scatter `var' mc2_quart##i.m_place_of_birth_0_2, ms(oh)) (line y1 mc2_quart##i.m_place_of_birth_0_2, sort) if mc2_quart##i.m_place_of_birth_0_2!=5
	graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\predicted_values\mv/lod_`var'.png", replace
	predict rs1, rstandard 
	qnorm rs1
	graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\residuals\qq\mv/lod_`var'.png", replace
	hist rs1
	graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\residuals\hist\mv/lod_`var'.png", replace
	twoway scatter rs1 y1, yline(0)
	graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\scatter_rs_y\mv/lod_`var'.png", replace
	drop y1 rs1*/
	mi test 1.m_place_of_birth_0_2#c.Dim_2 
	matrix mc2_storep[`n',1]=r(p)
	mi test c.Dim_2
	matrix mc2_storep[`n',2]=r(p)
}

local n=14

foreach var of varlist ls_mpm3na-s_mpm3se {
    loc n=`n'+1
    mi estimate: regress `var' c.Dim_2##ib1.m_place_of_birth_0_2 m_age_recruitment col_mo col_yr c.timecollected1##i.hospital [pweight=w_status_pw26] if m_ogtt_source_pw26=="GUSTO_visit", base vce(robust)
	regsave using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\dimensionality\coef\mca\mc_mi\raw/coef_mi2_sg", ci append table(`var', format(%9.2f))
	mi test c.Dim_2
	matrix mc2_storep[`n',3]=r(p)
}


*******************************
use ls_mpm3tr, clear

mi estimate: regress ls_mpm3tr c.Dim_2##i.m_place_of_birth_0_2 m_age_recruitment col_mo col_yr c.timecollected1##i.hospital [pweight=w_status_pw26] if m_ogtt_source_pw26=="GUSTO_visit", base vce(robust)
regsave using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\dimensionality\coef\mca\mc_mi\raw/coef_mi2_xsg", ci append table(ls_mpm3tr, format(%9.2f))
/*predict y1 
twoway (scatter `var' mc2_quart##i.m_place_of_birth_0_2, ms(oh)) (line y1 mc2_quart##i.m_place_of_birth_0_2, sort) if mc2_quart##i.m_place_of_birth_0_2!=5
graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\predicted_values\mv/lod_`var'.png", replace
predict rs1, rstandard 
qnorm rs1
graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\residuals\qq\mv/lod_`var'.png", replace
hist rs1
graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\residuals\hist\mv/lod_`var'.png", replace
twoway scatter rs1 y1, yline(0)
graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\scatter_rs_y\mv/lod_`var'.png", replace
drop y1 rs1*/
mi test 1.m_place_of_birth_0_2#c.Dim_2  
matrix mc2_storep[25,1]=r(p)
mi test c.Dim_2
matrix mc2_storep[25,2]=r(p)

mi estimate: regress ls_mpm3tr c.Dim_2##ib1.m_place_of_birth_0_2 m_age_recruitment col_mo col_yr c.timecollected1##i.hospital [pweight=w_status_pw26] if m_ogtt_source_pw26=="GUSTO_visit", base vce(robust)
regsave using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\dimensionality\coef\mca\mc_mi\raw/coef_mi2_sg", ci append table(ls_mpm3tr, format(%9.2f))
mi test c.Dim_2
matrix mc2_storep[25,3]=r(p)


*FATTY ACIDS
use fa, clear

local n=25

foreach var of varlist ls_mpm3my-ls_mpm3puf {
    loc n=`n'+1
	mi estimate: regress `var' c.Dim_2##i.m_place_of_birth_0_2 m_age_recruitment col_mo col_yr c.timecollected1##i.hospital [pweight=w_status_pw26] if m_ogtt_source_pw26=="GUSTO_visit", base vce(robust)
	regsave using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\dimensionality\coef\mca\mc_mi\raw/coef_mi2_xsg", ci append table(`var', format(%9.2f))
	/*predict y1 
	twoway (scatter `var' mc2_quart##i.m_place_of_birth_0_2, ms(oh)) (line y1 mc2_quart##i.m_place_of_birth_0_2, sort) if mc2_quart##i.m_place_of_birth_0_2!=5
	graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\predicted_values\mv/lod_`var'.png", replace
	predict rs1, rstandard 
	qnorm rs1
	graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\residuals\qq\mv/lod_`var'.png", replace
	hist rs1
	graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\residuals\hist\mv/lod_`var'.png", replace
	twoway scatter rs1 y1, yline(0)
	graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\scatter_rs_y\mv/lod_`var'.png", replace
	drop y1 rs1*/
	mi test 1.m_place_of_birth_0_2#c.Dim_2 
	matrix mc2_storep[`n',1]=r(p)
	mi test c.Dim_2
	matrix mc2_storep[`n',2]=r(p)
}

local n=25

foreach var of varlist ls_mpm3my-ls_mpm3puf {
    loc n=`n'+1
    mi estimate: regress `var' c.Dim_2##ib1.m_place_of_birth_0_2 m_age_recruitment col_mo col_yr c.timecollected1##i.hospital [pweight=w_status_pw26] if m_ogtt_source_pw26=="GUSTO_visit", base vce(robust)
	regsave using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\dimensionality\coef\mca\mc_mi\raw/coef_mi2_sg", ci append table(`var', format(%9.2f))
	mi test c.Dim_2
	matrix mc2_storep[`n',3]=r(p)
}

*VITAMINS
use vitb, clear

local n=51

foreach var of varlist ls_mpm3fmn2-ls_mpm3pabe2 {
    loc n=`n'+1
	mi estimate: regress `var' c.Dim_2##i.m_place_of_birth_0_2 m_age_recruitment col_mo col_yr c.timecollected1##i.hospital [pweight=w_status_pw26] if m_ogtt_source_pw26=="GUSTO_visit", base vce(robust)
	regsave using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\dimensionality\coef\mca\mc_mi\raw/coef_mi2_xsg", ci append table(`var', format(%9.2f))
	/*predict y1 
	twoway (scatter `var' mc2_quart##i.m_place_of_birth_0_2, ms(oh)) (line y1 mc2_quart##i.m_place_of_birth_0_2, sort) if mc2_quart##i.m_place_of_birth_0_2!=5
	graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\predicted_values\mv/lod_`var'.png", replace
	predict rs1, rstandard 
	qnorm rs1
	graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\residuals\qq\mv/lod_`var'.png", replace
	hist rs1
	graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\residuals\hist\mv/lod_`var'.png", replace
	twoway scatter rs1 y1, yline(0)
	graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\scatter_rs_y\mv/lod_`var'.png", replace
	drop y1 rs1*/
	mi test 1.m_place_of_birth_0_2#c.Dim_2  
	matrix mc2_storep[`n',1]=r(p)
	mi test c.Dim_2
	matrix mc2_storep[`n',2]=r(p)
}


local n=51

foreach var of varlist ls_mpm3fmn2-ls_mpm3pabe2 {
    loc n=`n'+1
    mi estimate: regress `var' c.Dim_2##ib1.m_place_of_birth_0_2 m_age_recruitment col_mo col_yr c.timecollected1##i.hospital [pweight=w_status_pw26] if m_ogtt_source_pw26=="GUSTO_visit", base vce(robust)
	regsave using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\dimensionality\coef\mca\mc_mi\raw/coef_mi2_sg", ci append table(`var', format(%9.2f))
	mi test c.Dim_2
	matrix mc2_storep[`n',3]=r(p)
}

*******************************
use ls_mpm3b12p_ls_mpm3fo, clear

local n=60

foreach var of varlist ls_mpm3fo ls_mpm3b12p {
    loc n=`n'+1
	mi estimate: regress `var' c.Dim_2##i.m_place_of_birth_0_2 m_age_recruitment col_mo col_yr c.timecollected1##i.hospital [pweight=w_status_pw26] if m_ogtt_source_pw26=="GUSTO_visit", base vce(robust)
	regsave using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\dimensionality\coef\mca\mc_mi\raw/coef_mi2_xsg", ci append table(`var', format(%9.2f))
	/*predict y1 
	twoway (scatter `var' mc2_quart##i.m_place_of_birth_0_2, ms(oh)) (line y1 mc2_quart##i.m_place_of_birth_0_2, sort) if mc2_quart##i.m_place_of_birth_0_2!=5
	graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\predicted_values\mv/lod_`var'.png", replace
	predict rs1, rstandard 
	qnorm rs1
	graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\residuals\qq\mv/lod_`var'.png", replace
	hist rs1
	graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\residuals\hist\mv/lod_`var'.png", replace
	twoway scatter rs1 y1, yline(0)
	graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\scatter_rs_y\mv/lod_`var'.png", replace
	drop y1 rs1*/
	mi test 1.m_place_of_birth_0_2#c.Dim_2 
	matrix mc2_storep[`n',1]=r(p)
	mi test c.Dim_2
	matrix mc2_storep[`n',2]=r(p)
}

local n=60
foreach var of varlist ls_mpm3fo ls_mpm3b12p {
    loc n=`n'+1
    mi estimate: regress `var' c.Dim_2##ib1.m_place_of_birth_0_2 m_age_recruitment col_mo col_yr c.timecollected1##i.hospital [pweight=w_status_pw26] if m_ogtt_source_pw26=="GUSTO_visit", base vce(robust)
	regsave using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\dimensionality\coef\mca\mc_mi\raw/coef_mi2_sg", ci append table(`var', format(%9.2f))
	mi test c.Dim_2
	matrix mc2_storep[`n',3]=r(p)
}


*******************************
use s_mpm3vd3, clear

mi estimate: regress s_mpm3vd3 c.Dim_2##i.m_place_of_birth_0_2 m_age_recruitment col_mo col_yr c.timecollected1##i.hospital [pweight=w_status_pw26] if m_ogtt_source_pw26=="GUSTO_visit", base vce(robust)
regsave using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\dimensionality\coef\mca\mc_mi\raw/coef_mi2_xsg", ci append table(s_mpm3vd3, format(%9.2f))
/*predict y1 
twoway (scatter `var' mc2_quart##i.m_place_of_birth_0_2, ms(oh)) (line y1 mc2_quart##i.m_place_of_birth_0_2, sort) if mc2_quart##i.m_place_of_birth_0_2!=5
graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\predicted_values\mv/lod_`var'.png", replace
predict rs1, rstandard 
qnorm rs1
graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\residuals\qq\mv/lod_`var'.png", replace
hist rs1
graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\residuals\hist\mv/lod_`var'.png", replace
twoway scatter rs1 y1, yline(0)
graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\scatter_rs_y\mv/lod_`var'.png", replace
drop y1 rs1*/
mi test 1.m_place_of_birth_0_2#c.Dim_2  
matrix mc2_storep[63,1]=r(p)
mi test c.Dim_2
matrix mc2_storep[63,2]=r(p)

mi estimate: regress s_mpm3vd3 c.Dim_2##ib1.m_place_of_birth_0_2 m_age_recruitment col_mo col_yr c.timecollected1##i.hospital [pweight=w_status_pw26] if m_ogtt_source_pw26=="GUSTO_visit", base vce(robust)
regsave using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\dimensionality\coef\mca\mc_mi\raw/coef_mi2_sg", ci append table(s_mpm3vd3, format(%9.2f))
mi test c.Dim_2
matrix mc2_storep[63,3]=r(p)


*AMINO ACIDS 
use aa, clear

local n=63

foreach var of varlist ls_mpm3arg2-ls_mpm3tmao2 {
    loc n=`n'+1
	mi estimate: regress `var' c.Dim_2##i.m_place_of_birth_0_2 m_age_recruitment col_mo col_yr c.timecollected1##i.hospital [pweight=w_status_pw26] if m_ogtt_source_pw26=="GUSTO_visit", base vce(robust)
	regsave using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\dimensionality\coef\mca\mc_mi\raw/coef_mi2_xsg", ci append table(`var', format(%9.2f))
	/*predict y1 
	twoway (scatter `var' mc2_quart##i.m_place_of_birth_0_2, ms(oh)) (line y1 mc2_quart##i.m_place_of_birth_0_2, sort) if mc2_quart##i.m_place_of_birth_0_2!=5
	graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\predicted_values\mv/lod_`var'.png", replace
	predict rs1, rstandard 
	qnorm rs1
	graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\residuals\qq\mv/lod_`var'.png", replace
	hist rs1
	graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\residuals\hist\mv/lod_`var'.png", replace
	twoway scatter rs1 y1, yline(0)
	graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\scatter_rs_y\mv/lod_`var'.png", replace
	drop y1 rs1*/
	mi test 1.m_place_of_birth_0_2#c.Dim_2  
	matrix mc2_storep[`n',1]=r(p)
	mi test c.Dim_2
	matrix mc2_storep[`n',2]=r(p)
}

local n=63

foreach var of varlist ls_mpm3arg2-ls_mpm3tmao2 {
    loc n=`n'+1
    mi estimate: regress `var' c.Dim_2##ib1.m_place_of_birth_0_2 m_age_recruitment col_mo col_yr c.timecollected1##i.hospital [pweight=w_status_pw26] if m_ogtt_source_pw26=="GUSTO_visit", base vce(robust)
	regsave using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\dimensionality\coef\mca\mc_mi\raw/coef_mi2_sg", ci append table(`var', format(%9.2f))
	mi test c.Dim_2
	matrix mc2_storep[`n',3]=r(p)
}

*GLUCOSE
use glucose, clear

local n=90

foreach var of varlist ls_m_ogtt_fasting_pw26 ls_m_ogtt_2hour_pw26 {
    loc n=`n'+1
	mi estimate: regress `var' c.Dim_2##i.m_place_of_birth_0_2 m_age_recruitment col_mo col_yr , base vce(robust)
	regsave using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\dimensionality\coef\mca\mc_mi\raw/coef_mi2_xsg", ci append table(`var', format(%9.2f))
	/*predict y1 
	twoway (scatter `var' mc2_quart##i.m_place_of_birth_0_2, ms(oh)) (line y1 mc2_quart##i.m_place_of_birth_0_2, sort) if mc2_quart##i.m_place_of_birth_0_2!=5
	graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\predicted_values\mv/lod_`var'.png", replace
	predict rs1, rstandard 
	qnorm rs1
	graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\residuals\qq\mv/lod_`var'.png", replace
	hist rs1
	graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\residuals\hist\mv/lod_`var'.png", replace
	twoway scatter rs1 y1, yline(0)
	graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\scatter_rs_y\mv/lod_`var'.png", replace
	drop y1 rs1*/
	mi test 1.m_place_of_birth_0_2#c.Dim_2  
	matrix mc2_storep[`n',1]=r(p)
	mi test c.Dim_2
	matrix mc2_storep[`n',2]=r(p)
}

local n=90

foreach var of varlist ls_m_ogtt_fasting_pw26 ls_m_ogtt_2hour_pw26 {
    loc n=`n'+1
    mi estimate: regress `var' c.Dim_2##ib1.m_place_of_birth_0_2 m_age_recruitment col_mo col_yr , base vce(robust)
	regsave using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\dimensionality\coef\mca\mc_mi\raw/coef_mi2_sg", ci append table(`var', format(%9.2f))
	mi test c.Dim_2
	matrix mc2_storep[`n',3]=r(p)
}


*LUMINEX 
use luminex, clear 

local n=92

foreach var of varlist ls_adiponectin-ls_insulin {
    loc n=`n'+1
	mi estimate: regress `var' c.Dim_2##i.m_place_of_birth_0_2 m_age_recruitment col_mo col_yr c.timecollected1##i.hospital [pweight=w_status_pw26] if m_ogtt_source_pw26=="GUSTO_visit", base vce(robust)
	regsave using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\dimensionality\coef\mca\mc_mi\raw/coef_mi2_xsg", ci append table(`var', format(%9.2f))
	/*predict y1 
	twoway (scatter `var' mc2_quart##i.m_place_of_birth_0_2, ms(oh)) (line y1 mc2_quart##i.m_place_of_birth_0_2, sort) if mc2_quart##i.m_place_of_birth_0_2!=5
	graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\predicted_values\mv/lod_`var'.png", replace
	predict rs1, rstandard 
	qnorm rs1
	graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\residuals\qq\mv/lod_`var'.png", replace
	hist rs1
	graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\residuals\hist\mv/lod_`var'.png", replace
	twoway scatter rs1 y1, yline(0)
	graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\scatter_rs_y\mv/lod_`var'.png", replace
	drop y1 rs1*/
	mi test 1.m_place_of_birth_0_2#c.Dim_2  
	matrix mc2_storep[`n',1]=r(p)
	mi test c.Dim_2
	matrix mc2_storep[`n',2]=r(p)
}

local n=92

foreach var of varlist ls_adiponectin-ls_insulin {
    loc n=`n'+1
    mi estimate: regress `var' c.Dim_2##ib1.m_place_of_birth_0_2 m_age_recruitment col_mo col_yr c.timecollected1##i.hospital [pweight=w_status_pw26] if m_ogtt_source_pw26=="GUSTO_visit", base vce(robust)
	regsave using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\dimensionality\coef\mca\mc_mi\raw/coef_mi2_sg", ci append table(`var', format(%9.2f))
	mi test c.Dim_2
	matrix mc2_storep[`n',3]=r(p)
}


*biochem
use biochemistry, clear 

local n=112

foreach var of varlist ls_mbc3tg-s_mbc3cre {
    loc n=`n'+1
	mi estimate: regress `var' c.Dim_2##i.m_place_of_birth_0_2 m_age_recruitment col_mo col_yr c.timecollected1##i.hospital [pweight=w_status_pw26] if m_ogtt_source_pw26=="GUSTO_visit", base vce(robust)
	regsave using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\dimensionality\coef\mca\mc_mi\raw/coef_mi2_xsg", ci append table(`var', format(%9.2f))
	/*predict y1 
	twoway (scatter `var' mc2_quart##i.m_place_of_birth_0_2, ms(oh)) (line y1 mc2_quart##i.m_place_of_birth_0_2, sort) if mc2_quart##i.m_place_of_birth_0_2!=5
	graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\predicted_values\mv/lod_`var'.png", replace
	predict rs1, rstandard 
	qnorm rs1
	graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\residuals\qq\mv/lod_`var'.png", replace
	hist rs1
	graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\residuals\hist\mv/lod_`var'.png", replace
	twoway scatter rs1 y1, yline(0)
	graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\scatter_rs_y\mv/lod_`var'.png", replace
	drop y1 rs1*/
	mi test 1.m_place_of_birth_0_2#c.Dim_2 
	matrix mc2_storep[`n',1]=r(p)
	mi test c.Dim_2
	matrix mc2_storep[`n',2]=r(p)
}

local n=112

foreach var of varlist ls_mbc3tg-s_mbc3cre {
    loc n=`n'+1
    mi estimate: regress `var' c.Dim_2##ib1.m_place_of_birth_0_2 m_age_recruitment col_mo col_yr c.timecollected1##i.hospital [pweight=w_status_pw26] if m_ogtt_source_pw26=="GUSTO_visit", base vce(robust)
	regsave using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\dimensionality\coef\mca\mc_mi\raw/coef_mi2_sg", ci append table(`var', format(%9.2f))
	mi test c.Dim_2
	matrix mc2_storep[`n',3]=r(p)
}


*pfas
use pfas_corrected, clear 

local n=122

foreach var of varlist ls_pfba-ls_pfos {
    loc n=`n'+1
	mi estimate: regress `var' c.Dim_2##i.m_place_of_birth_0_2 m_age_recruitment dob_mo dob_yr [pweight=w_status_del] , base vce(robust)
	regsave using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\dimensionality\coef\mca\mc_mi\raw/coef_mi2_xsg", ci append table(`var', format(%9.2f))
	/*predict y1 
	twoway (scatter `var' mc2_quart##i.m_place_of_birth_0_2, ms(oh)) (line y1 mc2_quart##i.m_place_of_birth_0_2, sort) if mc2_quart##i.m_place_of_birth_0_2!=5
	graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\predicted_values\mv/lod_`var'.png", replace
	predict rs1, rstandard 
	qnorm rs1
	graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\residuals\qq\mv/lod_`var'.png", replace
	hist rs1
	graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\residuals\hist\mv/lod_`var'.png", replace
	twoway scatter rs1 y1, yline(0)
	graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\scatter_rs_y\mv/lod_`var'.png", replace
	drop y1 rs1*/
	mi test 1.m_place_of_birth_0_2#c.Dim_2  
	matrix mc2_storep[`n',1]=r(p)
	mi test c.Dim_2
	matrix mc2_storep[`n',2]=r(p)
}

local n=122

foreach var of varlist ls_pfba-ls_pfos {
    loc n=`n'+1
    mi estimate: regress `var' c.Dim_2##ib1.m_place_of_birth_0_2 m_age_recruitment dob_mo dob_yr [pweight=w_status_del] , base vce(robust)
	regsave using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\dimensionality\coef\mca\mc_mi\raw/coef_mi2_sg", ci append table(`var', format(%9.2f))
	mi test c.Dim_2
	matrix mc2_storep[`n',3]=r(p)
}


*PSI
use psi, clear

local n=130

foreach var of varlist s_psi_tri1-s_psi_pregnancy {
    loc n=`n'+1
	mi estimate: regress `var' c.Dim_2##i.m_place_of_birth_0_2 m_age_recruitment dob_mo dob_yr region [pweight=w_status_del] , base vce(robust)
	regsave using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\dimensionality\coef\mca\mc_mi\raw/coef_mi2_xsg", ci append table(`var', format(%9.2f))
	/*predict y1 
	twoway (scatter `var' mc2_quart##i.m_place_of_birth_0_2, ms(oh)) (line y1 mc2_quart##i.m_place_of_birth_0_2, sort) if mc2_quart##i.m_place_of_birth_0_2!=5
	graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\predicted_values\mv/lod_`var'.png", replace
	predict rs1, rstandard 
	qnorm rs1
	graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\residuals\qq\mv/lod_`var'.png", replace
	hist rs1
	graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\residuals\hist\mv/lod_`var'.png", replace
	twoway scatter rs1 y1, yline(0)
	graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\scatter_rs_y\mv/lod_`var'.png", replace
	drop y1 rs1*/
	mi test 1.m_place_of_birth_0_2#c.Dim_2  
	matrix mc2_storep[`n',1]=r(p)
	mi test c.Dim_2
	matrix mc2_storep[`n',2]=r(p)
}

local n=130

foreach var of varlist s_psi_tri1-s_psi_pregnancy {
    loc n=`n'+1
    mi estimate: regress `var' c.Dim_2##ib1.m_place_of_birth_0_2 m_age_recruitment dob_mo dob_yr region [pweight=w_status_del] , base vce(robust)
	regsave using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\dimensionality\coef\mca\mc_mi\raw/coef_mi2_sg", ci append table(`var', format(%9.2f))
	mi test c.Dim_2
	matrix mc2_storep[`n',3]=r(p)
}


*PM2.5
use pm25, clear

local n=134

foreach var of varlist s_pm25_1st-s_pm25_avg_daily_1 {
    loc n=`n'+1
	mi estimate: regress `var' c.Dim_2##i.m_place_of_birth_0_2 m_age_recruitment dob_mo dob_yr region [pweight=w_status_del] , base vce(robust)
	regsave using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\dimensionality\coef\mca\mc_mi\raw/coef_mi2_xsg", ci append table(`var', format(%9.2f))
	/*predict y1 
	twoway (scatter `var' mc2_quart##i.m_place_of_birth_0_2, ms(oh)) (line y1 mc2_quart##i.m_place_of_birth_0_2, sort) if mc2_quart##i.m_place_of_birth_0_2!=5
	graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\predicted_values\mv/lod_`var'.png", replace
	predict rs1, rstandard 
	qnorm rs1
	graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\residuals\qq\mv/lod_`var'.png", replace
	hist rs1
	graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\residuals\hist\mv/lod_`var'.png", replace
	twoway scatter rs1 y1, yline(0)
	graph export "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\mc2_lod\scatter_rs_y\mv/lod_`var'.png", replace
	drop y1 rs1*/
	mi test 1.m_place_of_birth_0_2#c.Dim_2  
	matrix mc2_storep[`n',1]=r(p)
	mi test c.Dim_2
	matrix mc2_storep[`n',2]=r(p)
}

local n=134

foreach var of varlist s_pm25_1st-s_pm25_avg_daily_1 {
    loc n=`n'+1
    mi estimate: regress `var' c.Dim_2##ib1.m_place_of_birth_0_2 m_age_recruitment dob_mo dob_yr region [pweight=w_status_del] , base vce(robust)
	regsave using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\dimensionality\coef\mca\mc_mi\raw/coef_mi2_sg", ci append table(`var', format(%9.2f))
	mi test c.Dim_2
	matrix mc2_storep[`n',3]=r(p)
}

	
matrix list mc2_storep
putexcel set "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\EWAS_FMI_PVAL_COB.xlsx", modify sheet(mc2)
putexcel A1="Exposure" B1="p_value_int" C1="p_value_xsg" D1="p_value_sg" A2=matrix(mc2_storep), rownames 

log close






