#!/usr/bin/php

<?php
include 'rs-fmri-setup.php';

##################################


########### CHECK FILTERED DATA BY MAKING IMAGES #########
####
# Make images to check the AFNI filtered images.
##
function AFNIimages ( $indir, $outputdir, $subject, $processdir )
{
    echo "*** Make images to check MC-regressed and AFNI filtered images for: $subject \n";

    // inputs
	$mc = "$outputdir/$subject/fc/rs-fmri-mc-regressed-TR-correct.nii.gz";    	
	$AFNI = "$outputdir/$subject/fc/rs-fmri-afni-filtered-0.01-0.1-mc-regressed.nii.gz";
	$AFNI2 = "$outputdir/$subject/fc-alt/rs-fmri-afni-filtered-0.01-0.06-mc-regressed.nii.gz";

    // output
    $outdir = "$processdir/AFNI_filtering_checks/";
	
	// make outdir if not exists
	if( !is_dir( $outdir) )
		mkdir( $outdir, 0755, true );

    	$output_mc = "$outdir/$subject"."_1-mc-regressed.png";
    	$output_AFNI = "$outdir/$subject"."_2-AFNI.png";
	$output_AFNI2 = "$outdir/$subject"."_3-AFNI-alternative.png";
  
    ## Make color maps of all images
    {
       system("colormap -b $mc --nm  -c 5 --ss 10 --se 52 --sk 2 -d 1 --scale 4 -o $output_mc");
        system("colormap -b $AFNI ---nm -c 5 --ss 10 --se 52 --sk 2 -d 1 --scale 4 -o $output_AFNI");
	system("colormap -b $AFNI2 --nm  -c 5 --ss 10 --se 52 --sk 2 -d 1 --scale 4 -o $output_AFNI2");
        
    }
      
    

}
##################################

## Loop over all rats
foreach( $rats as $subject )
{  
        $indir = "$niidir/$subject";
        $workingdir = "$workingdir";

        if( is_dir( $indir ) )
            AFNIimages( $indir, $outputdir, $subject, $processdir );
}




?>
