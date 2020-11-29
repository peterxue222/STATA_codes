/*-----1. Use raw data to generate the dataset--------*/

/*1. population data (World Bank)*/
. clear
import excel "WB_youngpop.xls", sheet("Data")  firstrow clear /* import World Bank young population data from excel and generate .dta file*/
gen id = _n
order id
reshape long youngpop,i(id) j(year)
save "young.dta"

. clear
import excel "WB_oldpop.xls", sheet("Data")  firstrow clear /* import World Bank old population data from excel and generate .dta file*/
gen id = _n
order id
reshape long oldpop,i(id) j(year)
save "old.dta"

. clear
use "young.dta" 
merge 1:1 CountryCode year using "old.dta"
drop _merge id
rename CountryName country
rename CountryCode countrycode
replace country = "Republic of Korea" if country== "Korea, Rep."
save "pop.dta" /* merge old and young population data*/

. clear
use "pwt91.dta"  /* import penn world table 9.1 data */
 /* Align country name */
replace country="Vietnam" if country=="Viet Nam"
replace country="Tanzania" if country=="U.R. of Tanzania: Mainland"
merge 1:1 countrycode year using "pop.dta"
save "pwt-temp.dta"

/* 2. Financial development index data (IMF)*/
. clear
import excel "IMF_Financial development.xlsx", sheet("Financial Development (FD)")  firstrow clear
keep Year Country findevelopment
rename Year year
destring year, replace
rename Country country
replace country="China, Hong Kong SAR" if country=="China, P.R.: Hong Kong"
replace country="China" if country=="China, P.R.: Mainland"
replace country="China, Macao SAR" if country=="China, P.R.: Macao"
replace country="Republic of Korea" if country=="Korea, Republic of"
replace country="Venezuela (Bolivarian Republic of)" if country=="Venezuela, Republica Bolivariana de"
replace country="Iran (Islamic Republic of)" if country=="Iran, Islamic Republic of"
save "findevelopment.dta"

. clear
use "pwt-temp.dta"
drop _merge 
merge 1:1 country year using "D:\SISU\undergrad thesis\findevelopment.dta"
drop _merge
save "pwt.dta"

. clear
. use "pwt.dta"
drop if year<1994|year>2015/* NOTE: keep the year 1994 for the convenience of computing the GDP growth rate in 1995 */
keep if country=="Australia"|country=="Austria"|country=="Belgium"|country=="Canada"|country=="Denmark"|country=="Finland"|country=="France"|country=="Germany"|country=="Greece"|country=="Iceland"|country=="Ireland"|country=="Italy"|country=="Japan"|country=="Netherlands"|country=="New Zealand"|country=="Norway"|country=="Portugal"|country=="Spain"|country=="Sweden"|country=="Switzerland"|country=="Turkey"|country=="United Kingdom"|country=="United States"
/* Here we only consider the 24 countries that joined the OECD before 1990 (except Luxemberg)*/
encode country, generate(country2)
drop country
rename country2 country 
gen cdir=(cda-ccon)/cgdpe  /*add the variable "domestic investment rate" */
gen cdsr=(cgdpe-ccon)/cgdpe
tsset country year
gen grgdp= (cgdpe-l.cgdpe)/l.cgdpe
gen openness=csh_x-csh_m  /*add the variable "openness"*/
bys year: egen totalgdp=sum(cgdpe)
gen size=cgdpe/totalgdp /* add the variable "size" */
keep countrycode country year cdir cdsr grgdp openness  findevelopment size youngpop oldpop /* delete those unwanted variables */
drop if year<1995 /* we only consider the year from 1995 to 2015 */
save "OECD-1995-2015.dta"

/*The final dataset OECD-1995-2015.dta now has been generated. We will use it in the following steps.*/




