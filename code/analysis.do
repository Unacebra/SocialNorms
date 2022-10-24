


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



*Generate path to access to all the .xls of each session in each treatment


//cd C:\Users\user\Desktop\DATA-PvsV


  cd    C:\Users\user\Dropbox\Tesis
global my_path "C:\Users\user\Dropbox\Tesis"
  
global datos  "$my_path\Raw" 
global path_graphs "C:\Users\user\Dropbox\Tesis\graficas"
global path_tables "C:\Users\user\Dropbox\Tesis\tablas"

//FILES FOR EACH TREATMENT


cd $datos

*Regression for the normative expectations
use data_i
 
replace orden = orden/10 
*I assigned labels to my control variables
label var genero "Is Female"
label var age "Age"
cap gen econ_rel = 0
cap replace econ_rel = 1 if carrera == 1 | carrera == 2 | carrera == 6
cap label var econ_rel "Econ Related"
cap label var crt_nq "CRT-Cognitive Score"
cap label var crt_i "CRT-Intuitive Score"
cap label var orden "Order Effect"
cap label var effort "Overal Effort"
cap label var ment "Mental Effort"
gen aver_correctas = (r1correctas + r2correctas + r3correctas)/3
cap label var b1basketBlueLeft "Buckets Order"
*replace tratamiento = 0 if aver_correctas < 15
*drop if econ_rel == 1
 
gen r1correctasp = r1correctas/60
gen r2correctasp = r2correctas/60
gen r3correctasp = r3correctas/60

*iebaltab genero age econ_rel   crt_nq crt_i effort ment, grpvar(tratamiento) save("$path_tables\descripitives.xlsx") 

*Some ttest to evaluate the difference between treatments
ttest r1correctasp, by (tratamiento) unequal
ttest r2correctasp, by (tratamiento) unequal
ttest r3correctasp, by (tratamiento) unequal

*Setting up new variables for analysis
gen tratamiento2 = tratamiento
replace tratamiento2 = 1 if tratamiento == 0 & ment >= 90

gen outlierst = 0
replace outlierst = 1 if tratamiento == 0 & ment >= 90

gen total_compliance = 0
replace total_compliance = 1 if Azules == 50


gen zero_compliance = 0
replace zero_compliance = 1 if Azules == 0

gen extreme_value = 0
replace extreme_value = 1 if Amarillas == 50
replace extreme_value = 1 if Azules == 50

* Treatment vs Rules Compliance (Balls Distribution) Reg*
reg Azules tratamiento, robust
outreg2 using "$path_tables/ProTable_total.xls", excel tex(land) replace ctitle("Rule-violation") label addtext(Sociodemograpic Controls,  ) addnote(Dep Var: Number of Balls on Blue Bucket (Rule Following))  drop(Constant)

reg Azules  tratamiento genero econ_rel crt_nq crt_i b1basketBlueLeft , robust
outreg2 using "$path_tables/ProTable_total.xls", excel tex(land) append ctitle("Rule-violation") label addtext(Sociodemograpic Controls, X  ) addnote(Dep Var: Number of Balls on Blue Bucket (Rule Following))  drop(Constant)

probit total_compliance  tratamiento, robust
outreg2 using "$path_tables/ProTable_total.xls", excel tex(land) append ctitle("Complete Rule-following") label addtext(Sociodemograpic Controls,  )  addstat(Pseudo R2, e(r2_p)) addnote()  drop(Constant)

* Treatment vs Rules Compliance Probit (Balls Distribution)*
probit total_compliance tratamiento genero econ_rel crt_nq crt_i  b1basketBlueLeft , robust
outreg2 using "$path_tables/ProTable_total.xls", excel tex(land) append ctitle("Complete Rule-following") label addtext(Sociodemograpic Controls, X )  addstat(Pseudo R2, e(r2_p)) addnote()  drop(Constant)

probit zero_compliance tratamiento, robust
outreg2 using "$path_tables/ProTable_total.xls", excel tex(land) append ctitle("Complete Rule-violation") label addtext(Sociodemograpic Controls,  )  addstat(Pseudo R2, e(r2_p)) addnote()   drop(Constant)


probit zero_compliance tratamiento genero econ_rel crt_nq crt_i b1basketBlueLeft , robust
outreg2 using "$path_tables/ProTable_total.xls", excel tex(land) append ctitle("Complete Rule-violation") label addtext(Sociodemograpic Controls, X )  addstat(Pseudo R2, e(r2_p)) addnote()   drop(Constant)
* Treatment vs Rules Compliance Tobit (Balls Distribution)*
tobit Azules tratamiento, ll(0) ul(50)
outreg2 using "$path_tables/TobTable_compliance.xls", excel tex(land) replace ctitle("Rule-violation") label addtext(Sociodemograpic Controls,  ) addnote(Dep Var: Number of Balls on Blue Bucket (Rule Following))  drop(Constant)

tobit Azules  tratamiento genero econ_rel crt_nq  b1basketBlueLeft, ll(0) ul(50)
outreg2 using "$path_tables/TobTable_compliance.xls", excel tex(land) append ctitle("Rule-violation") label addtext(Sociodemograpic Controls, X  ) addnote(Dep Var: Number of Balls on Blue Bucket (Rule Following))  drop(Constant)




reg total_compliance  tratamiento, robust
outreg2 using "$path_tables/RegTable_total.xls", excel tex(land) replace ctitle("Complete Rule-following") label addtext(Sociodemograpic Controls,  )    addnote(Dep Var: Dummy 1 if Total Compliance (50 Balls in Blue Bucket)) drop(Constant)


reg total_compliance tratamiento genero econ_rel crt_nq  b1basketBlueLeft , robust
outreg2 using "$path_tables/RegTable_total.xls", excel tex(land) append ctitle("Complete Rule-following") label addtext(Sociodemograpic Controls, X ) addnote(Dep Var: Dummy 1 if Total Compliance (50 Balls in Blue Bucket))    drop(Constant)

reg zero_compliance  tratamiento, robust
outreg2 using "$path_tables/RegTable_total.xls", excel tex(land) append ctitle("Complete Rule-violation") label addtext(Sociodemograpic Controls,  )  addnote(Dep Var: Dummy 1 if Total Compliance (50 Balls in Yellow Bucket))  drop(Constant)


reg zero_compliance tratamiento genero econ_rel crt_nq  b1basketBlueLeft, robust
outreg2 using "$path_tables/RegTable_total.xls", excel tex(land) append ctitle("Complete Rule-violation") label addtext(Sociodemograpic Controls, X )   addnote(Dep Var: Dummy 1 if Total Compliance (50 Balls in Yellow Bucket))   drop(Constant)

* Treatment vs Extreme Values Reg (Balls Distribution)*



reg extreme_value tratamiento, robust
outreg2 using "$path_tables/RegExtreme.xls", excel tex(land) replace ctitle("Extreme Values") label addtext(Sociodemograpic Controls,  ) addnote(Dep Var: Number of Balls on Blue Bucket (Rule Following))  drop(Constant)

reg extreme_value  tratamiento genero econ_rel crt_nq  b1basketBlueLeft , robust
outreg2 using "$path_tables/RegExtreme.xls", excel tex(land) append ctitle("Extreme Values") label addtext(Sociodemograpic Controls, X  ) addnote(Dep Var: Number of Balls on Blue Bucket (Rule Following))  drop(Constant)

logit extreme_value tratamiento, robust
outreg2 using "$path_tables/LogExtreme.xls", excel tex(land) replace ctitle("Extreme Values") label addtext(Sociodemograpic Controls,  ) addnote(Dep Var: Number of Balls on Blue Bucket (Rule Following))  drop(Constant)

logit extreme_value  tratamiento genero econ_rel crt_nq  b1basketBlueLeft , robust
outreg2 using "$path_tables/LogExtreme.xls", excel tex(land) append ctitle("Extreme Values") label addtext(Sociodemograpic Controls, X  ) addnote(Dep Var: Number of Balls on Blue Bucket (Rule Following))  drop(Constant)

probit extreme_value tratamiento, robust 
outreg2 using "$path_tables/ProExtreme.xls", excel tex(land) replace ctitle("Extreme Values") label addtext(Sociodemograpic Controls,  ) addstat(Pseudo R2, e(r2_p)) addnote(Dep Var: Number of Balls on Blue Bucket (Rule Following))  drop(Constant)

probit extreme_value  tratamiento genero econ_rel crt_nq  b1basketBlueLeft , robust 
outreg2 using "$path_tables/ProExtreme.xls", excel tex(land) append ctitle("Extreme Values") label addtext(Sociodemograpic Controls, X  ) addstat(Pseudo R2, e(r2_p)) addnote(Dep Var: Number of Balls on Blue Bucket (Rule Following))  drop(Constant)


/*Alternative Hypothesis */

reg Azules tratamiento2, robust
outreg2 using "$path_tables/Reg2Table_compliance.xls", excel tex(land) replace ctitle("Rule-violation") label addtext(Sociodemograpic Controls,  ) addnote(Dep Var: Number of Balls on Blue Bucket (Rule Following))  drop(Constant)

reg Azules  tratamiento2 genero econ_rel crt_nq  b1basketBlueLeft , robust
outreg2 using "$path_tables/Reg2Table_compliance.xls", excel tex(land) append ctitle("Rule-violation") label addtext(Sociodemograpic Controls, X  ) addnote(Dep Var: Number of Balls on Blue Bucket (Rule Following))  drop(Constant)





* Treatment vs Self Reports Reg (NASA-TLX)*
replace effort = effort/200
replace ment = ment/200
replace per = per/200
replace phys= phys/200
replace temp = temp/200
replace frust = frust/200


reg effort tratamiento, robust
outreg2 using "$path_tables/NASA_tratamiento.xls", excel tex(land) replace ctitle("Overall Effort") label addtext(Sociodemograpic Controls, ) addnote(Dep Var: )  drop(Constant)

reg ment tratamiento, robust
outreg2 using "$path_tables/NASA_tratamiento.xls", excel tex(land) append ctitle("Mental Effort") label addtext(Sociodemograpic Controls,) addnote(Dep Var: NASA TLX (Rule Following))  drop(Constant)


reg per tratamiento, robust
outreg2 using "$path_tables/NASA_tratamiento.xls", excel tex(land) append ctitle("Performance") label addtext(Sociodemograpic Controls, ) addnote()  drop(Constant)

reg phys tratamiento, robust
outreg2 using "$path_tables/NASA_tratamiento.xls", excel tex(land) append ctitle("Physical Effort") label addtext(Sociodemograpic Controls, ) addnote(Dep Var: Number of Balls on Blue Bucket (Rule Following))  drop(Constant)

reg temp tratamiento, robust
outreg2 using "$path_tables/NASA_tratamiento.xls", excel tex(land) append ctitle("Temporal Effort") label addtext(Sociodemograpic Controls,  ) addnote()  drop(Constant)

reg frust tratamiento, robust
outreg2 using "$path_tables/NASA_tratamiento.xls", excel tex(land) append ctitle("Frustation") label addtext(Sociodemograpic Controls,  ) addnote()  drop(Constant)



*Analysis for the Norms Compliance using the Self-Report as a alternative measure of cognitive load


reg Azules effort ment, robust 
outreg2 using "$path_tables/TNASAa_compliance.xls", excel tex(land) replace ctitle("Complete Rule-following") label addtext(Sociodemograpic Controls,  ) addnote(Dep Var: Number of Balls on Blue Bucket (Rule Following))  

reg Azules effort ment genero econ_rel crt_nq  b1basketBlueLeft , robust
outreg2 using "$path_tables/TNASAa_compliance.xls", excel tex(land) append ctitle("Complete Rule-following") label addtext(Sociodemograpic Controls, X  ) addnote(Dep Var: Number of Balls on Blue Bucket (Rule Following)) 


probit  total_compliance effort ment, robust 
outreg2 using "$path_tables/TNASA_compliance.xls", excel tex(land) replace ctitle("Complete Rule-following") label addtext(Sociodemograpic Controls,) addstat(Pseudo R2, e(r2_p)) addnote(Dep Var: Number of Balls on Blue Bucket (Rule Following))  

probit  total_compliance effort ment genero econ_rel crt_nq  b1basketBlueLeft , robust 
outreg2 using "$path_tables/TNASA_compliance.xls", excel tex(land) append ctitle("Complete Rule-following") label addtext(Sociodemograpic Controls, X  ) addstat(Pseudo R2, e(r2_p)) addnote(Dep Var: Number of Balls on Blue Bucket (Rule Following))  


probit  zero_compliance effort ment, robust 
outreg2 using "$path_tables/TNASA_compliance.xls", excel tex(land) append ctitle("Complete Rule-violation") label addtext(Sociodemograpic Controls,  ) addstat(Pseudo R2, e(r2_p)) addnote(Dep Var: Number of Balls on Blue Bucket (Rule Following))  

probit  zero_compliance effort  ment  genero econ_rel crt_nq  b1basketBlueLeft , robust 
outreg2 using "$path_tables/TNASA_compliance.xls", excel tex(land) append ctitle("Complete Rule-violation") label addtext(Sociodemograpic Controls, X  ) addstat(Pseudo R2, e(r2_p)) addnote(Dep Var: Number of Balls on Blue Bucket (Rule Following)) 

probit extreme_value effort ment, robust 
outreg2 using "$path_tables/TNASA_compliance.xls", excel tex(land) append ctitle("Extreme Behavior") label addtext(Sociodemograpic Controls,  ) addstat(Pseudo R2, e(r2_p)) addnote(Dep Var: Number of Balls on Blue Bucket (Rule Following))  

probit  extreme_value effort  ment   genero econ_rel crt_nq  b1basketBlueLeft ,
outreg2 using "$path_tables/TNASA_compliance.xls", excel tex(land) append ctitle("Extreme Behavior") label addtext(Sociodemograpic Controls, X  ) addstat(Pseudo R2, e(r2_p)) addnote(Dep Var: Number of Balls on Blue Bucket (Rule Following))  



* Treatment vs Algorithm of clasiffication (Normative Expectations)*
gen pro_consequensialist = 0
replace pro_consequensialist = 1 if type == 1

gen pro_normative = 0
replace pro_normative = 1 if type == 2

gen pro_deontist = 0
replace pro_deontist = 1 if type == 3



gen pro_other = 0
replace pro_other = 1 if type == 4


reg pro_consequensialist tratamiento, robust
outreg2 using "$path_tables/Table_types.xls", excel tex(land) replace ctitle("Consequentialist") label addtext(Sociodemograpic Controls, X ) addnote(Dep Var: Effect on norm perception type)  drop(Constant)

reg pro_consequensialist tratamiento mean_lie, robust
outreg2 using "$path_tables/Table_types.xls", excel tex(land) append ctitle("Consequentialist") label addtext(Sociodemograpic Controls, X ) addnote(Dep Var: Effect on norm perception type)  drop(Constant)

reg pro_consequensialist tratamiento mean_lie genero econ_rel crt_nq  orden, robust
outreg2 using "$path_tables/Table_types.xls", excel tex(land) append ctitle("Consequentialist") label addtext(Sociodemograpic Controls, ,X  ) addnote(Dep Var: Effect on norm perception type)  drop(Constant)




reg pro_deontist tratamiento, robust
outreg2 using "$path_tables/Table_types.xls", excel tex(land) append ctitle("Deontist") label addtext(Sociodemograpic Controls,  ) addnote(Dep Var: Effect on norm perception type)  drop(Constant)


reg pro_deontist tratamiento mean_lie, robust
outreg2 using "$path_tables/Table_types.xls", excel tex(land) append ctitle("Deontist") label addtext(Sociodemograpic Controls,  ) addnote(Dep Var: Effect on norm perception type)  drop(Constant)


reg pro_deontist tratamiento mean_lie genero econ_rel crt_nq  orden, robust
outreg2 using "$path_tables/Table_types.xls", excel tex(land) append ctitle("Deontist") label addtext(Sociodemograpic Controls, X ) addnote(Dep Var: Effect on norm perception type)  drop(Constant)

reg pro_other tratamiento, robust
outreg2 using "$path_tables/Table_types.xls", excel tex(land) append ctitle("Other") label addtext(Sociodemograpic Controls,  ) addnote(Dep Var: Effect on norm perception type)  drop(Constant)

reg pro_other tratamiento mean_lie , robust
outreg2 using "$path_tables/Table_types.xls", excel tex(land) append ctitle("Other") label addtext(Sociodemograpic Controls, X  ) addnote(Effect on norm perception type)  drop(Constant)


reg pro_other tratamiento mean_lie  genero econ_rel crt_nq  orden, robust
outreg2 using "$path_tables/Table_types.xls", excel tex(land) append ctitle("Other") label addtext(Sociodemograpic Controls, X) addnote(Dep Var: )  drop(Constant)


//// Appendix
reg pro_consequensialist tratamiento, robust
outreg2 using "$path_tables/Table_types_A.xls", excel tex(land) replace ctitle("Consecuensialist") label addtext(Sociodemograpic Controls, X ) addnote(Dep Var: Effect on norm perception type)  drop(Constant)


reg pro_consequensialist tratamiento mean_lie genero econ_rel crt_nq  orden, robust
outreg2 using "$path_tables/Table_types_A.xls", excel tex(land) append ctitle("Consecuensialist") label addtext(Sociodemograpic Controls, X,  ) addnote(Dep Var: Effect on norm perception type)  drop(Constant)

reg pro_normative tratamiento, robust
outreg2 using "$path_tables/Table_types_A.xls", excel tex(land) append ctitle("Normative Egoist") label addtext(Sociodemograpic Controls, X  ) addnote(Dep Var: Effect on norm perception type)  drop(Constant)

reg pro_normative tratamiento mean_lie genero econ_rel crt_nq  orden, robust
outreg2 using "$path_tables/Table_types_A.xls", excel tex(land) append ctitle("Normative Egoist") label addtext(Sociodemograpic Controls,   ) addnote(Dep Var: Effect on norm perception type)  drop(Constant)



reg pro_deontist tratamiento, robust
outreg2 using "$path_tables/Table_types_A.xls", excel tex(land) append ctitle("Deontist") label addtext(Sociodemograpic Controls,  ) addnote(Dep Var: Effect on norm perception type)  drop(Constant)


reg pro_deontist tratamiento genero econ_rel crt_nq  orden, robust
outreg2 using "$path_tables/Table_types_A.xls", excel tex(land) append ctitle("Deontist") label addtext(Sociodemograpic Controls, X ) addnote(Dep Var: Effect on norm perception type)  drop(Constant)

reg pro_other tratamiento, robust
outreg2 using "$path_tables/Table_types_A.xls", excel tex(land) append ctitle("Other") label addtext(Sociodemograpic Controls, X  ) addnote(Effect on norm perception type)  drop(Constant)


reg pro_other tratamiento genero econ_rel crt_nq  orden, robust
outreg2 using "$path_tables/Table_types_A.xls", excel tex(land) append ctitle("Other") label addtext(Sociodemograpic Controls, X) addnote(Dep Var: )  drop(Constant)



/// Robustness Checks

reg  pro_consequensialist effort ment, robust 
outreg2 using "$path_tables/NASA_normas.xls", excel tex(land) replace ctitle("Consecuensialist") label addtext(Sociodemograpic Controls, )  addnote(Dep Var: Number of Balls on Blue Bucket (Rule Following))  

reg  pro_consequensialist effort ment mean_lie, robust 
outreg2 using "$path_tables/NASA_normas.xls", excel tex(land) append ctitle("Consecuensialist") label addtext(Sociodemograpic Controls,  ) addnote(Dep Var: Number of Balls on Blue Bucket (Rule Following))  

reg  pro_consequensialist effort  ment mean_lie genero econ_rel crt_nq  orden , robust 
outreg2 using "$path_tables/NASA_normas.xls", excel tex(land) append ctitle("Consecuensialist") label addtext(Sociodemograpic Controls, X  ) addnote(Dep Var: Number of Balls on Blue Bucket (Rule Following)) 


reg  pro_deontist effort ment, robust 
outreg2 using "$path_tables/NASA_normas.xls", excel tex(land) append ctitle("Deontist") label addtext(Sociodemograpic Controls,)  addnote(Dep Var: Number of Balls on Blue Bucket (Rule Following))  

reg  pro_deontist effort ment mean_lie, robust 
outreg2 using "$path_tables/NASA_normas.xls", excel tex(land) append ctitle("Deontist") label addtext(Sociodemograpic Controls,) addnote(Dep Var: Number of Balls on Blue Bucket (Rule Following))  



reg  pro_deontist effort ment mean_lie genero econ_rel crt_nq  orden , robust 
outreg2 using "$path_tables/NASA_normas.xls", excel tex(land) append ctitle("Deontist") label addtext(Sociodemograpic Controls, X  ) addnote(Dep Var: Number of Balls on Blue Bucket (Rule Following))  

reg  pro_other effort ment, robust 
outreg2 using "$path_tables/NASA_normas.xls", excel tex(land) append ctitle("Other") label addtext(Sociodemograpic Controls,)  addnote(Dep Var: Number of Balls on Blue Bucket (Rule Following))  

reg  pro_other effort ment mean_lie, robust 
outreg2 using "$path_tables/NASA_normas.xls", excel tex(land) append ctitle("Other") label addtext(Sociodemograpic Controls,) addnote(Dep Var: Number of Balls on Blue Bucket (Rule Following)) 

reg  pro_other effort ment mean_lie genero econ_rel crt_nq  orden , robust 
outreg2 using "$path_tables/NASA_normas.xls", excel tex(land) append ctitle("Other") label addtext(Sociodemograpic Controls, X  ) addnote(Dep Var: Number of Balls on Blue Bucket (Rule Following))  

 
/*

recode S1R1I-S5R6I (-3=1)(-1 = 0)(3=2)(1=3)
recode S1R1D-S5R6D (-3=1)(-1 = 0)(3=2)(1=3)

cap label define rating2 0 "very socially unacceptable" 1 "somehow socially unaceptable"  2 "somehow socially acceptable"  3 "Very socially acceptable"  
cap label values S1R1I-S5R6I rating2

gsem (S1R1I-S1R6I <-), mlogit lclass(C 4)  startvalues(randomid, draws(70) seed(12345)) iterate(90)
estat ic          
estat lcgof      
estat lcmean      
estat lcprob 



gsem (S1R1D-S1R6I <-) if tratamiento==0, logit lclass(C 4)  startvalues(randomid, draws(80) seed(12345)) iterate(100)

*/

* Treatment vs Time Response (Milliseconds)*
gen sub_treat = 3
replace sub_treat = 2 if ment < 140
replace sub_treat = 1 if ment < 70

use data_time2, clear

label var genero "Is Female"
label var age "Age"
label var econ_rel "Econ Related"
label var crt_nq "CRT- Normal Score"


gen temporal = .
replace temporal = trial if round == 1
replace temporal = trial + 60 if round == 2
replace temporal = trial + 120 if round == 3

xtset temporal

xtreg time tratamiento tratamiento##round ,  robust re
outreg2 using "$path_tables/Time.xls", excel tex(land) replace ctitle("Time") label addtext(Sociodemograpic Controls,  ) addnote(Dep Var: Average Time Respone on Milliseconds)  drop(Constant)
xtreg time tratamiento tratamiento##round genero econ_rel crt_nq , robust re

outreg2 using "$path_tables/Time.xls", excel tex(land) append ctitle("Time ") label addtext(Sociodemograpic Controls, X  ) addnote(Dep Var: Average Time Respone on Milliseconds) adds(R-squared, e(r2_o))  drop(Constant)

* Treatment vs Performance (Milliseconds)*

xtreg correctas tratamiento##round ,robust fe
outreg2 using "$path_tables/Correctas.xls", excel tex(land) append ctitle("Correct") label addtext(Sociodemograpic Controls,  ) addnote(Dep Var: Correct Responses)  drop(Constant) 
xtreg correctas tratamiento##round genero econ_rel crt_nq , robust re
outreg2 using "$path_tables/Correctas.xls", excel tex(land) append ctitle("Correct") label addtext(Sociodemograpic Controls, X  ) addnote(Dep Var: Correct Responses) adds( R-squared, e(r2_o))  drop(Constant)


*Analysis for the Personal Normative Norms

use datad, clear
replace effort = effort/200
replace ment = ment/200
replace per = per/200
replace phys= phys/200
replace temp = temp/200
replace frust = frust/200


label var genero "Is Female"
label var age "Age"
cap gen econ_rel = 0
cap replace econ_rel = 1 if carrera == 1 | carrera == 2 | carrera == 6
cap label var econ_rel "Econ Related"
cap label var crt_nq "CRT-Cognitive Score"
replace orden = orden/10 
cap label var orden "Order Effect"
cap label var effort "Overal Effort"
cap label var ment "Mental Effort"

gen pro_consequensialist = 0
replace pro_consequensialist = 1 if type == 1

gen pro_normative = 0
replace pro_normative = 1 if type == 2

gen pro_deontist = 0
replace pro_deontist = 1 if type == 3

gen pro_other = 0
replace pro_other = 1 if type == 4




reg pro_consequensialist tratamiento, robust
outreg2 using "$path_tables/Table_types_d.xls", excel tex(land) replace ctitle("Consecuensialist") label addtext(Sociodemograpic Controls, X ) addnote(Dep Var: Effect on norm perception type)  drop(Constant)

reg pro_consequensialist tratamiento mean_lie, robust
outreg2 using "$path_tables/Table_types_d.xls", excel tex(land) append ctitle("Consecuensialist") label addtext(Sociodemograpic Controls, X ) addnote(Dep Var: Effect on norm perception type)  drop(Constant)

reg pro_consequensialist tratamiento mean_lie genero econ_rel crt_nq  orden, robust
outreg2 using "$path_tables/Table_types_d.xls", excel tex(land) append ctitle("Consecuensialist") label addtext(Sociodemograpic Controls, ,X  ) addnote(Dep Var: Effect on norm perception type)  drop(Constant)


reg pro_deontist tratamiento, robust
outreg2 using "$path_tables/Table_types_d.xls", excel tex(land) append ctitle("Deontist") label addtext(Sociodemograpic Controls,  ) addnote(Dep Var: Effect on norm perception type)  drop(Constant)

reg pro_deontist tratamiento mean_lie, robust
outreg2 using "$path_tables/Table_types_d.xls", excel tex(land) append ctitle("Deontist") label addtext(Sociodemograpic Controls,  ) addnote(Dep Var: Effect on norm perception type)  drop(Constant)


reg pro_deontist tratamiento mean_lie genero econ_rel crt_nq  orden, robust
outreg2 using "$path_tables/Table_types_d.xls", excel tex(land) append ctitle("Deontist") label addtext(Sociodemograpic Controls, X ) addnote(Dep Var: Effect on norm perception type)  drop(Constant)


reg pro_other tratamiento, robust
outreg2 using "$path_tables/Table_types_d.xls", excel tex(land) append ctitle("Deontist") label addtext(Sociodemograpic Controls,  ) addnote(Dep Var: Effect on norm perception type)  drop(Constant)

reg pro_other tratamiento mean_lie, robust
outreg2 using "$path_tables/Table_types_d.xls", excel tex(land) append ctitle("Deontist") label addtext(Sociodemograpic Controls,  ) addnote(Dep Var: Effect on norm perception type)  drop(Constant)


reg pro_other tratamiento mean_lie genero econ_rel crt_nq  orden, robust
outreg2 using "$path_tables/Table_types_d.xls", excel tex(land) append ctitle("Deontist") label addtext(Sociodemograpic Controls, X ) addnote(Dep Var: Effect on norm perception type)  drop(Constant)



reg  pro_consequensialist effort ment, robust 
outreg2 using "$path_tables/NASA_normasA.xls", excel tex(land) replace ctitle("Consecuensialist") label addtext(Sociodemograpic Controls,  ) addnote(Dep Var: Effect on norm perception type)  

reg  pro_consequensialist effort ment mean_lie, robust 
outreg2 using "$path_tables/NASA_normasA.xls", excel tex(land) append ctitle("Consecuensialist") label addtext(Sociodemograpic Controls,  ) addnote(Dep Var: Effect on norm perception type)  

reg  pro_consequensialist effort  ment mean_lie genero econ_rel crt_nq orden, robust 
outreg2 using "$path_tables/NASA_normasA.xls", excel tex(land) append ctitle("Consecuensialist") label addtext(Sociodemograpic Controls, X  ) addnote(Dep Var: Effect on norm perception type) 


reg  pro_deontist effort ment, robust 
outreg2 using "$path_tables/NASA_normasA.xls", excel tex(land) append ctitle("Deontist") label addtext(Sociodemograpic Controls,)  addnote(Dep Var: Effect on norm perception type)  


reg  pro_deontist effort ment mean_lie, robust 
outreg2 using "$path_tables/NASA_normasA.xls", excel tex(land) append ctitle("Deontist") label addtext(Sociodemograpic Controls,) addnote(Dep Var: Effect on norm perception type)  

reg  pro_deontist effort ment mean_lie genero econ_rel crt_nq orden , robust 
outreg2 using "$path_tables/NASA_normasA.xls", excel tex(land) append ctitle("Deontist") label addtext(Sociodemograpic Controls, X  )  addnote(Dep Var: Effect on norm perception type)  






/////////// Appendix
reg pro_consequensialist tratamiento, robust
outreg2 using "$path_tables/Table_types_dA.xls", excel tex(land) replace ctitle("Consecuensialist") label addtext(Sociodemograpic Controls, X ) addnote(Dep Var: Effect on norm perception type)  drop(Constant)

reg pro_consequensialist tratamiento genero econ_rel crt_nq  orden, robust
outreg2 using "$path_tables/Table_types_dA.xls", excel tex(land) append ctitle("Consecuensialist") label addtext(Sociodemograpic Controls, X,  ) addnote(Dep Var: Effect on norm perception type)  drop(Constant)

reg pro_normative tratamiento, robust
outreg2 using "$path_tables/Table_types_dA.xls", excel tex(land) append ctitle("Normative Egoist") label addtext(Sociodemograpic Controls, X  ) addnote(Dep Var: Effect on norm perception type)  drop(Constant)


reg pro_normative tratamiento genero econ_rel crt_nq  orden, robust
outreg2 using "$path_tables/Table_types_dA.xls", excel tex(land) append ctitle("Normative Egoist") label addtext(Sociodemograpic Controls,   ) addnote(Dep Var: Effect on norm perception type)  drop(Constant)



reg pro_deontist tratamiento, robust
outreg2 using "$path_tables/Table_types_dA.xls", excel tex(land) append ctitle("Deontist") label addtext(Sociodemograpic Controls,  ) addnote(Dep Var: Effect on norm perception type)  drop(Constant)


reg pro_deontist tratamiento genero econ_rel crt_nq  orden, robust
outreg2 using "$path_tables/Table_types_dA.xls", excel tex(land) append ctitle("Deontist") label addtext(Sociodemograpic Controls, X ) addnote(Dep Var: Effect on norm perception type)  drop(Constant)

reg pro_other tratamiento, robust
outreg2 using "$path_tables/Table_types_dA.xls", excel tex(land) append ctitle("Other") label addtext(Sociodemograpic Controls, X  ) addnote(Effect on norm perception type)  drop(Constant)


reg pro_other tratamiento genero econ_rel crt_nq orden, robust
outreg2 using "$path_tables/Table_types_dA.xls", excel tex(land) append ctitle("Other") label addtext(Sociodemograpic Controls, X) addnote(Dep Var: )  drop(Constant)


gen sub_treat = 3
replace sub_treat = 2 if ment < 140
replace sub_treat = 1 if ment < 70

//Anova

gen anova_value = 1
replace anova_value = 2 if Amarillas == 50
replace anova_value = 2 if Azules == 50

anova anova_value tratamiento
//Variables Instrumentales

ivregress 2sls Azules ment (tratamiento = effort)
ivregress 2sls Azules  per (tratamiento = temp)
ivregress 2sls Azules ment (tratamiento = frust)

ivregress2 2sls Azules (tratamiento = ment frust), first
    est restore first
    outreg2 using myfile, cttop(first) replace
    est restore second
    estat firststage
    local fstat `r(mineig)'
    estat endogenous
    local p_durbin `r(p_durbin)'
    outreg2 using myfile, cttop(second) excel adds(IV F-stat, `fstat', Durbin pval, `p_durbin')
/////////// APENDICE
reg pro_consequensialist tratamiento, robust
outreg2 using "$path_tables/Table_types_dA.xls", excel tex(land) replace ctitle("Consecuensialist") label addtext(Sociodemograpic Controls, X ) addnote(Dep Var: Effect on norm perception type)  drop(Constant)

reg pro_consequensialist tratamiento genero econ_rel crt_nq  orden, robust
outreg2 using "$path_tables/Table_types_dA.xls", excel tex(land) append ctitle("Consecuensialist") label addtext(Sociodemograpic Controls, X,  ) addnote(Dep Var: Effect on norm perception type)  drop(Constant)

reg pro_normative tratamiento, robust
outreg2 using "$path_tables/Table_types_dA.xls", excel tex(land) append ctitle("Normative Egoist") label addtext(Sociodemograpic Controls, X  ) addnote(Dep Var: Effect on norm perception type)  drop(Constant)


reg pro_normative tratamiento genero econ_rel crt_nq  orden, robust
outreg2 using "$path_tables/Table_types_dA.xls", excel tex(land) append ctitle("Normative Egoist") label addtext(Sociodemograpic Controls,   ) addnote(Dep Var: Effect on norm perception type)  drop(Constant)



reg pro_deontist tratamiento, robust
outreg2 using "$path_tables/Table_types_dA.xls", excel tex(land) append ctitle("Deontist") label addtext(Sociodemograpic Controls,  ) addnote(Dep Var: Effect on norm perception type)  drop(Constant)


reg pro_deontist tratamiento genero econ_rel crt_nq  orden, robust
outreg2 using "$path_tables/Table_types_dA.xls", excel tex(land) append ctitle("Deontist") label addtext(Sociodemograpic Controls, X ) addnote(Dep Var: Effect on norm perception type)  drop(Constant)

reg pro_other tratamiento, robust
outreg2 using "$path_tables/Table_types_dA.xls", excel tex(land) append ctitle("Other") label addtext(Sociodemograpic Controls, X  ) addnote(Effect on norm perception type)  drop(Constant)


reg pro_other tratamiento genero econ_rel crt_nq orden, robust
outreg2 using "$path_tables/Table_types_dA.xls", excel tex(land) append ctitle("Other") label addtext(Sociodemograpic Controls, X) addnote(Dep Var: )  drop(Constant)


gen sub_treat = 3
replace sub_treat = 2 if ment < 140
replace sub_treat = 1 if ment < 70

//Anova Analysis

gen anova_value = 1
replace anova_value = 2 if Amarillas == 50
replace anova_value = 2 if Azules == 50

anova anova_value tratamiento
//Instrumental Variables

ivregress 2sls Azules ment (tratamiento = effort)
ivregress 2sls Azules  per (tratamiento = temp)
ivregress 2sls Azules ment (tratamiento = frust)

ivregress2 2sls Azules (tratamiento = ment frust), first
    est restore first
    outreg2 using myfile, cttop(first) replace
    est restore second
    estat firststage
    local fstat `r(mineig)'
    estat endogenous
    local p_durbin `r(p_durbin)'
    outreg2 using myfile, cttop(second) excel adds(IV F-stat, `fstat', Durbin pval, `p_durbin')

	clear all
	cd    C:\Users\user\Dropbox\Tesis
	global my_path "C:\Users\user\Dropbox\Tesis"
  
	global datos  "$my_path\Raw" 
	global path_graphs "C:\Users\user\Dropbox\Tesis\graficas"
	global path_tables "C:\Users\user\Dropbox\Tesis\tablas"

	use "C:\Users\user\Dropbox\Tesis\raw\data_i.dta" 
	ren consequentialist consequentialist_en 
	ren deontist deontist_en
	ren homo_ec homo_ec_en 
	ren other other_en
	ren type type_en
	merge 1:1 code id_in_session time_started mturk_assignment_id payoff sessionlabel sessioncode using "C:\Users\user\Dropbox\Tesis\raw\datad.dta"
	tab type_en type, chi2
	
	reg tratamiento consequentialist_en deontist_en homo_ec_en , robust
	outreg2 using "$path_tables/Tratamiento.xls", excel tex(land) replace ctitle("Treatment") label addtext(Sociodemograpic Controls, X ) addnote(Dep Var: Effect on norm perception type)  drop(Constant)

	reg tratamiento consequentialist_en deontist_en homo_ec_en mean_lie, robust
	outreg2 using "$path_tables/Tratamiento.xls", excel tex(land) append ctitle("Treatment") label addtext(Sociodemograpic Controls, X,  ) addnote(Dep Var: Effect on norm perception type)  drop(Constant)

	reg tratamiento consequentialist deontist homo_ec , robust
	outreg2 using "$path_tables/Tratamiento.xls", excel tex(land) append ctitle("Treatment") label addtext(Sociodemograpic Controls, X  ) addnote(Dep Var: Effect on norm perception type)  drop(Constant)


	reg tratamiento consequentialist deontist homo_ec  mean_lie, robust
	outreg2 using "$path_tables/Tratamiento.xls", excel tex(land) append ctitle("Treatment") label addtext(Sociodemograpic Controls,   ) addnote(Dep Var: Effect on norm perception type)  drop(Constant)



	reg tratamiento consequentialist_en deontist_en homo_ec_en other_en  consequentialist deontist homo_ec other, robust
	outreg2 using "$path_tables/Tratamiento.xls", excel tex(land) append ctitle("Treatment") label addtext(Sociodemograpic Controls,  ) addnote(Dep Var: Effect on norm perception type)  drop(Constant)


	reg tratamiento consequentialist_en deontist_en homo_ec_en other_en consequentialist deontist homo_ec other mean_lie, robust
	outreg2 using "$path_tables/Tratamiento.xls", excel tex(land) append ctitle("Treatment") label addtext(Sociodemograpic Controls, X ) addnote(Dep Var: Effect on norm perception type)  drop(Constant)

recode S1R1I-S1R6I (-3=1)(-1 = 3)(3=1)(1=3)
cap label define rating2 -3 "very socially unacceptable" -1 "somehow socially unaceptable"  1 "somehow socially acceptable"  3 "Very socially acceptable"  
cap label values S1R1I-S5R6I rating2

* Descriptivas 
//asdoc sum sent_amount keptJ1 dictnoshockj2 dictshockj2 trustnoshockj2 trustshockj2 strategy_method* if treat_unificado == 1, label replace//


