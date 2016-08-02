**************************;
*prepare-haasa-dataset.sas;
**************************;

/*

This program is used to prepare a CSV dataset for use on the National Sleep Research Resource

*/

*set library and options;
libname haasa "\\rfa01\bwh-sleepepi-home\projects\src\honolulu\nsrr-prep\_datasets";
options nofmterr;

*create macro date variables;
data _null_;
  call symput("datetoday",put("&sysdate"d,mmddyy8.));
  call symput("date6",put("&sysdate"d,mmddyy6.));
  call symput("date10",put("&sysdate"d,mmddyy10.));
  call symput("filedate",put("&sysdate"d,yymmdd10.));
  call symput("sasfiledate",put(year("&sysdate"d),4.)||put(month("&sysdate"d),z2.)||put(day("&sysdate"d),z2.));
run;

*set latest version number and releases folder;
%let version = 0.1.0.beta1;
%let releases_folder = \\rfa01\bwh-sleepepi-home\projects\src\honolulu\nsrr-prep\_releases;

*create 'haasa_nsrr' dataset from source dataset sent by coordinating center;
data haasa_nsrr;
  set haasa.haasa_dcc;

  *create exam variable;
  exam = 7;
run;

*create permanent sas dataset;
data haasa.haasa_nsrr_&sasfiledate;
  set haasa_nsrr;
run;

*export csv dataset;
proc export data=haasa_nsrr
  outfile="&releases_folder\&version\haasa_nsrr_&version..csv"
  dbms=csv
  replace;
run;
