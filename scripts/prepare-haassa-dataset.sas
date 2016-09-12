**************************;
*prepare-haassa-dataset.sas;
**************************;

/*

This program is used to prepare a CSV dataset for use on the National Sleep Research Resource

*/

*set library and options;
libname haassa "\\rfa01\bwh-sleepepi-home\projects\src\honolulu\nsrr-prep\_datasets";
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
%let version = 0.1.0;
%let releases_folder = \\rfa01\bwh-sleepepi-home\projects\src\honolulu\nsrr-prep\_releases;

*create 'haassa_nsrr' dataset from source dataset sent by coordinating center;
data haassa_nsrr;
  set haassa.haassa_dcc;

  *create exam variable;
  exam = 7;
run;

*create permanent sas dataset;
data haassa.haassa_nsrr_&sasfiledate;
  set haassa_nsrr;
run;

*export csv dataset;
proc export data=haassa_nsrr
  outfile="&releases_folder\&version\haassa-dataset-&version..csv"
  dbms=csv
  replace;
run;
