#!/usr/bin/php

<?php
include 'setup_registration.php';

##################################


####
# Make T2 images to check the adjusted BETs.
##
function T2images ( $indir, $subject, $outputdir )
{
    echo "*** Make T2 images to check adjusted BET: $indir \n";

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
    $outputbet = "$outdir/$subject"."_bias.png";
  
       
    {
       system("colormap -b $bet --nm -c 4 --ss 25 --se 80 --sk 3 -scale 3 -d 1 -o $outputbet");
        system("colormap -b $bet2 --nm -c 4 --ss 25 --se 80 --sk 3 -scale 3  -d 1 -o $outputbet2");
        
    }
      
    

}
##################################


foreach( $rats as $subject )
{  
        $indir = "$outputdir/$subject";
	$outputdir = $outputdir;

        if( is_dir( $indir ) )
            T2images( $indir, $subject, $outputdir );
}


?>
