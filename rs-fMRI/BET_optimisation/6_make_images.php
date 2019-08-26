#!/usr/bin/php

<?php
include 'setup_registration.php';

##################################


####
# Make FMRI Images to check the adjusted BETs.
##
function FMRIimages ( $indir, $subject, $outputdir )
{
    echo "*** Make FMRI images to check adjusted BET: $indir \n";

    // inputs
    $bet2 = "$indir/bet_adjusted.nii.gz";
    $bet = "$indir/bet.nii.gz";

    // output
    $outdir = "$outputdir/brainmask/checks/";

	if(!is_dir($outdir))
        {
        echo "Creating '$outdir'...\n";
        mkdir($outdir);        
        }

    $outputbet2 = "$outdir/$subject"."_newbet.png";
    $outputbet = "$outdir/$subject"."_bet.png";
  
       
    {

	system("colormap -b $bet --nm  -c 4 --ss 10 --se 52 --sk 4 -d 1 --scale 4 -o $outputbet");
        system("colormap -b $bet2 ---nm -c 4 --ss 10 --se 52 --sk 4 -d 1 --scale 4 -o $outputbet2");       
	        
    }
      
    

}
##################################


foreach( $rats as $subject )
{  
        $indir = "$outputdir/$subject";
	$outputdir = $outputdir;

        if( is_dir( $indir ) )
            FMRIimages( $indir, $subject, $outputdir );
}


?>
