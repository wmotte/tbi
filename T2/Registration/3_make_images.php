#!/usr/bin/php

<?php
include 'setup_registration.php';

##################################


####
# Make T2 Images to check the registrations of the average T2 reference to subject space.
##
function T2images ( $indir, $subject, $outputdir )
{
    echo "*** Make T2 images to check T2 registration: $indir \n";

    // inputs
    $reg = "$indir/regs/ref2T2_nonl.nii.gz";
    $ref = "$indir/bet_adjusted.nii.gz";

    // output
    $outdir = "$outputdir/regchecks/";

	if(!is_dir($outdir))
        {
        echo "Creating '$outdir'...\n";
        mkdir($outdir);        
        }

    $outputref = "$outdir/$subject"."_refT2.png";
    $outputreg = "$outdir/$subject"."_registration.png";
  
       
    {

	system("colormap -b $reg --nm  -c 4 --ss 25 --se 80 --sk 3 -d 1 --scale 3 -o $outputreg");
        system("colormap -b $ref ---nm -c 4 --ss 25 --se 80 --sk 3 -d 1 --scale 3 -o $outputref");       
	        
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
