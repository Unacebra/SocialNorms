clear all
clear matrix
set more off
 set maxvar 32000


/* The Tired and The Blind - Cognitive Load Over Norm-following behavior*/

/*  Sebastián Ramírez */
/* Advisors: Silvia L - Diego A*/
/* Created: 2021-03-21 */
/* Last modified: 2021-06-22 */



*============================================================================
* Date  : December 2021

*
* Do-file title: normas.do 
*
* This do-file generates the type classification for normatives and injuctives norms
*                
* Inputs: - data_p.dta
*       

* ====================================================================

clear all

if c(username) == "diego.aycinena" { // Diego Aycinena
	global datos  "$my_path\Raw" 
}

 if c(username) == "user" { // Sebastián Ramírez
	  cd    C:\Users\user\Dropbox\Tesis
	global my_path "C:\Users\user\Dropbox\Tesis"
	global datos  "$my_path\Raw" 
	global path_graphs "C:\Users\user\Dropbox\Tesis\graficas"
	global path_tables "C:\Users\user\Dropbox\Tesis\tablas"  //modify this line
}

//FILES FOR EACH TREATMENT


cd $datos

		   
/******************************************************* NORMAS PRESCRIBTIVAS *************************************************************/


use data_p
recode S1R1I-S5R6I (-3=-0.33)(3=0.33)
order S1R3D, before (S1R4D)
order S3R3I, after (S2R6I)
preserve



cap label define rating2 -3 "very socially unacceptable" -1 "somehow socially unaceptable"  1 "somehow socially acceptable"  3 "Very socially acceptable"  
cap label values S1R1I-S5R6I rating2
/* Modificar error creado por el destring de la base de datos */


local i=1
foreach n of varlist S1R1I-S5R6I {
	gen caso`i' = `n' 
	local i = `i'+1
}

*Media de Aceptación Social Para La Mentira
gen mean_lie = (S1R2I+ S1R3I+ S1R4I+ S1R5I+ S1R6I+ S2R3I + S2R4I + S2R5I+ S2R6I+ S3R4I+ S3R5I+ S3R6I+ S4R5I+ S4R6I+ S5R6I)/15
lab var mean_lie "Mean Social Acceptability of Dishonesty (Injuctives Norms)"


*Media de Aceptación Social Para La Verdad
gen mean_truth = (S1R1I+ S2R2I+ S3R3I+ S4R4I+ S5R5I)/5
lab var mean_truth "Mean Social Acceptability of Honesty (Injuctives Norms) "



*Media por situaciones *


// code is my id at individual level

sort code
gen observacion = _n
gen N = _N

save msa.dta, replace 

***RESHAPE DATASET
reshape long caso, i(code) j(c)




gen situacion = 4 // Situación 5
replace situacion = 3 if c <19 // Situación 4
replace situacion = 2 if c <16 //Situación 3
replace situacion = 1 if c <12 //Situación 2
replace situacion = 0 if c <7  //Situación 1
lab var situacion "Situation #"

*Honest situations
gen nolie = 0
replace nolie = 1 if (c == 1 | c == 7 | c == 12 | c == 16 | c == 19)
lab var nolie "Honest behavior in situation"

*Lie extension
gen extent = .
replace extent = 0 if c ==  1 | c ==  7 | c ==  12 | c ==  16 | c ==  19
replace extent = 1 if c ==  2 | c ==  8 | c ==  13 | c ==  17 | c ==  20
replace extent = 2 if c ==  3 | c ==  9 | c ==  14 | c ==  18
replace extent = 3 if c ==  4 | c == 10 | c ==  15 
replace extent = 4 if c ==  5 | c == 11 
replace extent = 5 if c ==  6

gen truth = 0
replace truth = 1 if extent==0

*Prepare individual level variables for classification types from regressions
gen sit_beta=.
gen sit_b_pval=.
gen beta_ext=.
gen ext_b_pval=.
gen truth_beta=.
gen truth_b_pval=.
gen truelie_b_pval=.
gen constant = .
gen const_pval=.



sum observacion
local N = r(max)
sort code c 


*statsby _b _se, by(code) saving(errorres): regress caso extent i.situacion truth

*Correr la regresión 


*Correr la regresión 
forvalues i = 1(1)213{
		display "Individual #`i' of `N'"
	
		reg caso situacion extent truth if observacion==`i'
		matrix b = e(b)'
		
		replace sit_beta = b[1,1] if observacion==`i'
		replace beta_ext = b[2,1] if observacion==`i'
		replace truth_beta = b[3,1] if observacion==`i'
		replace constant = b[4,1] if observacion==`i'
		
		test situacion==0
		replace sit_b_pval=r(p) if observacion==`i'
		
		test extent==0
		replace ext_b_pval=r(p) if observacion==`i'
		
		test truth==0
		replace truth_b_pval=r(p) if observacion==`i'
		
		test truth=_cons
		replace truelie_b_pval=r(p) if observacion==`i'
		
}

collapse sit_beta sit_b_pval beta_ext ext_b_pval truth_beta truth_b_pval truelie_b_pval constant, by(code)
compress
save type_file.dta, replace

use  msa.dta, clear
joinby code using type_file.dta, unmatched(both) 

assert _merge==3
drop _merge



* Clasificiación de cada Tipo *


/* Siguiendo el paper deberiamos utilizar el nivel de significancia del 0.1 */




gen beta_extent=beta_ext
replace beta_extent=0 if ext_b_pval > 0.10
replace beta_extent=0 if ext_b_pval ==. & (beta_ext>-0.0001 & beta_ext<0.0001) 

gen delta_truth = truth_beta
replace delta_truth = 0 if truth_b_pval > 0.10
replace delta_truth=truth_beta if truth_b_pval ==.  


*Tipo Consecuensialista 
generate consequentialist = 0
replace consequentialist = 1 if beta_extent<0 & delta_truth>=0 & mean_lie<0 
lab var conseq "Consequentialist norm perception type"


*Tipo Deontista
gen deontist = 0 
replace deontist = 1 if beta_extent==0 & delta_truth>=0 & mean_lie<0 
lab var deontist "Deontological norm perception type"



*Tipo Homo-economicus
generate homo_ec = 0
replace homo_ec = 1 if beta_extent>=0 & mean_lie>mean_truth
lab var homo_ec "Normative Egoist norm perception type"


gen other = 1 - consequentialist - homo_ec - deontist
label var other "other (non-classified) norm perception type"


label define types 1 "Consequentialist" 2 "Normative Egoist" 3 "Deontist" 4 "Other" 
gen type = 0
label values type types
replace type = 1 if consequentialist == 1
replace type = 2 if homo_ec == 1
replace type = 3 if deontist == 1
replace type = 4 if other == 1

//replace type = 5 if planos_totales == 1

tab type tratamiento

save data_i, replace

restore

/*
                          Treatment
						  
            type |         0          1 |     Total
-----------------+----------------------+----------
Consequentialist |        14          5 |        19 
Normative Egoist |         5         10 |        15 
        Deontist |        52         53 |       105 
           Other |        37         37 |        74 
-----------------+----------------------+----------
           Total |       108        105 |       213 


*/
  
/******************************************************* CREENCIAS NORMATIVAS *************************************************************/

preserve

local i=1
recode S1R1D-S5R6D (-3=-0.33)(3=0.33)

foreach n of varlist S1R1D-S5R6D {
	gen casod`i' = `n' 
	local i = `i'+1
}

*Media de Aceptación Social Para La Mentira
gen mean_lie = (S1R2D+ S1R3D+ S1R4D+ S1R5D+ S1R6D+ S2R3D+ S2R4D+ S2R5D+ S2R6D+ S3R4D+ S3R5D+ S3R6D+ S4R5D+ S4R6D+ S5R6D)/15
lab var mean_lie "Mean Social Acceptability of Dishonesty (Descriptive Norms)"

*Media de Aceptación Social Para La Verdad
gen mean_truth = (S1R1D+ S2R2D+ S3R3D+ S4R4D+ S5R5D)/5
lab var mean_truth "Mean Social Acceptability of Honesty (Descriptive Norms) "


sort code
gen observacion = _n
gen N = _N

save msa.dta, replace 

***RESHAPE DATASET
reshape long casod, i(code) j(c)



gen situacion = 4   //Situación 5
replace situacion = 3 if c <19 // Situación 4
replace situacion = 2 if c <16 //Situación 3
replace situacion = 1 if c <12 //Situación 2
replace situacion = 0 if c <7  //Situación 1
lab var situacion "Situation #"

*Situaciones donde solo se pregunta por la situación honesta.
gen nolie = 0
replace nolie = 1 if (c == 1 | c == 7 | c == 12 | c == 16 | c == 19)
lab var nolie "Honest behavior in situation"

*El grado de extensión de mentir
gen extent = .
replace extent = 0 if c ==  1 | c ==  7 | c ==  12 | c ==  16 | c ==  19
replace extent = 1 if c ==  2 | c ==  8 | c ==  13 | c ==  17 | c ==  20
replace extent = 2 if c ==  3 | c ==  9 | c ==  14 | c ==  18
replace extent = 3 if c ==  4 | c == 10 | c ==  15 
replace extent = 4 if c ==  5 | c == 11 
replace extent = 5 if c ==  6

gen truth = 0
replace truth = 1 if extent==0

*Prepare individual level variables for classification types from regressions
gen sit_beta=.
gen sit_b_pval=.
gen beta_ext=.
gen ext_b_pval=.
gen truth_beta=.
gen truth_b_pval=.
gen truelie_b_pval=.
gen constant = .
gen const_pval=.



sum observacion
local N = r(max)
sort code c



*Correr la regresión 
forvalues i = 1(1)213{
		display "Individual #`i' of `N'"
	
		reg casod situacion extent truth if observacion==`i'
		matrix b = e(b)'
		
		replace sit_beta = b[1,1] if observacion==`i'
		replace beta_ext = b[2,1] if observacion==`i'
		replace truth_beta = b[3,1] if observacion==`i'
		replace constant = b[4,1] if observacion==`i'
		
		test situacion==0
		replace sit_b_pval=r(p) if observacion==`i'
		
		test extent==0
		replace ext_b_pval=r(p) if observacion==`i'
		
		test truth==0
		replace truth_b_pval=r(p) if observacion==`i'
		
		test truth=_cons
		replace truelie_b_pval=r(p) if observacion==`i'
		
}

collapse sit_beta sit_b_pval beta_ext ext_b_pval truth_beta truth_b_pval truelie_b_pval constant, by(code)
compress
save type_filed.dta, replace

use  msa.dta, clear
joinby code using type_filed.dta, unmatched(both) 

assert _merge==3
drop _merge



* Clasificiación de cada Tipo *


/* Siguiendo el paper deberiamos utilizar el nivel de significancia del 0.1 */




gen beta_extent=beta_ext
replace beta_extent=0 if ext_b_pval > 0.10
replace beta_extent=0 if ext_b_pval ==. & (beta_ext>-0.0001 & beta_ext<0.0001) 

gen delta_truth = truth_beta
replace delta_truth = 0 if truth_b_pval > 0.10
replace delta_truth=truth_beta if truth_b_pval ==.  


*Tipo Consecuensialista 
generate consequentialist = 0
replace consequentialist = 1 if beta_extent<0 & delta_truth>=0 & mean_lie<0 
lab var conseq "Consequentialist norm perception type"


*Tipo Deontista
gen deontist = 0 
replace deontist = 1 if beta_extent==0 & delta_truth>=0 & mean_lie<0 
lab var deontist "Deontological norm perception type"



*Tipo Homo-economicus
generate homo_ec = 0
replace homo_ec = 1 if beta_extent>=0 & mean_lie>mean_truth
lab var homo_ec "Normative Egoist norm perception type"



gen other = 1 - consequentialist - homo_ec - deontist
label var other "other (non-classified) norm perception type"

label define types 1 "Consequentialist" 2 "Normative Egoist" 3 "Deontist" 4 "Other"
gen type = 0
label values type types
replace type = 1 if consequentialist == 1
replace type = 2 if homo_ec == 1
replace type = 3 if deontist == 1
replace type = 4 if other == 1

tab type tratamiento

save datad, replace


x
