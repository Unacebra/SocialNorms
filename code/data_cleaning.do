clear all
clear matrix
set more off
 set maxvar 32000


/* The Tired and The Blind - Cognitive Load Over Norm-following behavior*/
*********   Pre-Data  **********

/*  Sebastián Ramírez */
/* Advisors: Silvia L - Diego A*/
/* Created: 2021-03-21 */
/* Last modified: 2021-06-22 */



//*Generate path to access to all the .xls of each session in each treatment


//cd C:\Users\user\Desktop\DATA-PvsV


//cd    C:\Users\user\Dropbox\trust_COVID\Sesiones_piloto

clear all
  cd    C:\Users\user\Dropbox\Tesis
global my_path "C:\Users\user\Dropbox\Tesis"
  
global datos  "$my_path\Raw" 
global path_graphs "C:\Users\user\Dropbox\Tesis\graficas"
global path_tables "C:\Users\user\Dropbox\Tesis\tablas"

//FILES FOR EACH TREATMENT


cd $datos


global files  " all_apps_wide-2021-11-12 all_apps_wide-2021-11-13 all_apps_wide-2021-11-171 all_apps_wide-2021-11-172 all_apps_wide-2021-11-173 all_apps_wide-2021-11-181 all_apps_wide-2021-11-182 all_apps_wide-2021-11-183 all_apps_wide-2021-11-28 all_apps_wide-2021-11-282 all_apps_wide-2021-12-01 all_apps_wide-2021-11-302"

local i = 0
*we have a problem with the var names, so we import the variables withouts names, then we armonize the variables names
foreach otreefile of global files  {
	import delimited `otreefile'.csv, varnames(nonames) 
	foreach var of varlist _all {
		replace `var' = subinstr(`var', ".player", "", .)
		replace `var' = subinstr(`var', ".", "", .)
		replace `var' = subinstr(`var', "»", "", .)
		replace `var' = subinstr(`var', "subsession", "", .)
		replace `var' = subinstr(`var', "ï", "", .)
		replace `var' = subinstr(`var',"¿", "", .)
		cap replace `var' = subinstr(`var', "participant", "", .)
		cap replace `var' = subinstr(`var', "trust_nfJ21", "", .)
		cap replace `var' = subinstr(`var', "cuestionario", "", .)
		cap replace `var' = subinstr(`var', "baskets", "b", .)
		cap replace `var' = subinstr(`var', "introduction", "", .)
		cap replace `var' = subinstr(`var', "std_bas1", "", .)
		cap replace `var' = subinstr(`var', "alzgame1", "e", .)
		cap replace `var' = subinstr(`var', "alzgame2", "r1", .)
		cap replace `var' = subinstr(`var', "alzgame3","r2", .)
		cap replace `var' = subinstr(`var', "alzgame4", "r3", .)
		cap replace `var' = subinstr(`var', "s1", "", .)
	}
		forval j = 1/208 {	
		cap    rename v`j' `=v`j'[1]'
	}
	drop if _n == 1
	*dropping innecesary variables
	drop _index_in_pages _max_page_index _current_app_name label _is_bot sessionconfigtime_delay_char sessionis_demo sessioncomment sessionconfigrepeated_key 	sessionconfigcharacters sessionconfign_characters_test sessionconfig* sessionmturk_HITId sessionmturk_HITGroupId r1TRC1 r1TRC2 r1TRC3 r2TRC1 r2TRC2 r2TRC3 r3TRC1 r3TRC2 r3TRC3 mturk_worker_id mentdeman physdeman perfodeman tempdeman frustation _current_page_name visited
save `otreefile'.dta , replace
clear
}



*We append all the session data files
cap foreach otreefile of global files  {
	local   i=`i'+1  
*rename session session.code
	append using `otreefile'.dta
	capture gen    ses = `i'
	replace ses = `i' if ses == .
	compress
}

save data, replace

*converting our string variables in byte or integer
destring *, replace
drop if pagos_bolas == 0

*Creating our treatment variable
gen tratamiento = 0 
replace tratamiento = 1 if ebase == "NA"
label variable tratamiento "Treatment"
label define tratamiento 0  "Low Cognitive Load" 1 "High Cognitive Load" 
label value tratamiento tratamientom 




/*
 We revise the Cognitive Reflection Test and assign the puntuation  
1.	CRT-Regular
●	Add up all correct answers 
●	Scores range from 0 (subject gave all either intuitive incorrect or other incorrect responses) to 6 (subject gave all correct responses)

3.	CRT-Proportion Intuitive
●	Create a proportion based on total incorrect responses: (# intuitively incorrect responses/# both intuitive and other incorrect responses)
●	For example: Subject responds to 6 items with 1 correct answer, 3 intuitively correct answers, and 2 other incorrect answers (3 intuitively incorrect answers/5 total incorrect answers; Total Score= 0.6)
●	Scores range from 0 (subject gave no intuitively incorrect answers) to 1 (all of subject's incorrect answers were intuitively incorrect)
*This scoring procedure only takes into account 2 different types of incorrect responses, which can help predict a subject's tendency to rely on their intuition
*Higher scores reflect higher tendency to rely on intuition

4.	CRT-Reflection
●	For each item, subject receives a score of 1 for all non-intuitive responses (i.e., correct or other incorrect); subject receives a score of 0 for all intuitive responses (i.e., intuitive incorrect)
●	For example: Subject answered 6 items with 1 correct answer, 3 intuitively correct answers, and 2 other incorrect answers (Total Score= 3)
●	Scores range from 0 (subject gave all intuitive incorrect responses) to 6 (subject gave all non-intuitive responses, regardless of correctness)
*This scoring procedure only takes into account 2 different types of non-intuitive responses (i.e., correct or other incorrect), which is based on the premise that, in order to arrive to a correct answer, one must first recognize that the intuitive answer is indeed incorrect. Thus, this procedure derives a subject's ability to be sufficiently reflective and recognize that the intuitive answer is incorrect.
*Higher scores reflect subject's ability to cognitively reflect
              Correcta    -- Intuitiva
Pregunta 1 =       5000         10000
Pregunta 2 =        5             100
Pregunta 3 =       47             24  

*/

forvalues i = 1/3 {
	ren eTRC`i' crt`i'
	/* REGULAR*/
	gen crt_nc`i' = 0

	/* INTUITION */
	gen crt_i`i' = 0
	gen crt_in`i' = 0

}

	replace crt_nc1 = 1 if crt1 == 3 
	replace crt_nc2 = 1 if crt2 == 2 
	replace crt_nc3 = 1 if crt3 == 1
	gen crt_nq = (crt_nc1 + crt_nc2 +  crt_nc3)/3
	replace crt_i1 = 1 if crt1 == 1  
	replace crt_i2 = 1 if crt2 == 3  
	replace crt_i3 = 1 if crt3 == 3  
	replace crt_in1 = 1 if crt1 == 2  
	replace crt_in2 = 1 if crt2 == 1  
	replace crt_in3 = 1 if crt3 == 2  	
	gen crt_ic =  crt_i1 + crt_i2 + crt_i3
	gen crt_it =  crt_i1 + crt_i2 + crt_i3 +  crt_in1 +  crt_in2 +  crt_in3 
	gen crt_i = crt_ic / crt_it
	replace crt_i = 0 if crt_i == .
	/* REFLECTION*/
	gen crt_r = crt_ic

	forvalues i = 1/3 {
	/* REGULAR*/
	drop crt_nc`i'
	/* INTUITION */
	drop crt_i`i' 
	drop crt_in`i' 
}

*Create our control dummies	
gen econ_rel = 0
replace econ_rel = 1 if carrera == 1 | carrera == 2 | carrera == 6


preserve 

save data_p, replace 

//Create variables at trial level to the compliance analysis  (Time Response)
forvalues i = 1/3{
    split r`i'time_created_chars, parse(",") generate(begin`i')
    split r`i'time_answered_chars, parse(",") generate(end`i')
    split r`i'results_keys_pressed, parse(",") generate(result`i')
}



destring *, replace


reshape long begin1 begin2 begin3 end1 end2 end3 result1 result2 result3, i(code) j(round)

forvalues i = 1/3{
	cap gen time`i' = end`i' - begin`i' 
	replace time`i' = time`i' * -1 if time`i' <0

} 


forvalues i = 1/3{
ttest time`i', by(tratamiento) unequal
}


*\
save data_time, replace

restore


preserve 

//Create variables at trial level to the compliance analysis  (Performance Analysis)
forvalues i = 1/3{
    split r`i'time_created_chars, parse(",") generate(begin`i')
    split r`i'time_answered_chars, parse(",") generate(end`i')
    split r`i'results_keys_pressed, parse(",") generate(result`i')
}

destring *, replace


reshape long begin end result, i(code) j(round)
*Create a milliseconds measure
gen time = end - begin 
 replace time = time + time * 2 if time<0
ren round trial
gen round = 1
*Identifiying each round
replace round = 2 if trial > 20 & trial < 30
replace round = 3 if trial > 30 & trial < 40
replace round = 1 if trial > 100 
replace round = 2 if trial > 200
replace round = 3 if trial > 300
* The subjects have 60 trial in each round, we identify the trial
replace trial = trial - 10 if trial > 10 & trial < 20
replace trial = trial - 20 if trial > 20 & trial < 30
replace trial = trial - 30 if trial > 30  & trial < 40
replace trial = trial - 100 if trial > 100 & trial < 200
replace trial = trial - 200 if trial > 200 & trial < 300
replace trial = trial - 300 if trial > 300 


sort code round trial

gen correctas = 0
replace correctas = 1 if result == "CR" | result == "CN"


save data_time2, replace


restore



gen Azulesp = Azules/50


forvalues i = 1/3{
	ttest r`i'correctas, by (tratamiento) unequal

} 

ttest Azules, by (tratamiento)



global kw "E1A1 E1A2 E1A4 E1A3 E1A5 E1A6 E12A2 E12A3 E12A4 E12A5 E12A6 E13A3 E13A4 E13A5 E13A6 E14A4 E14A5 E14A6 E15A5 E15A6 E11A1 E11A2 E11A3 E11A4 E11A5 E11A6 E2A2 E2A3 E2A4 E2A5 E3A3 E2A6 E3A4 E3A5 E3A6 E4A4 E4A5 E4A6 E5A5 E5A6"


/* The data has a problem because the string exportation, we use the next loop to fix it*/

foreach k of global kw {
	cap gen `k'i= ""
	tostring `k', replace force
	cap replace `k'i = substr(`k',1,2)
	cap replace `k'i = "1" if `k'i == "10"
	cap replace `k'i= "3" if `k'i == "3."
	destring `k'i, replace force float
	cap drop `k'
	cap ren `k'i `k'

}         


la var E11A1 "Diced 1 Reported 1"
la var E11A2 "Diced 1 Reported 2"
la var E11A3 "Diced 1 Reported 3"
la var E11A4 "Diced 1 Reported 4"
la var E11A5 "Diced 1 Reported 5"
la var E11A6 "Diced 1 Reported 6"
la var E2A2 "Diced 2 Reported 2"
la var E2A3 "Diced 2 Reported 3"
la var E2A4 "Diced 2 Reported 4"
la var E2A5 "Diced 2 Reported 5"
la var E2A6 "Diced 2 Reported 6"
la var E3A3 "Diced 3 Reported 3"
la var E3A4 "Diced 3 Reported 4"
la var E3A5 "Diced 3 Reported 5"
la var E3A6 "Diced 3 Reported 6"
la var E4A4 "Diced 4 Reported 4"
la var E4A5 "Diced 4 Reported 5"
la var E4A6 "Diced 4 Reported 6"
la var E5A5 "Diced 5 Reported 5"
la var E5A6 "Diced 5 Reported 6"

la var E1A1 "Diced 1 Reported 1"
la var E1A2 "Diced 1 Reported 2"
la var E1A3 "Diced 1 Reported 3"
la var E1A4 "Diced 1 Reported 4"
la var E1A5 "Diced 1 Reported 5"
la var E1A6 "Diced 1 Reported 6"
la var E12A2 "Diced 2 Reported 2"
la var E12A3 "Diced 2 Reported 3"
la var E12A4 "Diced 2 Reported 4"
la var E12A5 "Diced 2 Reported 5"
la var E12A6 "Diced 2 Reported 6"
la var E13A3 "Diced 3 Reported 3"
la var E13A4 "Diced 3 Reported 4"
la var E13A5 "Diced 3 Reported 5"
la var E13A6 "Diced 3 Reported 6"
la var E14A4 "Diced 4 Reported 4"
la var E14A5 "Diced 4 Reported 5"
la var E14A6 "Diced 4 Reported 6"
la var E15A5 "Diced 5 Reported 5"
la var E15A6 "Diced 5 Reported 6"


label define rating 1 "Very socially acceptable" 3 "somehow socially acceptable" -3 "somehow socially unaceptable" -1 "very socially unacceptable"
label values E1A1 E1A2 E1A4 E1A3 E1A5 E1A6 E12A2 E12A3 E12A4 E12A5 E12A6 E13A3 E13A4 E13A5 E13A6 E14A4 E14A5 E14A6 E15A5 E15A6 E11A1 E11A2 E11A3 E11A4 E11A5 E11A6 E2A2 E2A3 E2A4 E2A5 E3A3 E2A6 E3A4 E3A5 E3A6 E4A4 E4A5 E4A6 E5A5 E5A6 rating

*create a easy way to identify the variables
ren (E11A1 E11A2 E11A3  E11A4 E11A5 E11A6 E2A2 E2A3 E2A4  E2A5  E2A6 E3A3 E3A4 E3A5 E3A6 E4A4 E4A5 E4A6 E5A5 E5A6) ( S1R1I S1R2I  S1R3I S1R4I S1R5I S1R6I  S2R2I S2R3I S2R4I S2R5I S2R6I S3R3I S3R4I S3R5I  S4R4I S4R6I S5R5I S5R6I S4R5I S3R6I)

ren  (E1A1 E1A2 E1A3 E1A4 E1A5 E1A6 E12A2 E12A3 E12A4 E12A5 E12A6 E13A3 E13A4 E13A5 E13A6 E14A4 E14A5 E14A6 E15A5 E15A6)  (S1R1D S1R2D S1R3D S1R4D S1R5D S1R6D S2R2D S2R3D  S2R4D S2R5D S2R6D S3R3D S3R4D S3R5D S3R6D S4R4D S4R5D S4R6D S5R5D S5R6D)




save data_p, replace
