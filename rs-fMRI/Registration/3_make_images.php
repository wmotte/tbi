#!/usr/bin/php

<?php
include 'setup_registration.php';

##################################


####
# Make FMRI Images to check the registrations of the average rs-fMRI reference to subject space.
##
function FMRIimages ( $indir, $subject, $outputdir )
{
    echo "*** Make FMRI images to check rs-fMRI registration: $indir \n";

    // inputs
    $reg = "$indir/regs/ref2rsfmri_nonl.nii.gz";
    $ref = "$indir/bet_adjusted.nii.gz";

    // output
    $outdir = "$outputdir/regchecks/";

	if(!is_dir($outdir))
        {
        echo "Creating '$outdir'...\n";
        mkdir($outdir);        
        }

    $outputref = "$outdir/$subject"."_reffmri.png";
    $outputreg = "$outdir/$subject"."_registration.png";
  
       
    {

	system("colormap -b $reg --nm  -c 4 --ss 10 --se 52 --sk 4 -d 1 --scale 4 -o $outputreg");
        system("colormap -b $ref ---nm -c 4 --ss 10 --se 52 --sk 4 -d 1 --scale 4 -o $outputref");       
	        
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
