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


use data_time
 

ttest time1, by(tratamiento) unequal
ttest time2, by(tratamiento) unequal
ttest time3, by(tratamiento) unequal

preserve

forvalues i = 1/3 {
graph bar time`i', over(tratamiento) ytitle(Mean)   blabel(bar, format(%4.2f))  intensity(25) graphregion(color(white))   ylabel(0(200)1000,labsize(vsmall)) name(Time`i', replace) 

graph save "$path_graphs/Time`i'",  replace	



}

cd "$path_graphs" 

graph combine Time1.gph Time2.gph Time3.gph, graphregion(color(white)) rows(1) cols(3) title("Average time response on N-Back Task", size(4) color(black)) subtitle({it: By round and treatment }, size(3) color(black)) 
*\

graph export "$path_graphs/Time_1.png", as(png) replace



forvalues i = 1/3 {


cdfplot time`i' , by(tratamiento)  graphregion(color(white)) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) xtitle("Round `i' ", size(small) )  ytitle(, size(small)) yscale(range(0 1)) ylabel(0(.2)1, labsize(small) angle(horizontal)) legend(lab(1 "Low Cognitive Load") lab(2 "High Cognitive Load"))  name(cdf`i' , replace) 


graph save "$path_graphs/cdf1",  replace	


}

grc1leg cdf1.gph cdf2.gph cdf3.gph, graphregion(color(white)) rows(1) cols(3) title("Cumulative Distribution of time responses (ms)", color(black)) subtitle({it: By round and treatment }, size(3) color(black)) scheme(s1color) b2title("Average Response Time in Milliseconds") ring(2)


*\
graph export "$path_graphs/CDF_T.png", as(png) replace

restore

forvalues i = 1/3 {
preserve
	collapse (mean) meanchoicetime=time`i' (sd) sdchoicetime=time`i'  (count) ndic=time`i', by(tratamiento)

	generate hichoicetime = meanchoicetime + invttail(n-1,0.025)*(sdchoicetime / sqrt(213))
	generate lochoicetime = meanchoicetime - invttail(n-1,0.025)*(sdchoicetime / sqrt(213)) 
	  
	twoway (bar meanchoicetime tratamiento if tratamiento==0, pstyle(p1) barw(.7) fcolor(gs13) lcolor(white)) ///
		   (bar meanchoicetime tratamiento if tratamiento==1, pstyle(p1) barw(.7) fcolor(gs13) lcolor(white)) ///
		   (rcap hichoicetime lochoicetime tratamiento, msize(*1) pstyle (p1) lcolor(gs10)) ///
		   (scatter  meanchoicetime tratamiento if tratamiento == 0, msymbol(none) mlabposition(1)) ///
		   (scatter  meanchoicetime tratamiento if tratamiento == 1, msymbol(none) mlabposition(1)), legend(off)  ///
		    graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) ///
		   xlabel( 0 `" Low Cognitive Load "' 1 `" "High Cognitive load"  "', noticks labsize(vsmall))  ///
		   xtitle("Round `i'", size(small))  ytitle("", size(small)) yscale(range(0 1)) ylabel(0(200)1000, labsize(small) angle(horizontal)) name(Time`i', replace) 
		   //text(0.5 3 "---------------------------------------------------------", place(c) color(gray))  ///
		   //text(0.89 2 "__________________________", place(c)) text(0.89 2 "***", place(c)) ///
		   //text(0.84 3 "____________________________________________________", place(c)) text(0.84 3 "***", place(c)) ///
		   //text(0.94 3.5 "_____________", place(c)) text(0.94 3.5 "*", place(c)) ///
		   //text(0.99 4.5 "_____________", place(c)) text(0.99 4.5 "*", place(c)) 

    graph save "$path_graphs/Time`i'",  replace
restore
}



cd $path_graphs

grc1leg Time1.gph Time2.gph Time3.gph,  graphregion(color(white)) rows(1) cols(3) title("Average Time Response in Milliseconds on N-Back Task ", size(4) color(black)) subtitle({it: By round and treatment }, size(3) color(black)) play(mean_time)

quietly{
gr_edit legend.draw_view.setstyle, style(no)
gr_edit legend.Edit , style(rows(2)) style(cols(0)) style(row_gap(minuscule)) keepstyles 
// legend edits

// key region edits

gr_edit plotregion1.graph1.AddTextBox added_text editor 65.14185077504078 -1.747754248319966
gr_edit plotregion1.graph1.added_text_new = 1
gr_edit plotregion1.graph1.added_text_rec = 1
gr_edit plotregion1.graph1.added_text[1].style.editstyle  angle(default) size( sztype(relative) val(2.777) allow_pct(1)) color(black) horizontal(left) vertical(middle) margin( gleft( sztype(relative) val(0) allow_pct(1)) gright( sztype(relative) val(0) allow_pct(1)) gtop( sztype(relative) val(0) allow_pct(1)) gbottom( sztype(relative) val(0) allow_pct(1))) linegap( sztype(relative) val(0) allow_pct(1)) drawbox(no) boxmargin( gleft( sztype(relative) val(0) allow_pct(1)) gright( sztype(relative) val(0) allow_pct(1)) gtop( sztype(relative) val(0) allow_pct(1)) gbottom( sztype(relative) val(0) allow_pct(1))) fillcolor(bluishgray) linestyle( width( sztype(relative) val(.2) allow_pct(1)) color(black) pattern(solid) align(inside)) box_alignment(east) editcopy
gr_edit plotregion1.graph1.added_text[1].DragBy -39.03243295552044 1.781563329920021
// editor text[1] edits

gr_edit plotregion1.graph1.added_text[1].style.editstyle horizontal(center) editcopy
gr_edit plotregion1.graph1.added_text[1]._set_orientation vertical
gr_edit plotregion1.graph1.added_text[1].text = {}
gr_edit plotregion1.graph1.added_text[1].text.Arrpush Milliseconds
// editor text[1] edits

gr_edit plotregion1.graph1.added_text[1].DragBy 16.19603027200017 -2.267444238080025
// editor text[1] reposition

gr_edit plotregion1.graph1.added_text[1].style.editstyle size(medsmall) editcopy
// editor text[1] size

gr_edit plotregion1.graph3.AddTextBox added_text editor 82.30964286336095 29.36953643114808
gr_edit plotregion1.graph3.added_text_new = 1
gr_edit plotregion1.graph3.added_text_rec = 1
gr_edit plotregion1.graph3.added_text[1].style.editstyle  angle(default) size( sztype(relative) val(2.777) allow_pct(1)) color(black) horizontal(left) vertical(middle) margin( gleft( sztype(relative) val(0) allow_pct(1)) gright( sztype(relative) val(0) allow_pct(1)) gtop( sztype(relative) val(0) allow_pct(1)) gbottom( sztype(relative) val(0) allow_pct(1))) linegap( sztype(relative) val(0) allow_pct(1)) drawbox(no) boxmargin( gleft( sztype(relative) val(0) allow_pct(1)) gright( sztype(relative) val(0) allow_pct(1)) gtop( sztype(relative) val(0) allow_pct(1)) gbottom( sztype(relative) val(0) allow_pct(1))) fillcolor(bluishgray) linestyle( width( sztype(relative) val(.2) allow_pct(1)) color(black) pattern(solid) align(inside)) box_alignment(east) editcopy
gr_edit plotregion1.graph3.added_text[1].DragBy .8098015136000228 3.887047265280025
// editor text[1] edits

gr_edit plotregion1.graph3.added_text[1].text = {}
gr_edit plotregion1.graph3.added_text[1].text.Arrpush 964.3
// editor text[1] edits

gr_edit plotregion1.graph3.added_text[1].DragBy -1.619603027200061 -4.049007568000051
// editor text[1] reposition

gr_edit plotregion1.graph3.plotregion1.AddTextBox added_text editor 669.2260655774087 -.1253267660606594
gr_edit plotregion1.graph3.plotregion1.added_text_new = 1
gr_edit plotregion1.graph3.plotregion1.added_text_rec = 1
gr_edit plotregion1.graph3.plotregion1.added_text[1].style.editstyle  angle(default) size( sztype(relative) val(2.777) allow_pct(1)) color(black) horizontal(left) vertical(middle) margin( gleft( sztype(relative) val(0) allow_pct(1)) gright( sztype(relative) val(0) allow_pct(1)) gtop( sztype(relative) val(0) allow_pct(1)) gbottom( sztype(relative) val(0) allow_pct(1))) linegap( sztype(relative) val(0) allow_pct(1)) drawbox(no) boxmargin( gleft( sztype(relative) val(0) allow_pct(1)) gright( sztype(relative) val(0) allow_pct(1)) gtop( sztype(relative) val(0) allow_pct(1)) gbottom( sztype(relative) val(0) allow_pct(1))) fillcolor(bluishgray) linestyle( width( sztype(relative) val(.2) allow_pct(1)) color(black) pattern(solid) align(inside)) box_alignment(east) editcopy
gr_edit plotregion1.graph3.plotregion1.added_text[1].DragBy -9.09042478823479 .2892900862766497
// editor text[1] edits

gr_edit plotregion1.graph3.plotregion1.added_text[1].text = {}
gr_edit plotregion1.graph3.plotregion1.added_text[1].text.Arrpush 596.6
// editor text[1] edits

gr_edit plotregion1.graph3.plotregion1.added_text[1].DragBy -4.545212394117724 -.2989330891525376
// editor text[1] reposition

gr_edit plotregion1.graph1.plotregion1.AddTextBox added_text editor 672.3585414543776 -.0879998735529465
gr_edit plotregion1.graph1.plotregion1.added_text_new = 1
gr_edit plotregion1.graph1.plotregion1.added_text_rec = 1
gr_edit plotregion1.graph1.plotregion1.added_text[1].style.editstyle  angle(default) size( sztype(relative) val(2.777) allow_pct(1)) color(black) horizontal(left) vertical(middle) margin( gleft( sztype(relative) val(0) allow_pct(1)) gright( sztype(relative) val(0) allow_pct(1)) gtop( sztype(relative) val(0) allow_pct(1)) gbottom( sztype(relative) val(0) allow_pct(1))) linegap( sztype(relative) val(0) allow_pct(1)) drawbox(no) boxmargin( gleft( sztype(relative) val(0) allow_pct(1)) gright( sztype(relative) val(0) allow_pct(1)) gtop( sztype(relative) val(0) allow_pct(1)) gbottom( sztype(relative) val(0) allow_pct(1))) fillcolor(bluishgray) linestyle( width( sztype(relative) val(.2) allow_pct(1)) color(black) pattern(solid) align(inside)) box_alignment(east) editcopy
gr_edit plotregion1.graph1.plotregion1.added_text[1].DragBy 8.920914734404153 .1639310488901019
// editor text[1] edits

gr_edit plotregion1.graph1.plotregion1.added_text[1].text = {}
gr_edit plotregion1.graph1.plotregion1.added_text[1].text.Arrpush 606.8
// editor text[1] edits

gr_edit plotregion1.graph1.plotregion1.added_text[1].DragBy -17.84182946880766 -.2507180747730967
// editor text[1] reposition

gr_edit plotregion1.graph1.AddTextBox added_text editor 82.30964286336095 31.4541078092804
gr_edit plotregion1.graph1.added_text_new = 2
gr_edit plotregion1.graph1.added_text_rec = 2
gr_edit plotregion1.graph1.added_text[2].style.editstyle  angle(default) size( sztype(relative) val(2.777) allow_pct(1)) color(black) horizontal(left) vertical(middle) margin( gleft( sztype(relative) val(0) allow_pct(1)) gright( sztype(relative) val(0) allow_pct(1)) gtop( sztype(relative) val(0) allow_pct(1)) gbottom( sztype(relative) val(0) allow_pct(1))) linegap( sztype(relative) val(0) allow_pct(1)) drawbox(no) boxmargin( gleft( sztype(relative) val(0) allow_pct(1)) gright( sztype(relative) val(0) allow_pct(1)) gtop( sztype(relative) val(0) allow_pct(1)) gbottom( sztype(relative) val(0) allow_pct(1))) fillcolor(bluishgray) linestyle( width( sztype(relative) val(.2) allow_pct(1)) color(black) pattern(solid) align(inside)) box_alignment(east) editcopy
gr_edit plotregion1.graph1.added_text[2].text = {}
gr_edit plotregion1.graph1.added_text[2].text.Arrpush 946.3
// editor text[2] edits

gr_edit plotregion1.graph1.added_text[2].DragBy -.6478412108799807 -2.105483935360022
// editor text[2] reposition

gr_edit plotregion1.graph2.AddTextBox added_text editor 82.47160316608095 28.71123894165417
gr_edit plotregion1.graph2.added_text_new = 1
gr_edit plotregion1.graph2.added_text_rec = 1
gr_edit plotregion1.graph2.added_text[1].style.editstyle  angle(default) size( sztype(relative) val(2.777) allow_pct(1)) color(black) horizontal(left) vertical(middle) margin( gleft( sztype(relative) val(0) allow_pct(1)) gright( sztype(relative) val(0) allow_pct(1)) gtop( sztype(relative) val(0) allow_pct(1)) gbottom( sztype(relative) val(0) allow_pct(1))) linegap( sztype(relative) val(0) allow_pct(1)) drawbox(no) boxmargin( gleft( sztype(relative) val(0) allow_pct(1)) gright( sztype(relative) val(0) allow_pct(1)) gtop( sztype(relative) val(0) allow_pct(1)) gbottom( sztype(relative) val(0) allow_pct(1))) fillcolor(bluishgray) linestyle( width( sztype(relative) val(.2) allow_pct(1)) color(black) pattern(solid) align(inside)) box_alignment(east) editcopy
gr_edit plotregion1.graph2.added_text[1].DragBy .4858809081600323 6.154491503360097
// editor text[1] edits

gr_edit plotregion1.graph2.added_text[1].text = {}
gr_edit plotregion1.graph2.added_text[1].text.Arrpush 599.7
// editor text[1] edits

gr_edit plotregion1.graph2.added_text[1].DragBy -29.47677509504035 -23.16032328896025
// editor text[1] reposition

gr_edit plotregion1.graph2.AddTextBox added_text editor 82.95748407424098 21.90890622741409
gr_edit plotregion1.graph2.added_text_new = 2
gr_edit plotregion1.graph2.added_text_rec = 2
gr_edit plotregion1.graph2.added_text[2].style.editstyle  angle(default) size( sztype(relative) val(2.777) allow_pct(1)) color(black) horizontal(left) vertical(middle) margin( gleft( sztype(relative) val(0) allow_pct(1)) gright( sztype(relative) val(0) allow_pct(1)) gtop( sztype(relative) val(0) allow_pct(1)) gbottom( sztype(relative) val(0) allow_pct(1))) linegap( sztype(relative) val(0) allow_pct(1)) drawbox(no) boxmargin( gleft( sztype(relative) val(0) allow_pct(1)) gright( sztype(relative) val(0) allow_pct(1)) gtop( sztype(relative) val(0) allow_pct(1)) gbottom( sztype(relative) val(0) allow_pct(1))) fillcolor(bluishgray) linestyle( width( sztype(relative) val(.2) allow_pct(1)) color(black) pattern(solid) align(inside)) box_alignment(east) editcopy
gr_edit plotregion1.graph2.added_text[2].DragBy .4858809081600168 9.555657860480103
// editor text[2] edits

gr_edit plotregion1.graph2.added_text[2].text = {}
gr_edit plotregion1.graph2.added_text[2].text.Arrpush 966.7
// editor text[2] edits

gr_edit plotregion1.graph2.added_text[2].DragBy -1.781563329920041 -2.429404540800005
// editor text[2] reposition
}

graph export "$path_graphs/Time_E.png", as(png) replace


forvalues i = 1/3 {
if `i' == 1 local col1 = "blue"   
if `i' == 2 local col1 = "red"   
if `i' == 3 local col1 = "green"   
 

graph box time`i', over(tratamiento, relabel(1 "Low Cognitive Load" 2 "High Cognitive Load"))   ytitle("") title("")  graphregion(color(white))  blabel(bar, format(%4.2f)) yscale(range(0 1) titlegap(.2))  box(1, color(`col1')) box(2, color(`col1'))  name(bTime`i', replace)
graph save "$path_graphs/bTime`i'",  replace	
}


graph combine bTime1.gph bTime2.gph bTime3.gph, graphregion(color(white)) rows(1) cols(3) title(" Time Response in Milliseconds on All Trials on N-Back Task", size(4) color(black)) subtitle({it: By round and treatment }, size(3) color(black)) play(box_tiempo)


graph export "$path_graphs/Box_Time.png", as(png) replace


use "$datos\data_i.dta", clear



cd $path_graphs


gen r1correctasp = r1correctas/60
gen r2correctasp = r2correctas/60
gen r3correctasp = r3correctas/60


forvalues i = 1/3 {
if `i' == 1 local col1 = "blue"   
if `i' == 2 local col1 = "red"   
if `i' == 3 local col1 = "green"   
 

graph box r`i'correctasp, over(tratamiento, relabel(1 "Low Cognitive Load" 2 "High Cognitive Load"))   ytitle("") title("")  graphregion(color(white))  blabel(bar, format(%4.2f)) yscale(range(0 1) titlegap(.2))  box(1, color(`col1')) box(2, color(`col1'))  name(rCorrect`i', replace)
graph save "$path_graphs/rCorrect`i'",  replace	
}


graph combine rCorrect1.gph rCorrect2.gph rCorrect3.gph, graphregion(color(white)) rows(1) cols(3) title("Correct answers on N-Back Task", size(4) color(black)) subtitle({it: By round and treatment }, size(3) color(black)) play(box_correctas)


graph export "$path_graphs/Box_Correctas.png", as(png) replace


replace ment = ment/10
replace phys = phys/10
replace per = per/10
replace effort = effort/10
replace temp = temp/10
replace frust = frust/10

cdfplot ment, by(tratamiento)  graphregion(color(white)) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) xtitle("Mental Load", size(small) )  ytitle(, size(small)) yscale(range(0 1)) ylabel(0(.2)1, labsize(small) angle(horizontal)) legend(lab(1 "Low Cognitive Load") lab(2 "High Cognitive Load")) name(NASA1, replace)
graph save "$path_graphs/NASA1",  replace	

cdfplot per, by(tratamiento)  graphregion(color(white)) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) xtitle("Performance", size(small) )  ytitle(, size(small)) yscale(range(0 1)) ylabel(0(.2)1, labsize(small) angle(horizontal)) legend(lab(1 "Low Cognitive Load") lab(2 "High Cognitive Load")) name(NASA2, replace)
graph save "$path_graphs/NASA2",  replace	

cdfplot temp, by(tratamiento)  graphregion(color(white)) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) xtitle("Temporal Load", size(small) )  ytitle(, size(small)) yscale(range(0 1)) ylabel(0(.2)1, labsize(small) angle(horizontal)) legend(lab(1 "Low Cognitive Load") lab(2 "High Cognitive Load")) name(NASA3, replace)
graph save "$path_graphs/NASA3",  replace	

cdfplot phys, by(tratamiento)  graphregion(color(white)) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) xtitle("Physical Load", size(small) )  ytitle(, size(small)) yscale(range(0 1)) ylabel(0(.2)1, labsize(small) angle(horizontal)) legend(lab(1 "Low Cognitive Load") lab(2 "High Cognitive Load")) name(NASA4, replace)
graph save "$path_graphs/NASA4",  replace	

cdfplot effort, by(tratamiento)  graphregion(color(white)) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) xtitle("Effort", size(small) )  ytitle(, size(small)) yscale(range(0 1)) ylabel(0(.2)1, labsize(small) angle(horizontal)) legend(lab(1 "Low Cognitive Load") lab(2 "High Cognitive Load")) name(NASA5, replace)
graph save "$path_graphs/NASA5",  replace	

cdfplot frust, by(tratamiento)  graphregion(color(white)) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) xtitle("Frustation", size(small) )  ytitle(, size(small)) yscale(range(0 1)) ylabel(0(.2)1, labsize(small) angle(horizontal)) legend(lab(1 "Low Cognitive Load") lab(2 "High Cognitive Load")) name(NASA6, replace)
graph save "$path_graphs/NASA6",  replace	

grc1leg NASA1.gph NASA2.gph NASA3.gph NASA4.gph NASA5.gph NASA6.gph, graphregion(color(white)) rows(2) cols(3) title("NASA TLX Autoreport Responses", size(4) color(black)) subtitle({it: By treatment }, size(3) color(black)) scheme(s1color)

graph export "$path_graphs/CDF_NASA.png", as(png) replace

cap gen Azulesp = Azules/50



histogram Azulesp if tratamiento == 0,fraction  color(gs7) xlabel(0(.5)1) ylabel(0(.1).3, grid) xtitle(Role Following, size(2.4))  ytitle(, size(2.4)) title({bf: Low Cognitive Load }, color(black) size(3.5)) subtitle("", fcolor(white) lcolor(white) color(black) size(2.6))  graphregion(color(white)) note("")  name(AzulesLow, replace)
graph save "$path_graphs/AzulesLow",  replace	

histogram Azulesp if tratamiento == 1,fraction  color(gs7) xlabel(0(.5)1) ylabel(0(.1).3, grid) xtitle(Role Following, size(2.4))  ytitle(, size(2.4)) title({bf: High Cognitive Load }, color(black) size(3.5)) subtitle("", fcolor(white) lcolor(white) color(black) size(2.6))  graphregion(color(white)) note("")  name(AzulesHigh, replace)
graph save "$path_graphs/AzulesHigh",  replace	

graph combine AzulesLow.gph AzulesHigh.gph, graphregion(color(white)) rows(1)  title("Rule Following Propensity", size(4) color(black)) subtitle({it: By treatment }, size(3) color(black)) scheme(s1color) play(azules_lines)

graph export "$path_graphs/BlueBucket.png", as(png) replace



catplot type, fraction(tratamiento) by(tratamiento, graphregion(color(white))) ytitle(Norm perception types)   blabel(bar, format(%4.2f))  intensity(25) graphregion(color(white))   ylabel(0(.2)1,labsize(vsmall))  play(types)

graph export "$path_graphs/Type_I.png", as(png) replace

lab var temp "Temporal Effort"
lab var effort "General Effort"
lab var frust "Frustation"
lab var ment "Mental Effort"
lab var phys "Physical Effort"
lab var per "Performance"


forvalues i  = 1/6 {
if `i' == 1 local nasa = "ment"   
if `i' == 2 local nasa = "effort"   
if `i' == 3 local nasa = "frust" 
if `i' == 4 local nasa = "temp"   
if `i' == 5 local nasa = "phys"   
if `i' == 6 local nasa = "per" 
//Local for the colors of each box
if `i' == 1 local col1 = "blue"   
if `i' == 2 local col1 = "red"   
if `i' == 3 local col1 = "green"   
if `i' == 4 local col1 = "erose"   
if `i' == 5 local col1 = "yellow"   
if `i' == 6 local col1 = "grey" 
if `i' == 1 local pval = "0.000"   
if `i' == 2 local pval = "0.000"   
if `i' == 3 local pval=  "0.006"   
if `i' == 4 local pval = "0.000"   
if `i' == 5 local pval = "0.379"   
if `i' == 6 local pval = "0.000" 
graph box `nasa', over(tratamiento, relabel(1 "Low Cognitive Load" 2 "High Cognitive Load"))   ytitle("") title("`nasa'")  graphregion(color(white))  blabel(bar, format(%4.2f)) yscale(range(0 1) titlegap(.2)) name(`nasa', replace)  box(1, color(`col1')) box(2, color(`col1')) note("P-val = `pval'")


graph save "$path_graphs/`nasa'",  replace	



}


grc1leg ment.gph effort.gph frust.gph temp.gph phys.gph per.gph, graphregion(color(white)) rows(2) title("NASA TLX Autoreport Responses", size(4) color(black)) subtitle({it: By treatment }, size(3) color(black)) scheme(s1color) play(box_nasa)

quietly{
gr_edit plotregion1.graph1.grpaxis.style.editstyle majorstyle(tickstyle(textstyle(size(small)))) editcopy
// grpaxis size

gr_edit plotregion1.graph2.grpaxis.style.editstyle majorstyle(tickstyle(textstyle(size(small)))) editcopy
// grpaxis size

gr_edit plotregion1.graph3.grpaxis.style.editstyle majorstyle(tickstyle(textstyle(size(small)))) editcopy
// grpaxis size

gr_edit plotregion1.graph4.grpaxis.style.editstyle majorstyle(tickstyle(textstyle(size(small)))) editcopy
// grpaxis size

gr_edit plotregion1.graph5.grpaxis.style.editstyle majorstyle(tickstyle(textstyle(size(small)))) editcopy
// grpaxis size
gr_edit plotregion1.graph6.grpaxis.style.editstyle majorstyle(tickstyle(textstyle(size(small)))) editcopy
// grpaxis size

gr_edit plotregion1.graph1.title.style.editstyle size(medlarge) editcopy
// title size

gr_edit plotregion1.graph1.title.style.editstyle size(large) editcopy
gr_edit plotregion1.graph1.title.text = {}
gr_edit plotregion1.graph1.title.text.Arrpush Mental Effort
// title edits

gr_edit plotregion1.graph2.title.style.editstyle size(medlarge) editcopy
// title size

gr_edit plotregion1.graph2.title.text = {}
gr_edit plotregion1.graph2.title.text.Arrpush General Effort
// title edits

gr_edit plotregion1.graph3.title.style.editstyle size(medlarge) editcopy
gr_edit plotregion1.graph3.title.text = {}
gr_edit plotregion1.graph3.title.text.Arrpush Frustation
// title edits

gr_edit plotregion1.graph1.title.style.editstyle size(medlarge) editcopy
// title size

gr_edit plotregion1.graph4.title.text = {}
gr_edit plotregion1.graph4.title.text.Arrpush Temporal Effort
// title edits

gr_edit plotregion1.graph4.title.style.editstyle size(medlarge) editcopy
// title size

gr_edit plotregion1.graph5.title.text = {}
gr_edit plotregion1.graph5.title.text.Arrpush Physical Effort
// title edits

gr_edit plotregion1.graph6.title.text = {}
gr_edit plotregion1.graph6.title.text.Arrpush Performance
// title edits

gr_edit plotregion1.graph1.plotregion1.outsides[4].style.editstyle marker(fillcolor(midblue)) editcopy
gr_edit plotregion1.graph1.plotregion1.outsides[4].style.editstyle marker(linestyle(color(midblue))) editcopy
// outsides[4] edits

gr_edit plotregion1.graph1.plotregion1.outsides[4].style.editstyle marker(linestyle(color(dknavy))) editcopy
// outsides[4] color

gr_edit plotregion1.graph5.plotregion1.outsides[16].style.editstyle marker(fillcolor(yellow)) editcopy
gr_edit plotregion1.graph5.plotregion1.outsides[16].style.editstyle marker(linestyle(color(gold))) editcopy
// outsides[16] edits

gr_edit plotregion1.graph6.plotregion1.outsides[3].style.editstyle marker(fillcolor(gray)) editcopy
gr_edit plotregion1.graph6.plotregion1.outsides[3].style.editstyle marker(linestyle(color(dimgray))) editcopy
// outsides[3] edits

gr_edit  AddTextBox added_text editor 66.14724774784075 -1.22823818367999
gr_edit added_text_new = 1
gr_edit added_text_rec = 1
gr_edit added_text[1].style.editstyle  angle(default) size( sztype(relative) val(2.777) allow_pct(1)) color(black) horizontal(left) vertical(middle) margin( gleft( sztype(relative) val(0) allow_pct(1)) gright( sztype(relative) val(0) allow_pct(1)) gtop( sztype(relative) val(0) allow_pct(1)) gbottom( sztype(relative) val(0) allow_pct(1))) linegap( sztype(relative) val(0) allow_pct(1)) drawbox(no) boxmargin( gleft( sztype(relative) val(0) allow_pct(1)) gright( sztype(relative) val(0) allow_pct(1)) gtop( sztype(relative) val(0) allow_pct(1)) gbottom( sztype(relative) val(0) allow_pct(1))) fillcolor(bluishgray) linestyle( width( sztype(relative) val(.2) allow_pct(1)) color(black) pattern(solid) align(inside)) box_alignment(east) editcopy
gr_edit added_text[1]._set_orientation vertical
gr_edit added_text[1].text = {}
gr_edit added_text[1].text.Arrpush Score
// editor text[1] edits

gr_edit plotregion1.graph4.AddTextBox added_text editor 18.17672569706702 -.6462860680532905
gr_edit plotregion1.graph4.added_text_new = 1
gr_edit plotregion1.graph4.added_text_rec = 1
gr_edit plotregion1.graph4.added_text[1].style.editstyle  angle(default) size( sztype(relative) val(2.777) allow_pct(1)) color(black) horizontal(left) vertical(middle) margin( gleft( sztype(relative) val(0) allow_pct(1)) gright( sztype(relative) val(0) allow_pct(1)) gtop( sztype(relative) val(0) allow_pct(1)) gbottom( sztype(relative) val(0) allow_pct(1))) linegap( sztype(relative) val(0) allow_pct(1)) drawbox(no) boxmargin( gleft( sztype(relative) val(0) allow_pct(1)) gright( sztype(relative) val(0) allow_pct(1)) gtop( sztype(relative) val(0) allow_pct(1)) gbottom( sztype(relative) val(0) allow_pct(1))) fillcolor(bluishgray) linestyle( width( sztype(relative) val(.2) allow_pct(1)) color(black) pattern(solid) align(inside)) box_alignment(east) editcopy
gr_edit plotregion1.graph4.added_text[1].text = {}
gr_edit plotregion1.graph4.added_text[1].text.Arrpush Score
// editor text[1] edits

gr_edit plotregion1.graph4.AddTextBox added_text editor 18.33868599978702 .4874360509867257
gr_edit plotregion1.graph4.added_text_new = 2
gr_edit plotregion1.graph4.added_text_rec = 2
gr_edit plotregion1.graph4.added_text[2].style.editstyle  angle(default) size( sztype(relative) val(2.777) allow_pct(1)) color(black) horizontal(left) vertical(middle) margin( gleft( sztype(relative) val(0) allow_pct(1)) gright( sztype(relative) val(0) allow_pct(1)) gtop( sztype(relative) val(0) allow_pct(1)) gbottom( sztype(relative) val(0) allow_pct(1))) linegap( sztype(relative) val(0) allow_pct(1)) drawbox(no) boxmargin( gleft( sztype(relative) val(0) allow_pct(1)) gright( sztype(relative) val(0) allow_pct(1)) gtop( sztype(relative) val(0) allow_pct(1)) gbottom( sztype(relative) val(0) allow_pct(1))) fillcolor(bluishgray) linestyle( width( sztype(relative) val(.2) allow_pct(1)) color(black) pattern(solid) align(inside)) box_alignment(east) editcopy
gr_edit plotregion1.graph4.added_text[1]._set_orientation vertical
// editor text[1] edits

gr_edit plotregion1.graph4.added_text[1].style.editstyle size(medsmall) editcopy
// editor text[1] size

gr_edit plotregion1.graph4.added_text[1].style.editstyle size(medium) editcopy
// editor text[1] size

gr_edit plotregion1.graph4.added_text[1].DragBy .161960302719999 -2.105483935360025
// editor text[1] reposition

gr_edit added_text[1].style.editstyle size(medium) editcopy
// editor text[1] size

gr_edit added_text[1].style.editstyle size(medsmall) editcopy
// editor text[1] size

gr_edit added_text[1].style.editstyle size(small) editcopy
// editor text[1] size

gr_edit plotregion1.graph4.added_text[1].DragBy -.3239206054400059 -.3239206054400039
// editor text[1] reposition

gr_edit legend.plotregion1.label.draw_view.setstyle, style(no)
gr_edit legend.plotregion1.label.fill_if_undrawn.setstyle, style(no)
// label edits

gr_edit legend.draw_view.setstyle, style(no)
gr_edit legend.Edit , style(rows(2)) style(cols(0)) style(row_gap(minuscule)) keepstyles 
// legend edits}
}
graph export "$path_graphs/Box_NASA.png", as(png) replace


gen pro_consequensialist = 0
replace pro_consequensialist = 1 if type == 1

gen pro_normative = 0
replace pro_normative = 1 if type == 2

gen pro_deontist = 0
replace pro_deontist = 1 if type == 3


gen pro_other = 0
replace pro_other = 1 if type == 4

graph box pro_consequensialist pro_normative pro_deontist phys pro_other , over(tratamiento, relabel(1 "Low Cognitive Load" 2 "High Cognitive Load"))   ytitle(Type) title("Norm Perception Types")  graphregion(color(white))  blabel(bar, format(%4.2f)) yscale(range(0 1) titlegap(.2)) 


preserve
reshape long caso, i(code) j(c)

replace caso = 0.33 if caso == 3
replace caso = -0.33 if caso == -3

 graph hbox S1R1I S1R2I S1R4I S1R3I S1R5I S1R6I, by(type) over(tratamiento)

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



graph hbox caso, over(extent) by(type)  ytitle(Valuation) title("Nasa TLX Perception") legend(off) graphregion(color(white))  blabel(bar, format(%4.2f)) yscale(range(0 1) titlegap(.2))  play(box_types)

graph export "$path_graphs/Box_Type.png", as(png) replace  

restore



////////////////////////////////////////////////////// GRAFÍCOS CREENCIAS NORMATIVAS ////////////////////////////////////////////////////////////

clear all
use "$datos\datad.dta", clear


catplot type, fraction(tratamiento) by(tratamiento, graphregion(color(white))) ytitle(Norm perception types)   blabel(bar, format(%4.2f))  intensity(25) graphregion(color(white))   ylabel(0(.2)1,labsize(vsmall))  play(types)



graph export "$path_graphs/Type_D.png", as(png) replace  


gen pro_consequensialist = 0
replace pro_consequensialist = 1 if type == 1

gen pro_normative = 0
replace pro_normative = 1 if type == 2

gen pro_deontist = 0
replace pro_deontist = 1 if type == 3


gen pro_other = 0
replace pro_other = 1 if type == 4

graph box pro_consequensialist pro_normative pro_deontist phys pro_other , over(tratamiento, relabel(1 "Low Cognitive Load" 2 "High Cognitive Load"))   ytitle(Type) title("Norm Perception Types")  graphregion(color(white))  blabel(bar, format(%4.2f)) yscale(range(0 1) titlegap(.2)) 



graph export "$path_graphs/BoxType_D.png", as(png) replace  

preserve
reshape long casod, i(code) j(c)

replace caso = 0.33 if caso == 3
replace caso = -0.33 if caso == -3

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
 graph hbox S1R1D S1R2D S1R4D S1R3D S1R5D S1R6D, by(type) over(tratamiento)


graph hbox caso, over(extent) by(type)  ytitle(Valuation) title("Nasa TLX Perception") legend(off) graphregion(color(white))  blabel(bar, format(%4.2f)) yscale(range(0 1) titlegap(.2))  play(box_types)

graph export "$path_graphs/Box_Type_D.png", as(png) replace  
* Descriptivas 
//asdoc sum sent_amount keptJ1 dictnoshockj2 dictshockj2 trustnoshockj2 trustshockj2 strategy_method* if treat_unificado == 1, label replace//


se "$datos\data_i.dta", clear


preserve
cap gen Azulesp = Azules/50

gen cat_1 = 1 if Azules == 0
gen cat_2 = 1 if Azules > 0 & Azules <= 7
gen cat_3 = 1 if Azules > 7 & Azules <= 13
gen cat_4 = 1 if Azules > 13  & Azules <=20
gen cat_5 = 1 if Azules > 20 & Azules <=26
gen cat_6 = 1 if Azules > 26 & Azules <=32
gen cat_7 = 1 if Azules > 32 & Azules <=38
gen cat_8 = 1 if Azules > 38 & Azules <=44
gen cat_9 = 1 if Azules > 44 & Azules <=49
gen cat_10 = 1 if Azules == 50




collapse (sum) cat_*, by (tratamiento) 

egen total_cat = rowtotal(cat_*)

egen total = sum(total_cat) 


forvalues i = 1/10 {
gen p_cat_`i' = cat_`i'/total_cat	
	
}
reshape long cat_ p_cat_, i(tratamiento) j(categoria)

sort tratamiento categoria

gen orden = _n

replace orden = _n + 1 if orden > 10

gen orden2 = _n
forvalues i = 11/20 {
	
	replace orden2 = `i' -  10  if orden2 == `i'

}

/*

replace orden = _n + 2 if orden > 5
replace orden = _n + 3 if orden > 8
replace orden = _n + 4 if orden > 11
*/

label def orden 1 "0" 5 "0.5" 10 "1" 12 "0" 21 "1" 11 "-"
label val orden orden

label def orden2 1 "0" 5 "0.5" 10 "1" 
label val orden2 orden2

cd "$path_graphs"

format p_cat_ %9.2g

twoway (bar p_cat_ orden if tratamiento == 0 & categoria == 1, bcolor(midblue)) ( bar p_cat_ orden if tratamiento == 0 & categoria == 2, bcolor(midgreen)) ( bar p_cat_ orden if tratamiento == 0 & categoria == 3, bcolor(midgreen)) ( bar p_cat_ orden if tratamiento == 0 & categoria == 4, bcolor(midgreen))  ( bar p_cat_ orden if tratamiento == 0 & categoria == 5, bcolor(midgreen)) ( bar p_cat_ orden if tratamiento == 0 & categoria == 6, bcolor(midgreen)) ( bar p_cat_ orden if tratamiento == 0 & categoria == 7, bcolor(midgreen)) ( bar p_cat_ orden if tratamiento == 0 & categoria == 8, bcolor(midgreen)) ( bar p_cat_ orden if tratamiento == 0 & categoria == 9, bcolor(midgreen)) ( bar p_cat_ orden if tratamiento == 0 & categoria == 10, bcolor(blue))  (bar p_cat_ orden if tratamiento == 1 & categoria == 1, bcolor(midblue)) ( bar p_cat_ orden if tratamiento == 1 & categoria == 2, bcolor(midgreen)) ( bar p_cat_ orden if tratamiento == 1 & categoria == 3, bcolor(midgreen)) ( bar p_cat_ orden if tratamiento == 1 & categoria == 4, bcolor(midgreen))  ( bar p_cat_ orden if tratamiento == 1 & categoria == 5, bcolor(midgreen)) ( bar p_cat_ orden if tratamiento == 1 & categoria == 6, bcolor(midgreen)) ( bar p_cat_ orden if tratamiento == 1 & categoria == 7, bcolor(midgreen)) ( bar p_cat_ orden if tratamiento == 1 & categoria == 8, bcolor(midgreen)) ( bar p_cat_ orden if tratamiento == 1 & categoria == 9, bcolor(midgreen)) ( bar p_cat_ orden if tratamiento == 1 & categoria == 10, bcolor(blue))   (scatter p_cat_ orden, mlabel(p_cat_) msymbol(none) mlabp(12) mlabcolor(black) mlabsize(vsmall)), xtitle("") ytitle("Proportion") xlabel(1(1)21, val angle(45) labsize(vsmall) notick) plotregion(fcolor(white)) yscale(lcolor(black)) title("Relative Frequency", size(medsmall)) subtitle("Per Treatment", size(small)) scheme(plottig) ylabel(0(0.1)0.3,  labsize(vsmall) notick) legend(off)



twoway (bar p_cat_ orden2 if tratamiento == 0 & categoria == 1, bcolor(midgreen%70)) ( bar p_cat_ orden2 if tratamiento == 0 & categoria == 2, bcolor(midgreen%40)) ( bar p_cat_ orden2 if tratamiento == 0 & categoria == 3, bcolor(midgreen%40)) ( bar p_cat_ orden2 if tratamiento == 0 & categoria == 4, bcolor(midgreen%40))  ( bar p_cat_ orden2 if tratamiento == 0 & categoria == 5, bcolor(midgreen%30)) ( bar p_cat_ orden2 if tratamiento == 0 & categoria == 6, bcolor(midgreen%30)) ( bar p_cat_ orden if tratamiento == 0 & categoria == 7, bcolor(midgreen%30)) ( bar p_cat_ orden2 if tratamiento == 0 & categoria == 8, bcolor(midgreen%30)) ( bar p_cat_ orden if tratamiento == 0 & categoria == 9, bcolor(midgreen%30)) ( bar p_cat_ orden2 if tratamiento == 0 & categoria == 10, bcolor(midgreen%70))  (bar p_cat_ orden2 if tratamiento == 1 & categoria == 1, bcolor(red%50)) ( bar p_cat_ orden2 if tratamiento == 1 & categoria == 2, bcolor(red%30)) ( bar p_cat_ orden2 if tratamiento == 1 & categoria == 3, bcolor(red%30)) ( bar p_cat_ orden2 if tratamiento == 1 & categoria == 4, bcolor(red%30))  ( bar p_cat_ orden2 if tratamiento == 1 & categoria == 5, bcolor(red%30)) ( bar p_cat_ orden2 if tratamiento == 1 & categoria == 6, bcolor(red%30)) ( bar p_cat_ orden2 if tratamiento == 1 & categoria == 7, bcolor(red%30)) ( bar p_cat_ orden2 if tratamiento == 1 & categoria == 8, bcolor(red%30)) ( bar p_cat_ orden2 if tratamiento == 1 & categoria == 9, bcolor(red%30)) ( bar p_cat_ orden2 if tratamiento == 1 & categoria == 10, bcolor(red%60)),  ytitle("Proportion of Subjects") xlabel(1(9)10, val angle(0) labsize(vsmall) notick) plotregion(fcolor(white)) yscale(lcolor(black)) title("Distribution of Balls in the Blue Bucket (Rule-Following Behavior)", size(medsmall)) subtitle("Per Treatment", size(small)) scheme(plottig) ylabel(0(0.05)0.25,  labsize(vsmall) notick) xtitle("Proportion of the Balls in Blue Bucket") legend(order(1 "Low Cognitive Load" 20 "High Cognitive Load") pos(4)) play (prop_dis)



if c(username) == "user" { 
    graph export "$path_graphs/ProportionOver.png", as(png) replace
}

restore


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

use data_i

recode S1R1I-S5R6I (-1=-3)(-0.33=-1)(0.33=1)(1=3)

order S1R3D, before (S1R4D)
*Media de Aceptación Social Para La Mentira
gen msa_lie = (S1R2I+ S1R3I+ S1R4I+ S1R5I+ S1R6I+ S2R3I + S2R4I + S2R5I+ S2R6I+ S3R4I+ S3R5I+ S3R6I+ S4R5I+ S4R6I+ S5R6I)/15
lab var msa_lie "Mean Social Acceptability of Dishonesty (Injuctives Norms)"


*Media de Aceptación Social Para La Verdad
gen msa_truth = (S1R1I+ S2R2I+ S3R3I+ S4R4I+ S5R5I)/5
lab var msa_truth "Mean Social Acceptability of Honesty (Injuctives Norms) "



cap label define rating2 -3 "very socially unacceptable" -1 "somehow socially unaceptable"  1 "somehow socially acceptable"  3 "Very socially acceptable"  
cap label values S1R1I-S5R6I rating2


local j=0
forvalues n = 1/6 {
    forvalues s=1/5 {
	cap gen d`s'R`n'= S`s'R`n'I/3
}
}

gen truth=msa_truth/3
lab var truth "Truth"
gen lie1= (d1R2 + d2R3 + d3R4 + d4R5 + d5R6)/5
lab var lie1 "1 MU"
gen lie2 = (d1R3 + d2R4 + d3R5 + d4R6)/4
lab var lie2 "2 MU"
gen lie3 = (d1R4 + d2R5 + d3R6 )/3
lab var lie3 "3 MU"
gen lie4 = (d1R5 + d2R6)/2
lab var lie4 "4 MU"
gen lie5 = d1R6
lab var lie5 "5 MU"


gen lie0=truth
reshape long lie, i(code) j(extent)
*label var lie "Social Acceptability"
lab def extent 0 "Truth" 1 "1 MU" 2 "2 MU" 3 "3 MU" 4 "4 MU" 5 "5 MU", replace
lab val extent extent

replace truth=. if extent>0
replace lie=. if extent==0
 
*Generate Box-plots for Top Panel of main Figure 1
graph box truth lie , over(extent, label(angle(45) labsize(small))) over(type, label(labsize(medsmall)) gap(*2.5)) nofill title("Perception of Normative Expectations") subtitle("for truthfull reporting and different extent of lying") graphregion(color(white)) lintensity(*.3) medtype(cline) medline(lwidth(thick) lcolor(gs1)) intensity(*.1) cwhiskers lines(lwidth(vthin) lpattern(_)) alsize(50) marker(1, msize(medsmall) mcolor(dknavy*.3) mlcolor(none)) box(1, color(dknavy)) marker(2, msize(medsmall) mcolor(maroon*.4) mlcolor(none))  box(2, color(maroon) )  yline(0, axis(1) lstyle(foreground))  boxgap(6) ylabel(-1 -0.33 0.33 1 , labsize(small) angle(0)) xsize(2.5) ysize(4)  yscale(noline) legend(off) ytitle("Social Acceptability")

graph export "$path_graphs/Box_Types4EN.png", as(png) replace

graph box truth lie if type !=4 , over(extent, label(angle(45) labsize(small))) over(type, label(labsize(medsmall)) gap(*2.5))  by(tratamiento) nofill title("Perception of Normative Expectations") subtitle("for truthfull reporting and different extent of lying") graphregion(color(white)) lintensity(*.3) medtype(cline) medline(lwidth(thick) lcolor(gs1)) intensity(*.1) cwhiskers lines(lwidth(vthin) lpattern(_)) alsize(50) marker(1, msize(medsmall) mcolor(dknavy*.3) mlcolor(none)) box(1, color(dknavy)) marker(2, msize(medsmall) mcolor(maroon*.4) mlcolor(none))  box(2, color(maroon) )  yline(0, axis(1) lstyle(foreground))  boxgap(6) ylabel(-1 -0.33 0.33 1 , labsize(small) angle(0)) xsize(2.5) ysize(4)  yscale(noline) legend(off) ytitle("Social Acceptability")

graph export "$path_graphs/Box_Types3EN.png", as(png) replace

clear all
  cd    C:\Users\user\Dropbox\Tesis
global my_path "C:\Users\user\Dropbox\Tesis"
  
global datos  "$my_path\Raw" 
global path_graphs "C:\Users\user\Dropbox\Tesis\graficas"
global path_tables "C:\Users\user\Dropbox\Tesis\tablas"
cd $datos
use datad

recode S1R1D-S5R6D (-1=-3)(-0.33=-1)(0.33=1)(1=3)

order S1R3D, before (S1R4D)
*Media de Aceptación Social Para La Mentira
gen msa_lie = (S1R2D+ S1R3D+ S1R4D+ S1R5D+ S1R6D+ S2R3D + S2R4D + S2R5D+ S2R6D+ S3R4D+ S3R5D+ S3R6D+ S4R5D+ S4R6D+ S5R6D)/15
lab var msa_lie "Mean Social Acceptability of Dishonesty (Injuctives Norms)"


*Media de Aceptación Social Para La Verdad
gen msa_truth = (S1R1D+ S2R2D+ S3R3D+ S4R4D+ S5R5D)/5
lab var msa_truth "Mean Social Acceptability of Honesty (Injuctives Norms) "



cap label define rating2 -3 "very socially unacceptable" -1 "somehow socially unaceptable"  1 "somehow socially acceptable"  3 "Very socially acceptable"  
cap label values S1R1D-S5R6D rating2


local j=0
forvalues n = 1/6 {
    forvalues s=1/5 {
	cap gen d`s'R`n'= S`s'R`n'D/3
}
}

gen truth=msa_truth/3
lab var truth "Truth"
gen lie1= (d1R2 + d2R3 + d3R4 + d4R5 + d5R6)/5
lab var lie1 "1 MU"
gen lie2 = (d1R3 + d2R4 + d3R5 + d4R6)/4
lab var lie2 "2 MU"
gen lie3 = (d1R4 + d2R5 + d3R6 )/3
lab var lie3 "3 MU"
gen lie4 = (d1R5 + d2R6)/2
lab var lie4 "4 MU"
gen lie5 = d1R6
lab var lie5 "5 MU"


gen lie0=truth
reshape long lie, i(code) j(extent)
*label var lie "Social Acceptability"
lab def extent 0 "Truth" 1 "1 MU" 2 "2 MU" 3 "3 MU" 4 "4 MU" 5 "5 MU", replace
lab val extent extent

replace truth=. if extent>0
replace lie=. if extent==0
 
*Generate Box-plots for Top Panel of main Figure 1
graph box truth lie , over(extent, label(angle(45) labsize(small))) over(type, label(labsize(medsmall)) gap(*2.5)) nofill title("Perception of Personal Normative Beliefs") subtitle("for truthfull reporting and different extent of lying") graphregion(color(white)) lintensity(*.3) medtype(cline) medline(lwidth(thick) lcolor(gs1)) intensity(*.1) cwhiskers lines(lwidth(vthin) lpattern(_)) alsize(50) marker(1, msize(medsmall) mcolor(dknavy*.3) mlcolor(none)) box(1, color(dknavy)) marker(2, msize(medsmall) mcolor(maroon*.4) mlcolor(none))  box(2, color(maroon) )  yline(0, axis(1) lstyle(foreground))  boxgap(6) ylabel(-1 -0.33 0.33 1 , labsize(small) angle(0)) xsize(2.5) ysize(4)  yscale(noline) legend(off) ytitle("Social Acceptability")

graph export "$path_graphs/Box_Types4PNB.png", as(png) replace


graph box truth lie if type !=4 , over(extent, label(angle(45) labsize(small))) over(type, label(labsize(medsmall)) gap(*2.5)) nofill title("Perception of Personal Normative Beliefs") subtitle("for truthfull reporting and different extent of lying") graphregion(color(white)) lintensity(*.3) medtype(cline) medline(lwidth(thick) lcolor(gs1)) intensity(*.1) cwhiskers lines(lwidth(vthin) lpattern(_)) alsize(50) marker(1, msize(medsmall) mcolor(dknavy*.3) mlcolor(none)) box(1, color(dknavy)) marker(2, msize(medsmall) mcolor(maroon*.4) mlcolor(none))  box(2, color(maroon) )  yline(0, axis(1) lstyle(foreground))  boxgap(6) ylabel(-1 -0.33 0.33 1 , labsize(small) angle(0)) xsize(2.5) ysize(4)  yscale(noline) legend(off) ytitle("Social Acceptability")

graph export "$path_graphs/Box_Types3PNB.png", as(png) replace
