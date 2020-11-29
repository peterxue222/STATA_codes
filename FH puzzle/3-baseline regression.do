/*-----3. Baseline regression--------*/
/* NOTE: You MUST execute "1-generate the dataset.do" before you run the codes below. */
/*******Run baseline regressions*****/
. clear
. use "OECD-1995-2015.dta"
xtset country year /* declare the dataset to be panel data*/
gen workpop=1-youngpop-oldpop
xtreg cdir cdsr,fe  /* add the country-fixed effect*/
/* add the controlled variables gradully*/
xtreg cdir cdsr grgdp,fe 
xtreg cdir cdsr grgdp size,fe 
xtreg cdir cdsr grgdp openness size,fe 
xtreg cdir cdsr grgdp openness size findevelopment,fe 
xtreg cdir cdsr grgdp openness size findevelopment workpop,fe
/* Consider the interaction terms between domestic saving rate and other controlled variables*/
/*baseline model I (consist five models each with one interaction term)*/
xtreg cdir cdsr grgdp openness size findevelopment workpop c.cdsr#c.grgdp,fe
xtreg cdir cdsr grgdp openness size findevelopment workpop c.cdsr#c.size,fe
test cdsr c.cdsr#c.size
xtreg cdir cdsr grgdp openness size findevelopment workpop c.cdsr#c.openness,fe 
test cdsr c.cdsr#c.openness 
xtreg cdir cdsr grgdp openness size findevelopment workpop c.cdsr#c.findevelopment,fe  
test cdsr c.cdsr#c.findevelopment
xtreg cdir cdsr grgdp openness size findevelopment workpop c.cdsr#c.workpop,fe  
test cdsr c.cdsr#c.workpop
/*baseline model II (One model with five interaction terms)*/
xtreg cdir cdsr grgdp openness size findevelopment workpop c.cdsr#c.findevelopment c.cdsr#c.size c.cdsr#c.grgdp c.cdsr#c.openness c.cdsr#c.workpop,fe
test cdsr c.cdsr#c.findevelopment c.cdsr#c.size c.cdsr#c.grgdp c.cdsr#c.openness c.cdsr#c.workpop

/*******Compute the yearly average domestic saving rate, domestic investment rate, GDP growth rate, country size, financail development, and working population percentage for each OECD country*****/
. clear
. use "OECD-1995-2015.dta"
gen workpop=1-youngpop-oldpop
collapse cdir cdsr grgdp openness size findevelopment workpop, by(country)

