*******************************************************
***              Soccer Referee Skin Color Data     ***
***                     Main Analysis Code          ***
*******************************************************

clear all
set more off
cap close
set matsize 10000

*******************************************************
***                   Import Data                   ***
*******************************************************

use "/Users/nolan/Documents/nolan/research/soccer_referee_skincolor/data/usable_data/maindata.dta"

*** Folder for output
cd "/Users/nolan/Documents/nolan/research/soccer_referee_skincolor/output/"


*******************************************************
***              Prep and Clean Data                ***
*******************************************************

*** Generate playerid
egen playerid = group(player)
order playerid

*** Split birthday
split birthday, parse(.)
rename birthday1 birth_day
rename birthday2 birth_month
rename birthday3 birth_year

*** Replace "NA" with .
foreach X in rater1 rater2 height weight meaniat niat seiat meanexp nexp seexp {
    replace `X' = "." if `X' == "NA"
}

*** Destring numeric data
destring birth_month birth_day birth_year height weight rater1 rater2 ///
         meaniat niat seiat meanexp nexp seexp, replace

*** Generate age
gen age = 2013 - birth_year
gen age2 = age^2

*** Average skin color rating
gen rateravg = (rater1 + rater2) / 2


*******************************************************
***         Expand Data to Player-Game Level        ***
*******************************************************

gen dyadnum = _n
egen totyell    = total(yellowcards)
egen totred     = total(redcards)
egen totyellred = total(yellowreds)

expand games
gen order = _n

egen withinorder     = rank(order), by(dyadnum)
egen dyadyellowcards = max(yellowcards), by(dyadnum)
egen dyadyellowreds  = max(yellowreds), by(dyadnum)
egen dyadredcards    = max(redcards), by(dyadnum)

replace yellowcards = 1 if dyadyellowcards != 0 & withinorder <= dyadyellowcards
replace yellowcards = 0 if dyadyellowcards != 0 & withinorder > dyadyellowcards

replace yellowreds = 1 if dyadyellowreds != 0 & withinorder <= dyadyellowreds
replace yellowreds = 0 if dyadyellowreds != 0 & withinorder > dyadyellowreds

replace redcards = 1 if dyadredcards != 0 & withinorder <= dyadredcards
replace redcards = 0 if dyadredcards != 0 & withinorder > dyadredcards

egen totyell2    = total(yellowcards)
egen totred2     = total(redcards)
egen totyellred2 = total(yellowreds)

sum tot*

* Note: The reason for the 4 card difference between totyell and totyell2 is that there are 4 dyads with 1 game but 2 yellow cards.
* I don't know how this happened since if a player gets 2 yellow cards it should be a yellowred.
* These four are treated as if 1 yellow card was given.

drop playershort birthday order withinorder dyadyellowcards dyadyellowreds ///
     dyadredcards totyell totred totyellred totyell2 totred2 totyellred2


*******************************************************
***            Create Derived Variables             ***
*******************************************************

*** Any red card (straight red or yellowred)
gen anyred = 0
replace anyred = 1 if redcards == 1 | yellowreds == 1

*** Any card (red, yellowred, or yellow)
gen anycard = 0
replace anycard = 1 if redcards == 1 | yellowreds == 1 | yellowcards == 1

*** Numeric groups for fixed effects
egen clubnum          = group(club)
egen leaguecountrynum = group(leaguecountry)
egen positionnum      = group(position)

*** Squared terms
gen height2 = height^2
gen weight2 = weight^2


*******************************************************
***        Normalize Bias Scores by Country         ***
*******************************************************

preserve

drop if meaniat == . | meanexp == .
sort refcountry
drop if refcountry == refcountry[_n-1]
keep meaniat meanexp refcountry

egen zmeaniat = std(meaniat)
egen zmeanexp = std(meanexp)

drop meaniat meanexp
save "normalized_country_bias.dta", replace

restore
merge m:1 refcountry using "normalized_country_bias.dta", keep(master match)


*******************************************************
***             Summary Statistics Table            ***
*******************************************************

file open table1sum using "table1sum.txt", write replace

foreach var in age height weight yellowcards redcards anyred {
    sum `var'
    file write table1sum "`var'" _tab %9.2fc (r(mean)) _tab %9.2fc (r(sd)) _n
}

file close table1sum


*******************************************************
***                    Analysis                     ***
*******************************************************

cap log close
log using log, replace


*******************************************************
***              QUESTION 1: Red Cards              ***
*******************************************************

****** Red Cards Regression
reg redcards rateravg, robust
outreg2 using "table2_red_reg", replace se bdec(6) sdec(6) bracket nocons sortvar(rateravg)

reg redcards rateravg height height2 weight weight2 age age2, robust
outreg2 using "table2_red_reg", append se bdec(6) sdec(6) bracket nocons sortvar(rateravg height height2 weight weight2 age age2)

reg redcards rateravg height height2 weight weight2 age age2 i.leaguecountrynum i.positionnum, robust
outreg2 using "table2_red_reg", append se bdec(6) sdec(6) bracket nocons

reg redcards rateravg height height2 weight weight2 age age2 i.leaguecountrynum i.positionnum i.clubnum, robust
outreg2 using "table2_red_reg", append se bdec(6) sdec(6) bracket nocons

areg redcards rateravg height height2 weight weight2 age age2 i.leaguecountrynum i.positionnum i.clubnum, a(refnum) robust
outreg2 using "table2_red_reg", append se bdec(6) sdec(6) bracket nocons


****** Red Cards Logit
cap file close table3
file open table3 using "table3_probit_red.txt", write replace

logit redcards rateravg
margins, dydx(rateravg) atmeans
mat b = r(table)
file write table3 %9.6fc (b[1,1]) _tab "[" %9.6fc (b[2,1]) "]" _tab %9.0fc (e(N)) _tab %9.2fc (e(r2_p)) _n

logit redcards rateravg height weight height2 weight2 age age2
margins, dydx(rateravg) atmeans
mat b = r(table)
file write table3 %9.6fc (b[1,1]) _tab "[" %9.6fc (b[2,1]) "]" _tab %9.0fc (e(N)) _tab %9.2fc (e(r2_p)) _n

logit redcards rateravg height weight height2 weight2 age age2 i.leaguecountrynum i.positionnum
margins, dydx(rateravg) atmeans
mat b = r(table)
file write table3 %9.6fc (b[1,1]) _tab "[" %9.6fc (b[2,1]) "]" _tab %9.0fc (e(N)) _tab %9.2fc (e(r2_p)) _n

logit redcards rateravg height weight height2 weight2 age age2 i.leaguecountrynum i.clubnum i.positionnum
margins, dydx(rateravg) atmeans
mat b = r(table)
file write table3 %9.6fc (b[1,1]) _tab "[" %9.6fc (b[2,1]) "]" _tab %9.0fc (e(N)) _tab %9.2fc (e(r2_p)) _n

cap file close table3

/***********************************************************************
 ***** RED CARDS REGRESSION NONLINEAR
***********************************************************************/

reg redcards i.rater1, robust
outreg2 using "table4_red_reg_nonl", replace se bdec(6) sdec(6) bracket nocons

reg redcards i.rater1 height height2 weight weight2 age age2, robust
outreg2 using "table4_red_reg_nonl", append se bdec(6) sdec(6) bracket nocons

reg redcards i.rater1 height height2 weight weight2 age age2 ///
    i.leaguecountrynum i.positionnum, robust
outreg2 using "table4_red_reg_nonl", append se bdec(6) sdec(6) bracket nocons

reg redcards i.rater1 height height2 weight weight2 age age2 ///
    i.leaguecountrynum i.positionnum i.clubnum, robust
outreg2 using "table4_red_reg_nonl", append se bdec(6) sdec(6) bracket nocons

areg redcards i.rater1 height height2 weight weight2 age age2 ///
    i.leaguecountrynum i.positionnum i.clubnum, a(refnum) robust
outreg2 using "table4_red_reg_nonl", append se bdec(6) sdec(6) bracket nocons


/***********************************************************************
 ***** ANY RED CARDS REGRESSION
***********************************************************************/

reg anyred rateravg, robust
outreg2 using "table5a_anyred_reg", replace se bdec(6) sdec(6) bracket nocons sortvar(rateravg)

reg anyred rateravg height height2 weight weight2 age age2, robust
outreg2 using "table5a_anyred_reg", append se bdec(6) sdec(6) bracket nocons ///
    sortvar(rateravg height height2 weight weight2 age age2)

reg anyred rateravg height height2 weight weight2 age age2 ///
    i.leaguecountrynum i.positionnum, robust
outreg2 using "table5a_anyred_reg", append se bdec(6) sdec(6) bracket nocons ///
    sortvar(rateravg height height2 weight weight2 age age2)

reg anyred rateravg height height2 weight weight2 age age2 ///
    i.leaguecountrynum i.positionnum i.clubnum, robust
outreg2 using "table5a_anyred_reg", append se bdec(6) sdec(6) bracket nocons ///
    sortvar(rateravg height height2 weight weight2 age age2)

areg anyred rateravg height height2 weight weight2 age age2 ///
    i.leaguecountrynum i.positionnum i.clubnum, a(refnum) robust
outreg2 using "table5a_anyred_reg", append se bdec(6) sdec(6) bracket nocons ///
    sortvar(rateravg height height2 weight weight2 age age2)


/***********************************************************************
 ***** ANY RED CARDS LOGIT
***********************************************************************/

cap file close table5b
file open table5b using "table5b_probit_anyred.txt", write replace

logit anyred rateravg
margins, dydx(rateravg) atmeans
mat b = r(table)
file write table5b %9.6fc (b[1,1]) _tab "[" %9.6fc (b[2,1]) "]" _tab ///
    %9.0fc (e(N)) _tab %9.2fc (e(r2_p)) _n

logit anyred rateravg height weight height2 weight2 age age2
margins, dydx(rateravg) atmeans
mat b = r(table)
file write table5b %9.6fc (b[1,1]) _tab "[" %9.6fc (b[2,1]) "]" _tab ///
    %9.0fc (e(N)) _tab %9.2fc (e(r2_p)) _n

logit anyred rateravg height weight height2 weight2 age age2 ///
    i.leaguecountrynum i.positionnum
margins, dydx(rateravg) atmeans
mat b = r(table)
file write table5b %9.6fc (b[1,1]) _tab "[" %9.6fc (b[2,1]) "]" _tab ///
    %9.0fc (e(N)) _tab %9.2fc (e(r2_p)) _n

logit anyred rateravg height weight height2 weight2 age age2 ///
    i.leaguecountrynum i.clubnum i.positionnum
margins, dydx(rateravg) atmeans
mat b = r(table)
file write table5b %9.6fc (b[1,1]) _tab "[" %9.6fc (b[2,1]) "]" _tab ///
    %9.0fc (e(N)) _tab %9.2fc (e(r2_p)) _n

* Heavy model (too many referee dummies)
* logit anyred rateravg height weight height2 weight2 age age2 ///
*     i.leaguecountrynum i.clubnum i.positionnum i.refnum
* margins, dydx(rateravg) atmeans
* mat b = r(table)
* file write table5b %9.6fc (b[1,1]) _tab "[" %9.6fc (b[2,1]) "]" _tab ///
*     %9.0fc (e(N)) _tab %9.2fc (e(r2_p)) _n

cap file close table5b


/***********************************************************************
 ***** ANY RED CARDS NONLINEAR REGRESSION
***********************************************************************/

reg anyred i.rater1, robust
outreg2 using "table5c_nonlinear_anyred", replace se bdec(6) sdec(6) bracket nocons

reg anyred i.rater1 height height2 weight weight2 age age2, robust
outreg2 using "table5c_nonlinear_anyred", append se bdec(6) sdec(6) bracket nocons

reg anyred i.rater1 height height2 weight weight2 age age2 ///
    i.leaguecountrynum i.positionnum, robust
outreg2 using "table5c_nonlinear_anyred", append se bdec(6) sdec(6) bracket nocons

reg anyred i.rater1 height height2 weight weight2 age age2 ///
    i.leaguecountrynum i.positionnum i.clubnum, robust
outreg2 using "table5c_nonlinear_anyred", append se bdec(6) sdec(6) bracket nocons

areg anyred i.rater1 height height2 weight weight2 age age2 ///
    i.leaguecountrynum i.positionnum i.clubnum, a(refnum) robust
outreg2 using "table5c_nonlinear_anyred", append se bdec(6) sdec(6) bracket nocons


/***********************************************************************
 ***** YELLOW CARDS REGRESSION
***********************************************************************/

reg yellowcards rateravg, robust
outreg2 using "table6_yellow_reg", replace se bdec(6) sdec(6) bracket nocons sortvar(rateravg)

reg yellowcards rateravg height height2 weight weight2 age age2, robust
outreg2 using "table6_yellow_reg", append se bdec(6) sdec(6) bracket nocons ///
    sortvar(rateravg height height2 weight weight2 age age2)

reg yellowcards rateravg height height2 weight weight2 age age2 ///
    i.leaguecountrynum i.positionnum, robust
outreg2 using "table6_yellow_reg", append se bdec(6) sdec(6) bracket nocons ///
    sortvar(rateravg height height2 weight weight2 age age2)

reg yellowcards rateravg height height2 weight weight2 age age2 ///
    i.leaguecountrynum i.positionnum i.clubnum, robust
outreg2 using "table6_yellow_reg", append se bdec(6) sdec(6) bracket nocons ///
    sortvar(rateravg height height2 weight weight2 age age2)

areg yellowcards rateravg height height2 weight weight2 age age2 ///
    i.leaguecountrynum i.positionnum i.clubnum, a(refnum) robust
outreg2 using "table6_yellow_reg", append se bdec(6) sdec(6) bracket nocons ///
    sortvar(rateravg height height2 weight weight2 age age2)


/***********************************************************************
 ***** YELLOW CARDS LOGIT
***********************************************************************/

cap file close table7
file open table7 using "table7_probit_yellow.txt", write replace

logit yellowcards rateravg
margins, dydx(rateravg) atmeans
mat b = r(table)
file write table7 %9.6fc (b[1,1]) _tab "[" %9.6fc (b[2,1]) "]" _tab ///
    %9.0fc (e(N)) _tab %9.2fc (e(r2_p)) _n

logit yellowcards rateravg height weight height2 weight2 age age2
margins, dydx(rateravg) atmeans
mat b = r(table)
file write table7 %9.6fc (b[1,1]) _tab "[" %9.6fc (b[2,1]) "]" _tab ///
    %9.0fc (e(N)) _tab %9.2fc (e(r2_p)) _n

logit yellowcards rateravg height weight height2 weight2 age age2 ///
    i.leaguecountrynum i.positionnum
margins, dydx(rateravg) atmeans
mat b = r(table)
file write table7 %9.6fc (b[1,1]) _tab "[" %9.6fc (b[2,1]) "]" _tab ///
    %9.0fc (e(N)) _tab %9.2fc (e(r2_p)) _n

logit yellowcards rateravg height weight height2 weight2 age age2 ///
    i.leaguecountrynum i.clubnum i.positionnum
margins, dydx(rateravg) atmeans
mat b = r(table)
file write table7 %9.6fc (b[1,1]) _tab "[" %9.6fc (b[2,1]) "]" _tab ///
    %9.0fc (e(N)) _tab %9.2fc (e(r2_p)) _n

* Heavy model (too many referee dummies)
* logit yellowcards rateravg height weight height2 weight2 age age2 ///
*     i.leaguecountrynum i.clubnum i.positionnum i.refnum
* margins, dydx(rateravg) atmeans
* mat b = r(table)
* file write table7 %9.6fc (b[1,1]) _tab "[" %9.6fc (b[2,1]) "]" _tab ///
*     %9.0fc (e(N)) _tab %9.2fc (e(r2_p)) _n

cap file close table7
/*********************************/
/********** Yellow Cards Regression nonlinear ***********/

reg yellowcards i.rater1, robust
outreg2 using "table8_yellow_reg_nonl", replace se bdec(6) sdec(6) bracket nocons

reg yellowcards i.rater1 height height2 weight weight2 age age2, robust
outreg2 using "table8_yellow_reg_nonl", append se bdec(6) sdec(6) bracket nocons

reg yellowcards i.rater1 height height2 weight weight2 age age2 i.leaguecountrynum i.positionnum, robust
outreg2 using "table8_yellow_reg_nonl", append se bdec(6) sdec(6) bracket nocons

reg yellowcards i.rater1 height height2 weight weight2 age age2 i.leaguecountrynum i.positionnum i.clubnum, robust
outreg2 using "table8_yellow_reg_nonl", append se bdec(6) sdec(6) bracket nocons

areg yellowcards i.rater1 height height2 weight weight2 age age2 i.leaguecountrynum i.positionnum i.clubnum, a(refnum) robust
outreg2 using "table8_yellow_reg_nonl", append se bdec(6) sdec(6) bracket nocons

/*********************************/
/********** QUESTION 2 ***********/

/* Create 'dark' indicator */
gen dark = .
replace dark = 0 if rater1 == 1 | rater1 == 2
replace dark = 1 if rater1 == 3 | rater1 == 4 | rater1 == 5

/*********************************/
/*** Red cards Implicit bias ***/
cap file close table9
file open table9 using "table9_implicitred.txt", write replace

reg redcards zmeaniat if dark == 0
mat blight = e(b)
mat vlight = e(V)
file write table9 %9.6fc (_b[zmeaniat]) _tab "[" %9.6fc (_se[zmeaniat]) "]" _tab %9.0fc (e(N)) _tab %9.2fc (e(r2)) _tab

reg redcards zmeaniat if dark == 1
mat bdark = e(b)
mat vdark = e(V)
file write table9 %9.6fc (_b[zmeaniat]) _tab "[" %9.6fc (_se[zmeaniat]) "]" _tab %9.0fc (e(N)) _tab %9.2fc (e(r2)) _tab

file write table9 %9.6fc ((bdark[1,1] - blight[1,1])) _tab %9.3fc (1 - ttail(10000, (bdark[1,1] - blight[1,1])/((vdark[1,1] + vlight[1,1])^0.5))) _n

areg redcards zmeaniat if dark == 0, a(playerid)
mat blight = e(b)
mat vlight = e(V)
file write table9 %9.6fc (_b[zmeaniat]) _tab "[" %9.6fc (_se[zmeaniat]) "]" _tab %9.0fc (e(N)) _tab %9.2fc (e(r2)) _tab

areg redcards zmeaniat if dark == 1, a(playerid)
mat bdark = e(b)
mat vdark = e(V)
file write table9 %9.6fc (_b[zmeaniat]) _tab "[" %9.6fc (_se[zmeaniat]) "]" _tab %9.0fc (e(N)) _tab %9.2fc (e(r2)) _tab

file write table9 %9.6fc ((bdark[1,1] - blight[1,1])) _tab %9.3fc (ttail(10000, (bdark[1,1] - blight[1,1])/((vdark[1,1] + vlight[1,1])^0.5))) _n

/*********************************/
/*** Red cards Explicit bias ***/
reg redcards zmeanexp if dark == 0
mat blight = e(b)
mat vlight = e(V)
file write table9 %9.6fc (_b[zmeanexp]) _tab "[" %9.6fc (_se[zmeanexp]) "]" _tab %9.0fc (e(N)) _tab %9.2fc (e(r2)) _tab

reg redcards zmeanexp if dark == 1
mat bdark = e(b)
mat vdark = e(V)
file write table9 %9.6fc (_b[zmeanexp]) _tab "[" %9.6fc (_se[zmeanexp]) "]" _tab %9.0fc (e(N)) _tab %9.2fc (e(r2)) _tab

file write table9 %9.6fc ((bdark[1,1] - blight[1,1])) _tab %9.3fc (1 - ttail(10000, (bdark[1,1] - blight[1,1])/((vdark[1,1] + vlight[1,1])^0.5))) _n

areg redcards zmeanexp if dark == 0, a(playerid)
mat blight = e(b)
mat vlight = e(V)
file write table9 %9.6fc (_b[zmeanexp]) _tab "[" %9.6fc (_se[zmeanexp]) "]" _tab %9.0fc (e(N)) _tab %9.2fc (e(r2)) _tab

areg redcards zmeanexp if dark == 1, a(playerid)
mat bdark = e(b)
mat vdark = e(V)
file write table9 %9.6fc (_b[zmeanexp]) _tab "[" %9.6fc (_se[zmeanexp]) "]" _tab %9.0fc (e(N)) _tab %9.2fc (e(r2)) _tab

file write table9 %9.6fc ((bdark[1,1] - blight[1,1])) _tab %9.3fc (ttail(10000, (bdark[1,1] - blight[1,1])/((vdark[1,1] + vlight[1,1])^0.5))) _n

cap file close table9

/*********************************/
/*** Yellow cards Implicit bias ***/
cap file close table10
file open table10 using "table10_implicityellow.txt", write replace

reg yellowcards zmeaniat if dark == 0
mat blight = e(b)
mat vlight = e(V)
file write table10 %9.6fc (_b[zmeaniat]) _tab "[" %9.6fc (_se[zmeaniat]) "]" _tab %9.0fc (e(N)) _tab %9.2fc (e(r2)) _tab

reg yellowcards zmeaniat if dark == 1
mat bdark = e(b)
mat vdark = e(V)
file write table10 %9.6fc (_b[zmeaniat]) _tab "[" %9.6fc (_se[zmeaniat]) "]" _tab %9.0fc (e(N)) _tab %9.2fc (e(r2)) _tab

file write table10 %9.6fc ((bdark[1,1] - blight[1,1])) _tab %9.3fc (1 - ttail(10000, (bdark[1,1] - blight[1,1])/((vdark[1,1] + vlight[1,1])^0.5))) _n

areg yellowcards zmeaniat if dark == 0, a(playerid)
mat blight = e(b)
mat vlight = e(V)
file write table10 %9.6fc (_b[zmeaniat]) _tab "[" %9.6fc (_se[zmeaniat]) "]" _tab %9.0fc (e(N)) _tab %9.2fc (e(r2)) _tab

areg yellowcards zmeaniat if dark == 1, a(playerid)
mat bdark = e(b)
mat vdark = e(V)
file write table10 %9.6fc (_b[zmeaniat]) _tab "[" %9.6fc (_se[zmeaniat]) "]" _tab %9.0fc (e(N)) _tab %9.2fc (e(r2)) _tab

file write table10 %9.6fc ((bdark[1,1] - blight[1,1])) _tab %9.3fc (1 - ttail(10000, (bdark[1,1] - blight[1,1])/((vdark[1,1] + vlight[1,1])^0.5))) _n

/*********************************/
/*** Yellow cards Explicit bias ***/
reg yellowcards zmeanexp if dark == 0
mat blight = e(b)
mat vlight = e(V)
file write table10 %9.6fc (_b[zmeanexp]) _tab "[" %9.6fc (_se[zmeanexp]) "]" _tab %9.0fc (e(N)) _tab %9.2fc (e(r2)) _tab

reg yellowcards zmeanexp if dark == 1
mat bdark = e(b)
mat vdark = e(V)
file write table10 %9.6fc (_b[zmeanexp]) _tab "[" %9.6fc (_se[zmeanexp]) "]" _tab %9.0fc (e(N)) _tab %9.2fc (e(r2)) _tab

file write table10 %9.6fc ((bdark[1,1] - blight[1,1])) _tab %9.3fc (1 - ttail(10000, (bdark[1,1] - blight[1,1])/((vdark[1,1] + vlight[1,1])^0.5))) _n

areg yellowcards zmeanexp if dark == 0, a(playerid)
mat blight = e(b)
mat vlight = e(V)
file write table10 %9.6fc (_b[zmeanexp]) _tab "[" %9.6fc (_se[zmeanexp]) "]" _tab %9.0fc (e(N)) _tab %9.2fc (e(r2)) _tab

areg yellowcards zmeanexp if dark == 1, a(playerid)
mat bdark = e(b)
mat vdark = e(V)
file write table10 %9.6fc (_b[zmeanexp]) _tab "[" %9.6fc (_se[zmeanexp]) "]" _tab %9.0fc (e(N)) _tab %9.2fc (e(r2)) _tab

file write table10 %9.6fc ((bdark[1,1] - blight[1,1])) _tab %9.3fc (ttail(10000, (bdark[1,1] - blight[1,1])/((vdark[1,1] + vlight[1,1])^0.5))) _n

cap file close table10

/*********************************/
/*** Any Red cards Implicit bias ***/
cap file close table11
file open table11 using "table11_implicitanyred.txt", write replace

reg anyred zmeaniat if dark == 0
mat blight = e(b)
mat vlight = e(V)
file write table11 %9.6fc (_b[zmeaniat]) _tab "[" %9.6fc (_se[zmeaniat]) "]" _tab %9.0fc (e(N)) _tab %9.2fc (e(r2)) _tab

reg anyred zmeaniat if dark == 1
mat bdark = e(b)
mat vdark = e(V)
file write table11 %9.6fc (_b[zmeaniat]) _tab "[" %9.6fc (_se[zmeaniat]) "]" _tab %9.0fc (e(N)) _tab %9.2fc (e(r2)) _tab

file write table11 %9.6fc ((bdark[1,1] - blight[1,1])) _tab %9.3fc (1 - ttail(10000, (bdark[1,1] - blight[1,1])/((vdark[1,1] + vlight[1,1])^0.5))) _n

areg anyred zmeaniat if dark == 0, a(playerid)
mat blight = e(b)
mat vlight = e(V)
file write table11 %9.6fc (_b[zmeaniat]) _tab "[" %9.6fc (_se[zmeaniat]) "]" _tab %9.0fc (e(N)) _tab %9.2fc (e(r2)) _tab

areg anyred zmeaniat if dark == 1, a(playerid)
mat bdark = e(b)
mat vdark = e(V)
file write table11 %9.6fc (_b[zmeaniat]) _tab "[" %9.6fc (_se[zmeaniat]) "]" _tab %9.0fc (e(N)) _tab %9.2fc (e(r2)) _tab

file write table11 %9.6fc ((bdark[1,1] - blight[1,1])) _tab %9.3fc (ttail(10000, (bdark[1,1] - blight[1,1])/((vdark[1,1] + vlight[1,1])^0.5))) _n

/*********************************/
/*** Any Red cards Explicit bias ***/
reg anyred zmeanexp if dark == 0
mat blight = e(b)
mat vlight = e(V)
file write table11 %9.6fc (_b[zmeanexp]) _tab "[" %9.6fc (_se[zmeanexp]) "]" _tab %9.0fc (e(N)) _tab %9.2fc (e(r2)) _tab

reg anyred zmeanexp if dark == 1
mat bdark = e(b)
mat vdark = e(V)
file write table11 %9.6fc (_b[zmeanexp]) _tab "[" %9.6fc (_se[zmeanexp]) "]" _tab %9.0fc (e(N)) _tab %9.2fc (e(r2)) _tab

file write table11 %9.6fc ((bdark[1,1] - blight[1,1])) _tab %9.3fc (1 - ttail(10000, (bdark[1,1] - blight[1,1])/((vdark[1,1] + vlight[1,1])^0.5))) _n

areg anyred zmeanexp if dark == 0, a(playerid)
mat blight = e(b)
mat vlight = e(V)
file write table11 %9.6fc (_b[zmeanexp]) _tab "[" %9.6fc (_se[zmeanexp]) "]" _tab %9.0fc (e(N)) _tab %9.2fc (e(r2)) _tab

areg anyred zmeanexp if dark == 1, a(playerid)
mat bdark = e(b)
mat vdark = e(V)
file write table11 %9.6fc (_b[zmeanexp]) _tab "[" %9.6fc (_se[zmeanexp]) "]" _tab %9.0fc (e(N)) _tab %9.2fc (e(r2)) _tab

file write table11 %9.6fc ((bdark[1,1] - blight[1,1])) _tab %9.3fc (ttail(10000, (bdark[1,1] - blight[1,1])/((vdark[1,1] + vlight[1,1])^0.5))) _n

cap file close table11
