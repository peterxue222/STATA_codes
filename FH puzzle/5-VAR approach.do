/*-----5. VAR approach--------*/
/* NOTE-1: you must install the panel VAR package (.ado files)developed by Abrigo and Love(2015) in your STATA working directory.*/
/*Use "findit pvar" to get the package*/
//findit pvar
/* NOTE-2: you must execute the "1-generate the dataset.do" to generate "pwt.dta" before you run the codes below.*/


/* Preparation:　Gennerate the dataset with two main variables: "fiscal deficit (fisdeficit)" and "net private saving (psigap)". */
. clear
. import excel "fiscal deficit.xlsx", sheet("fisdeficit")  firstrow clear
save "fisdeficit.dta"
. clear
. use "pwt.dta"
merge m:m countrycode year using "fisdeficit.dta"
drop if year<1995|year>2015
keep if country=="Australia"|country=="Austria"|country=="Belgium"|country=="Canada"|country=="Denmark"|country=="Finland"|country=="France"|country=="Germany"|country=="Greece"|country=="Ireland"|country=="Italy"|country=="Netherlands"|country=="New Zealand"|country=="Norway"|country=="Portugal"|country=="Spain"|country=="Sweden"|country=="Switzerland"|country=="United Kingdom"|country=="United States" //Turkey is excluded because no available data.
gen cdir=(cda-ccon)/cgdpe  
gen cdsr=(cgdpe-ccon)/cgdpe 
gen psr=cdsr-fisdeficit*0.01
gen psigap= psr-cdir
gen fisdeficit2=0-fisdeficit*0.01
drop fisdeficit
rename fisdeficit2 fisdeficit
keep countrycode country year cdsr cdir psr psigap fisdeficit
drop countrycode
encode country, generate(country2)
drop country
rename country2 country 
tsset country year
save "PVAR.dta"

/* Run Panel VAR. */
. clear
. use "PVAR.dta"
xtset country year

*1)Panel unit root test
xtunitroot llc psigap,trend demean lags(bic 12)
xtunitroot llc fisdeficit, trend demean lags(bic 12)
xtunitroot ips psigap, trend demean lags(aic 12)
xtunitroot ips fisdeficit, trend demean lags(aic 12)
xtunitroot ht psigap,trend demean
xtunitroot ht fisdeficit, trend demean
xtunitroot hadri psigap, trend demean
xtunitroot hadri fisdeficit,trend demean
/* Use first difference of the two variables*/
gen dpsigap=d.psigap
gen dfisdeficit=d.fisdeficit
xtunitroot llc dpsigap,trend demean lags(bic 12)
xtunitroot llc dfisdeficit, trend demean lags(bic 12)
xtunitroot ips dpsigap, trend demean lags(aic 12)
xtunitroot ips dfisdeficit, trend demean lags(aic 12)
xtunitroot ht dpsigap,trend demean
xtunitroot ht dfisdeficit, trend demean
xtunitroot hadri dpsigap, trend demean
xtunitroot hadri dfisdeficit,trend demean


*2）lag order selection
pvarsoc dpsigap dfisdeficit, maxlag(3) pvaropts(instl(1/4))
//选择AIC,BIC或是QIC值最小的模型，lag=1时这三个值都是最小，因此选择滞后1阶

*3)Estimation by GMM
pvar dpsigap dfisdeficit,instlags(1/5) lag(1)fod level(95) gmmstyle
//滞后期为1
//fod消除面板的固定效应。fod指定使用正向正交偏差或Helmert变换来消除面板固定效应
//gmmstyle指定使用Douglas et.al(1988)提出的“GMM-style”工具。
pvarstable,graph
//所有特征值均在单位圆内，说明模型稳定

*4）Estimate impulse-response functions (IRF)
//pvarirf, step(10) impulse(dpsigap) response(fisdeficit) mc(1000)oirf level(95) dots byopt(rescale)
//pvarirf, step(10) impulse(fisdeficit) response(dpsigap) mc(1000)oirf level(95) dots byopt(rescale)
//子图像单独显示
pvarirf, porder(dpsigap dfisdeficit) step(10) mc(2000) oirf level(95) dots byopt(rescale) scheme(s2mono)
pvarirf, porder(dfisdeficit dpsigap) step(10) mc(2000) oirf level(95) dots byopt(rescale) scheme(s2mono)
//延后10期，95%置信区间，蒙特卡罗模拟2000次，加入延时点显示，每一个子图像都含有横纵坐标

*5)Forecast-error variance decompositions (FEVD)
pvarfevd, step(10) mc(2000) 
//2个差分内生变量分别作因变量时，其他变量对因变量的脉冲响应值

