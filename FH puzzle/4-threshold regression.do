/*-----4. Threshold regression--------*/
/* NOTE: you must install the panel threshold package (.ado files)developed by Wang (2015) in your STATA working directory.*/
/*Use "findit xthreg" to get the package*/
//findit xthreg

. clear
. use "OECD-1995-2015.dta"
xtset country year
gen workingpop=1-youngpop-oldpop
* 1) Test for Threshold in GDP growth
xthreg d.cdir,rx(d.cdsr) qx(grgdp) thnum(1) grid(400) trim(0.01) bs(300) thlevel(90)
xthreg d.cdir,rx(d.cdsr) qx(grgdp) thnum(2) grid(400) trim(0.01 0.01) bs(300 300) thlevel(90)
//Result: single threshold effect

* 2) Test for Threshold in size
xthreg d.cdir,rx(d.cdsr) qx(size) thnum(1) grid(400) trim(0.01) bs(300) thlevel(90)
xthreg d.cdir,rx(d.cdsr) qx(size) thnum(2) grid(400) trim(0.01 0.01) bs(300 300) thlevel(90)
//Result: single threshold effect


* 3) Test for Threshold in openness
xthreg d.cdir ,rx(d.cdsr) qx(openness) thnum(1) grid(400) trim(0.01) bs(300 thlevel(90)
xthreg d.cdir,rx(d.cdsr) qx(openness) thnum(2) grid(400) trim(0.01 0.01) bs(300 300) thlevel(90)
//Result: double threshold effect
 _matplot e(LR21), columns(1 2) yline(7.35, lpattern(dash)) connect(direct) msize(small) mlabp(0) mlabs(zero) ytitle("LR Statistics") xtitle("First Threshold") recast(line) name(LR21) title("Openness") scheme(s2mono) nodraw
. _matplot e(LR22), columns(1 2) yline(7.35, lpattern(dash)) connect(direct) msize(small) mlabp(0) mlabs(zero) ytitle("LR Statistics") xtitle("Second Threshold") recast(line) name(LR22) title("Openness") scheme(s2mono) nodraw
. graph combine LR21 LR22, cols(1)

* 4) Test for Threshold in findevelopment
xthreg d.cdir,rx(d.cdsr) qx(findevelop) thnum(1) grid(400) trim(0.01) bs(300) thlevel(90)
xthreg d.cdir,rx(d.cdsr) qx(findevelop) thnum(2) grid(400) trim(0.01 0.01) bs(300 300) thlevel(90)
//Result:no threshold effect

* 5) Test for Threshold in workingpop
xthreg d.cdir,rx(d.cdsr) qx(workingpop) thnum(1) grid(400) trim(0.01) bs(300) thlevel(90)
xthreg cdir,rx(cdsr) qx(workingpop) thnum(2) grid(400) trim(0.01 0.01) bs(300 300) thlevel(90)
//Result:no threshold effect


