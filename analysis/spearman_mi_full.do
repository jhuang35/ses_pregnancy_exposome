/* C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\raw_data\
DO file C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\do_files\spearman_mi_corrected
Spearman correlation
23 Dec 2020, Ka Kei Sum
Dataset: 
  C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\raw_data\obj_clean_transformed_standardized (1193 vars, 1,344 obs)
*/

cd "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\mi_data"
capture log close  
log using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\log_files\spearman_mi_corrected.log", replace 
set more off

use mi_biomarker_lod_merge_full, clear

//need to drop insulin and CRP and reorder 

order s_sbp_avg ls_dbp_avg ls_map_avg /// 
ls_m_weight_pw26 ls_m_height_pw26 ls_m_midarm_pw26 s_m_triceps_pw26 ls_m_biceps_pw26 s_m_subscapular_pw26 s_m_suprailiac_pw26 ls_avg_weight_1sttri ls_avg_weight_2ndtri ls_avg_weight_3rdtri ls_last_antenatal_weight ///
ls_mpm3na ls_mpm3mg ls_mpm3p ls_mpm3k ls_mpm3ca ls_mpm3fe ls_mpm3fr ls_mpm3cu ls_mpm3zn s_mpm3se ls_mpm3tr ///
ls_mpm3my ls_mpm3pal ls_mpm3pl ls_mpm3st ls_mpm3ol ls_mpm3cv ls_mpm3li ls_mpm3li6 ls_mpm3li3 ls_mpm320 ls_mpm3n9 s_mpm32n6 ls_mpm33n6 ls_mpm3ar6 ls_mpm322 ls_mpm3n3 ls_mpm3epa ls_mpm3n62 ls_mpm3dpa ls_mpm3dha ls_mpm3tfa ls_mpm3tn3 ls_mpm3tn6 ls_mpm3sfa ls_mpm3muf ls_mpm3puf ls_mbc3tg s_mbc3tc s_mbc3hdl s_mbc3ldl ///
ls_mpm3fmn2 ls_mpm3ribo2 ls_mpm3mnam2 ls_mpm3nam2 ls_mpm3trig2 ls_mpm3py2 ls_mpm3plpb2 ls_mpm3pabe2 ls_mpm3fo ls_mpm3b12p s_mpm3vd3 ///
ls_mpm3arg2 ls_mpm3adma2 s_mpm3crn2 s_mpm3crea2 ls_mpm3harg2 ls_mpm3sdma2 ls_mpm3tml2 ls_mpm3csta2 ls_mpm3hcy2 s_mpm3tcys2 ls_mpm3m1hs2 ls_mpm3m3hs2 ls_mpm3hist2 ls_mpm3met2 ls_mpm3mtso2 ls_mpm3haa2 ls_mpm3hk2 ls_mpm3aa2 ls_mpm3ka2 ls_mpm3kyn2 ls_mpm3qa2 s_mpm3trp2 ls_mpm3xa2 ///
ls_mpm3betn2 ls_mpm3chol2 ls_mpm3dmg2 ls_mpm3tmao2 ///
ls_m_ogtt_fasting_pw26  ls_m_ogtt_2hour_pw26 ///
ls_adiponectin ls_pai1 ls_resistin ls_mcp1 ls_fsh ls_gh ls_lh ls_tsh ls_igfi ls_igfii ls_igfbp1 ls_igfbp3 ls_igfbp7 ls_cpeptide ls_leptin ls_tnfa ls_igfbp4 ls_mbc3ins ///
ls_mbc3ast ls_mbc3hscp ls_mbc3alt ls_mbc3ura ls_mpm3neo2 ///
ls_pfba ls_pfna ls_pfda ls_pfunda ls_pfhxs ls_pfoa ls_pfbs ls_pfos ///
s_psi_tri1 s_psi_tri2 s_psi_tri3 s_psi_pregnancy s_pm25_1st s_pm25_2nd s_pm25_3rd s_pm25_avg_daily_1 

drop subjectid ls_crp ls_insulin ls_ifng s_mbc3cre

spearman s_sbp_avg ls_dbp_avg ls_map_avg /// 
ls_m_weight_pw26 ls_m_height_pw26 ls_m_midarm_pw26 s_m_triceps_pw26 ls_m_biceps_pw26 s_m_subscapular_pw26 s_m_suprailiac_pw26 ls_avg_weight_1sttri ls_avg_weight_2ndtri ls_avg_weight_3rdtri ls_last_antenatal_weight ///
ls_mpm3na ls_mpm3mg ls_mpm3p ls_mpm3k ls_mpm3ca ls_mpm3fe ls_mpm3fr ls_mpm3cu ls_mpm3zn s_mpm3se ls_mpm3tr ///
ls_mpm3my ls_mpm3pal ls_mpm3pl ls_mpm3st ls_mpm3ol ls_mpm3cv ls_mpm3li ls_mpm3li6 ls_mpm3li3 ls_mpm320 ls_mpm3n9 s_mpm32n6 ls_mpm33n6 ls_mpm3ar6 ls_mpm322 ls_mpm3n3 ls_mpm3epa ls_mpm3n62 ls_mpm3dpa ls_mpm3dha ls_mpm3tfa ls_mpm3tn3 ls_mpm3tn6 ls_mpm3sfa ls_mpm3muf ls_mpm3puf ls_mbc3tg s_mbc3tc s_mbc3hdl s_mbc3ldl ///
ls_mpm3fmn2 ls_mpm3ribo2 ls_mpm3mnam2 ls_mpm3nam2 ls_mpm3trig2 ls_mpm3py2 ls_mpm3plpb2 ls_mpm3pabe2 ls_mpm3fo ls_mpm3b12p s_mpm3vd3 ///
ls_mpm3arg2 ls_mpm3adma2 s_mpm3crn2 s_mpm3crea2 ls_mpm3harg2 ls_mpm3sdma2 ls_mpm3tml2 ls_mpm3csta2 ls_mpm3hcy2 s_mpm3tcys2 ls_mpm3m1hs2 ls_mpm3m3hs2 ls_mpm3hist2 ls_mpm3met2 ls_mpm3mtso2 ls_mpm3haa2 ls_mpm3hk2 ls_mpm3aa2 ls_mpm3ka2 ls_mpm3kyn2 ls_mpm3qa2 s_mpm3trp2 ls_mpm3xa2 ///
ls_mpm3betn2 ls_mpm3chol2 ls_mpm3dmg2 ls_mpm3tmao2 ///
ls_m_ogtt_fasting_pw26  ls_m_ogtt_2hour_pw26 ///
ls_adiponectin ls_pai1 ls_resistin ls_mcp1 ls_fsh ls_gh ls_lh ls_tsh ls_igfi ls_igfii ls_igfbp1 ls_igfbp3 ls_igfbp7 ls_cpeptide ls_leptin ls_tnfa ls_igfbp4 ls_mbc3ins ///
ls_mbc3ast ls_mbc3hscp ls_mbc3alt ls_mbc3ura ls_mpm3neo2 ///
ls_pfba ls_pfna ls_pfda ls_pfunda ls_pfhxs ls_pfoa ls_pfbs ls_pfos ///
s_psi_tri1 s_psi_tri2 s_psi_tri3 s_psi_pregnancy s_pm25_1st s_pm25_2nd s_pm25_3rd s_pm25_avg_daily_1, stats(rho p obs) pw

matrix spearman_out= r(Rho)

esttab matrix(spearman_out) using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\spearman_mi_full_neo.csv", replace 

matrix spearman_obs= r(Nobs)

esttab matrix(spearman_obs) using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\spearman_mi_obs_full_neo.csv", replace

***************************************

*restrict to those with ogtt from GUSTO 

use mi_biomarker_lod_merge_full, clear

merge 1:1 subjectid using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\raw_data\ogtt_source"

keep if _merge==3

drop _merge 

merge 1:1 subjectid using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\data\raw_data\blood_col_var"

keep if _merge==3

keep if m_ogtt_source_pw26=="GUSTO_visit" //1003 obs 

keep if hospital==2 | (hospital==1 & col> date("201009", "YM")) // 522 obs 

drop subjectid m_ogtt_source_pw26-_merge ls_crp ls_insulin ls_ifng s_mbc3cre // 134 vars 

spearman s_sbp_avg ls_dbp_avg ls_map_avg /// 
ls_m_weight_pw26 ls_m_height_pw26 ls_m_midarm_pw26 s_m_triceps_pw26 ls_m_biceps_pw26 s_m_subscapular_pw26 s_m_suprailiac_pw26 ls_avg_weight_1sttri ls_avg_weight_2ndtri ls_avg_weight_3rdtri ls_last_antenatal_weight ///
ls_mpm3na ls_mpm3mg ls_mpm3p ls_mpm3k ls_mpm3ca ls_mpm3fe ls_mpm3fr ls_mpm3cu ls_mpm3zn s_mpm3se ls_mpm3tr ///
ls_mpm3my ls_mpm3pal ls_mpm3pl ls_mpm3st ls_mpm3ol ls_mpm3cv ls_mpm3li ls_mpm3li6 ls_mpm3li3 ls_mpm320 ls_mpm3n9 s_mpm32n6 ls_mpm33n6 ls_mpm3ar6 ls_mpm322 ls_mpm3n3 ls_mpm3epa ls_mpm3n62 ls_mpm3dpa ls_mpm3dha ls_mpm3tfa ls_mpm3tn3 ls_mpm3tn6 ls_mpm3sfa ls_mpm3muf ls_mpm3puf ls_mbc3tg s_mbc3tc s_mbc3hdl s_mbc3ldl ///
ls_mpm3fmn2 ls_mpm3ribo2 ls_mpm3mnam2 ls_mpm3nam2 ls_mpm3trig2 ls_mpm3py2 ls_mpm3plpb2 ls_mpm3pabe2 ls_mpm3fo ls_mpm3b12p s_mpm3vd3 ///
ls_mpm3arg2 ls_mpm3adma2 s_mpm3crn2 s_mpm3crea2 ls_mpm3harg2 ls_mpm3sdma2 ls_mpm3tml2 ls_mpm3csta2 ls_mpm3hcy2 s_mpm3tcys2 ls_mpm3m1hs2 ls_mpm3m3hs2 ls_mpm3hist2 ls_mpm3met2 ls_mpm3mtso2 ls_mpm3haa2 ls_mpm3hk2 ls_mpm3aa2 ls_mpm3ka2 ls_mpm3kyn2 ls_mpm3qa2 s_mpm3trp2 ls_mpm3xa2 ///
ls_mpm3betn2 ls_mpm3chol2 ls_mpm3dmg2 ls_mpm3tmao2 ///
ls_m_ogtt_fasting_pw26  ls_m_ogtt_2hour_pw26 ///
ls_adiponectin ls_pai1 ls_resistin ls_mcp1 ls_fsh ls_gh ls_lh ls_tsh ls_igfi ls_igfii ls_igfbp1 ls_igfbp3 ls_igfbp7 ls_cpeptide ls_leptin ls_tnfa ls_igfbp4 ls_mbc3ins ///
ls_mbc3ast ls_mbc3hscp ls_mbc3alt ls_mbc3ura ls_mpm3neo2 ///
ls_pfba ls_pfna ls_pfda ls_pfunda ls_pfhxs ls_pfoa ls_pfbs ls_pfos ///
s_psi_tri1 s_psi_tri2 s_psi_tri3 s_psi_pregnancy s_pm25_1st s_pm25_2nd s_pm25_3rd s_pm25_avg_daily_1, stats(rho p obs) pw

matrix spearman_out= r(Rho)

esttab matrix(spearman_out) using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\spearman_mi_full_sen_neo.csv", replace 

matrix spearman_obs= r(Nobs)

esttab matrix(spearman_obs) using "C:\Users\sumkk\SharePoint\Sum Ka Kei - EDRIVE\SICS\ses_exposome\results\spearman_mi_obs_full_sen_neo.csv", replace

log close









