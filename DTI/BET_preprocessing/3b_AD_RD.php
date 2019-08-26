#!/usr/bin/php
<?php
include 'setup_registration.php';

##################################

####
# Function to calculate AD and RD maps
##
function ADRD( $outdir, $subject )
{
    echo "*** Calculate AD and RD maps for rat: $subject \n";

	// make outdir if not exists
	if( !is_dir( $outdir) )
		mkdir( $outdir, 0755, true );

    	// define all input images to calculate AD and RD
    	$L1 = "$outdir/dti_L1.nii.gz";
	$L2 = "$outdir/dti_L2.nii.gz";
	$L3 = "$outdir/dti_L3.nii.gz";

	// define all output images
	$AD = "$outdir/dti_AD.nii.gz";
	$RD = "$outdir/dti_RD.nii.gz";
	
	// calculate AD and RD maps
    {
        system("cp $L1 $AD");
        
        system("fslmaths $L2 -add $L3 -div 2 $RD");

    }
}
##################################

## Loop over all rats
foreach( $rats as $subject )
{  
	
	$outdir = "$outputdir/$subject/dtifit";

        if( is_dir( $outdir ) )
            ADRD( $outdir, $subject );
}


?>
