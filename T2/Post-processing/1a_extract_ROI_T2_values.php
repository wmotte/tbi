#!/usr/bin/php
<?php
include 'setup_registration.php';

##################################

####
# Function to extract T2 values of ROIs
##
function ROIvals( $indir, $outdir, $subject )
{
    echo "*** Calculate mean T2 for ROIs of rat: $subject \n";

	// make outdir if not exists
	if( !is_dir( "$outdir"."/ROI_values/") )
		mkdir( "$outdir"."/ROI_values/", 0755, true );

    	// define all relevant input and output files
	$T2map = "$indir/t2.nii.gz";    	
	$T2out = "$outdir/ROI_values/t2values.txt";
	$labels = "$outdir/regs/rois2T2.nii.gz";
	$Mask = "$outdir/mask_adjusted.nii.gz";
	
	// extract all values
    {
        
        system("fslmeants -i $T2map -o $T2out -m $Mask --label=$labels");

    }
}
##################################

## Loop over all rats
foreach( $rats as $subject )
{  
	
	$indir = "$niidir/$subject/";
	$outdir = "$outputdir/$subject/";

        if( is_dir( $indir ) )
            ROIvals( $indir, $outdir, $subject );
}


?>
