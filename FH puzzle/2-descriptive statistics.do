/*-----2. Descriptive statistics--------*/
/*
NOTE: You MUST execute "1-generate the dataset.do" to generate the datasets needed before you run the codes below. 
*/

*1)basic descriptive table
. clear
. use "OECD-1995-2015.dta"
gen workingpop=1-youngpop-oldpop 
tabstat cdir cdsr grgdp openness size findevelopment workingpop, statistics(count mean sd min p25 p50 p75 p90 max)
pwcorr cdir cdsr, star(.01) /* compute pearson correlation*/

*2) Display the S-I relation in eight developed economies
use "OECD-1995-2015.dta",clear
rename cdir IR, replace
rename cdsr SR, replace
twoway line IR SR year if countrycode=="CAN", xtitle("Year") xscale(range(1995 2015)) legend(on) scheme(s2mono) title("Canada") nodraw
graph save a1
use "OECD-1995-2015.dta",clear
rename cdir IR, replace
rename cdsr SR, replace
twoway line IR SR year if countrycode=="AUS", xtitle("Year") xscale(range(1995 2015)) legend(on) scheme(s2mono) title("Australia") nodraw
graph save a2
use "OECD-1995-2015.dta",clear
rename cdir IR, replace
rename cdsr SR, replace
twoway line IR SR year if countrycode=="FRA", xtitle("Year") xscale(range(1995 2015)) legend(on) scheme(s2mono) title("France") nodraw
graph save a3
use "OECD-1995-2015.dta",clear
rename cdir IR, replace
rename cdsr SR, replace
twoway line IR SR year if countrycode=="GBR", xtitle("Year") xscale(range(1995 2015)) legend(on) scheme(s2mono) title("United Kingdom") nodraw
graph save a4
use "OECD-1995-2015.dta",clear
rename cdir IR, replace
rename cdsr SR, replace
twoway line IR SR year if countrycode=="DEU", xtitle("Year") xscale(range(1995 2015)) legend(on) scheme(s2mono) title("Germany") nodraw
graph save a5
use "OECD-1995-2015.dta",clear
rename cdir IR, replace
rename cdsr SR, replace
twoway line IR SR year if countrycode=="USA", xtitle("Year") xscale(range(1995 2015)) legend(on) scheme(s2mono) title("United States") nodraw
graph save a6
use "OECD-1995-2015.dta",clear
rename cdir IR, replace
rename cdsr SR, replace
twoway line IR SR year if countrycode=="JPN", xtitle("Year") xscale(range(1995 2015)) legend(on) scheme(s2mono) title("Japan") nodraw
graph save a7
use "OECD-1995-2015.dta",clear
rename cdir IR, replace
rename cdsr SR, replace
twoway line IR SR year if countrycode=="ITA", xtitle("Year") xscale(range(1995 2015)) legend(on) scheme(s2mono) title("Italy") nodraw
graph save a8
graph combine a1.gph a2.gph a3.gph a4.gph a5.gph a6.gph a7.gph a8.gph, col(4)

*3)generate scatterplots (optional)
. clear
. use "OECD-1995-2015.dta" 
collapse(mean) cdir cdsr, by(countrycode)
br
graph twoway (scatter cdir cdsr), ylabel(0(0.1)0.5) xlabel(0(0.1)0.5) scheme(s2mono) xtitle("yearly average domestic saving rate") ytitle("yearly domestic investment rate") note("Source: Penn World Table Version 9.1", margin(medium)) graphregion(fcolor(white) lpattern(solid) lcolor(black) lwidth(medium)) legend(off)


