#!/usr/bin/php

<?php
include 'setup_registration.php';

####
# Make T1 Images to check the registrations of the average T2 reference to subject space.
##
function T1images ( $indir, $subject, $outputdir )
{
    echo "*** Make T1 images to check T1 registration: $indir \n";

    // inputs
    $reg = "$indir/regs/ref2T1_nonl.nii.gz";
    $ref = "$indir/bet_adjusted.nii.gz";

    // output
    $outdir = "$outputdir/regchecks/";

	if(!is_dir($outdir))
        {
        echo "Creating '$outdir'...\n";
        mkdir($outdir);        
        }

    $outputref = "$outdir/$subject"."_refT1.png";
    $outputreg = "$outdir/$subject"."_registration.png";
  
       
    {

	system("colormap -b $reg --nm  -c 4 --ss 38 --se 100 --sk 3 -scale 3 --min 0 --max 0.2 -d 1 -o $outputreg");
        system("colormap -b $ref --nm  -c 4 --ss 38 --se 100 --sk 3 -scale 3 --min 0 --max 0.2 -d 1 -o $outputref");       
	        
    }
      
    

}
##################################


foreach( $rats as $subject )
{  
        $indir = "$outputdir/$subject";
	$outputdir = $outputdir;

        if( is_dir( $indir ) )
            T1images( $indir, $subject, $outputdir );
}


?>
