#!/usr/bin/php

<?php
include 'rs-fmri-setup.php';

##################################


########### CHECK FC MAPS BY MAKING IMAGES #########
####
# Make images to check the FC maps.
##
function FCimages ( $indir, $outputdir, $subject, $processdir )
{
    echo "*** Make images to check MC-regressed and AFNI filtered images for: $subject \n";

    // inputs
	$FC = "$outputdir/$subject/fc/fcmap_AFNI_filtered_mc_regressed.nii.gz";
	$FC2 = "$outputdir/$subject/fc-alt/fcmap_AFNI_filtered_mc_regressed.nii.gz";

    // output
    $outdir = "$processdir/FC-maps_checks_z-direction/";
	
	// make outdir if not exists
	if( !is_dir( $outdir) )
		mkdir( $outdir, 0755, true );

    	$output_FC = "$outdir/$subject"."_1-FC.png";
	$output_FC2 = "$outdir/$subject"."_2-FC-alternative.png";
  
    ## Make color maps of all images
    {
        system("colormap -b $FC ---nm -c 5 --ss 10 --se 22 --sk 1 -d 2 --scale 4 -o $output_FC");
	system("colormap -b $FC2 --nm  -c 5 --ss 10 --se 22 --sk 1 -d 2 --scale 4 -o $output_FC2");
        
    }
      
    

}
##################################

## Loop over all rats
foreach( $rats as $subject )
{  
        $indir = "$niidir/$subject";
        $workingdir = "$workingdir";

        if( is_dir( $indir ) )
            FCimages( $indir, $outputdir, $subject, $processdir );
}




?>
