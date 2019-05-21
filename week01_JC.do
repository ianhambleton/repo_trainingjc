** HEADER -----------------------------------------------------
**  DO-FILE METADATA
//  algorithm name			    week01_JC.do
//  project:				    Stata Training
//  analysts:					Jacqueline CAMPBELL
//	date last modified	        17-Sep-2018
//  algorithm task			    Collapse and Reshape

** General algorithm set-up
version 15
clear all
macro drop _all
set more 1
set linesize 80

** Set working directories: this is for DATASET and LOGFILE import and export
** DATASETS to encrypted SharePoint folder
local datapath "X:\The University of the West Indies\DataGroup - repo_data\data_statatraining"
** Sharepoint is not allowing me to sync to "X:\The University of the West Indies\DataGroup - repo_data\data_statatraining"
** LOGFILES to unencrypted OneDrive folder
local logpath "X:\OneDrive - The University of the West Indies\repo_datagroup\repo_statatraining"
** Sharepoint is not allowing me to sync to "X:\OneDrive - The University of the West Indies\repo_datagroup\repo_statatraining"


** Close any open log file and open a new log file
capture log close
cap log using "`logpath'\week01_JC", replace
** HEADER -----------------------------------------------------


** Load dataset
use "`datapath'\dataset01_meteorology.dta", clear

** Create year of measurement, month of measurement, day of measurement to match variables in instructions
gen yom=year(dov)
gen mon=month(dov)
gen dom=day(dov)
gen qtr=quarter(dov)
gen wk=week(dov)

** Create variables for quarterly, monthly, weekly based on date of measurement
gen dovqtr=yq(yom, qtr)
format dovqtr %tq
gen dovmon=ym(yom, mon)
format dovmon %tm
gen dovwk=yw(yom, wk)
format dovwk %tw

** CREATE SEPARATE DATASETS FOR EACH USING COLLAPSE THEN USE THESE DATASETS TO CREATE GRAPHS WITH yaxis(1) xaxis(5) so you can long graph
** Table & Graph 1: rainfall between 2000 and 2013 by quarter-years
total value if measure==5 & (yom>1999 & yom<2014)
tab dovqtr , summarize(value)
//list dovqtr value if measure==5 & (yom>1999 & yom<2014)

** Bar Graph
preserve
drop if measure!=5 & (yom>1999 & yom<2014)
collapse (sum) value, by(dovqtr) cw
tab dovqtr, summarize(value)
#delimit ;
twoway (line value dovqtr), xlabel(#42, labsize(vsmall) angle(forty_five))
name(figure1, replace)
;
restore

** Line Graph
preserve
drop if measure!=5
collapse (sum) value, by (yom qtr)
#delimit;
twoway	(line value qtr if yom==2003, sort lcolor(mint))
		(line value qtr if yom==2004, sort lcolor(cyan))
		(line value qtr if yom==2005, sort lcolor(red))
		(line value qtr if yom==2006, sort lcolor(purple))
		(line value qtr if yom==2007, sort lcolor(yellow))
		(line value qtr if yom==2008, sort lcolor(orange))
		(line value qtr if yom==2009, sort lcolor(pink))
		(line value qtr if yom==2010, sort lcolor(black))
		(line value qtr if yom==2011, sort lcolor(blue))
		(line value qtr if yom==2012, sort lcolor(lime))
		(line value qtr if yom==2013, sort lcolor(green)), 
		text(80 2.2 "2003")
		text(440 2.6 "2004")
		text(585 4 "2005")
		text(280 3 "2006")
		text(455 3.75 "2007")
		text(570 3.45 "2008")
		text(200 4 "2009")
		text(695 4 "2010")
		text(510 4 "2011")
		text(320 4 "2012")
		text(30 4 "2013") ylabel(#4)
		legend(cols(4)
		lab(1 "2003")
		lab(2 "2004")
		lab(3 "2005")
		lab(4 "2006")
		lab(5 "2007")
		lab(6 "2008")
		lab(7 "2009")
		lab(8 "2010")
		lab(9 "2011")
		lab(10 "2012")
		lab(11 "2013")
		)
		name(graph1, replace)
;
restore

** Table & Graph 2: rainfall between 2000 and 2013 by quarter-years
total value if measure==5 & (yom>1999 & yom<2014)
tab dovmon , summarize(value)
//list dovmon value if measure==5 & (yom>1999 & yom<2014)
preserve
drop if measure!=5 & (yom>1999 & yom<2014)
collapse (sum) value, by(dovmon) cw
tab dovmon, summarize(value)
#delimit ;
twoway (line value dovmon, sort), xlabel(#11, labsize(vsmall) angle(forty_five))
name(figure2, replace)
;
restore
