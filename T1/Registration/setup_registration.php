#!/usr/bin/php
<?php
# SETUP FILE with main file features to loop over all files
$studies = array( "qs", "tbi", "tbi1" );
$subjects = array( "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28");
$times = array( "pre", "00h", "24h", "01w", "01m", "03m", "04m" );

## Datadir and refdir
$maindir = "/home1/michel/projects/TBI/processed/";
$niidir = "/home1/michel/projects/TBI/data/T1/";
$outputdir = "/home1/michel/projects/TBI/processed/T1/";
$refdir = "/home1/michel/projects/TBI/processed/T1/brainmask/";

## Define all rats and put them in an array called $rats
$rats = [];

foreach($studies as $study) {
  foreach($subjects as $subject) {
    foreach($times as $time) {

	$file = "$niidir/$study$subject"."_"."$time";
	$id = "$study$subject"."_"."$time";

	if ( file_exists($file) )
		{ $rats[] = "$study$subject"."_"."$time"; }


		}
	}
}



?>
