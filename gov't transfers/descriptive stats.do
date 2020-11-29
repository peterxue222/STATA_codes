//Descriptive tables---2019.12

*1) basic descriptive table, correlation matrix
. clear
. use "mypaneldata.dta" 
tabstat unemp transfer grgdp, statistics(mean sd min p25 p50 p75 p90 max)
pwcorr unemp transfer grgdp , star(.01)

*2) about unemp and transfer statistics
. clear
. use "mypaneldata.dta"
sort id
tab year, sum(unemp)
tab year, sum(transfer)
tab country, sum(unemp)
tab country, sum(transfer)

*3) rank the mean value of government transfers and unemployment rates
/*** unemp***/
xtset id year
sort id
collapse (mean) unemp, by (country)
sort unemp
list in 1/20
/*** transfer payments***/
. clear
. use "mypaneldata.dta"
collapse (mean) transfer, by (country)
sort transfer
list in 1/20

*4)Line Graph
graph set window fontface "Times New Roman"
. clear
. use "mypaneldata.dta" 
xtset id year
xtline unemp if country =="Canada"|country=="Australia"|country=="France"|country=="UK"|country=="Germany"|country=="USA"|country=="Italy", overlay t(year) i(country) ytitle("Unemployment Rate") xtitle("Year") xlabel(1998(2)2015) legend(on) scheme(s2mono) note("Source: OECD Statistics", margin(medium))

*5) scatterplots
graph set window fontface "Times New Roman"
. clear
. use "mypaneldata.dta"
collapse(mean) unemp transfer, by(country)
br
twoway(scatter unemp transfer, sort mlabel(country)), scheme(s2mono) xtitle("{stSerif: Unemployment rate}") ytitle("{stSerif: Government transfers}") note("Source: OECD Statistics", margin(medium))

//end
