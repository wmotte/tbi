#!/usr/bin/php
<?php
include 'setup_registration.php';

##################################

####
# Function to extract T1 values of CC ROI
##
function ROIvals( $indir, $outdir, $subject )
{
    echo "*** Calculate mean T1 for CC of rat: $subject \n";

	// make outdir if not exists
	if( !is_dir( "$outdir"."/ROI_values/") )
		mkdir( "$outdir"."/ROI_values/", 0755, true );

    	// define all relevant input and output files
	$T1map = "$outdir/ratio/bbb_ratio.nii.gz";    	
	$T1out = "$outdir/ROI_values/CC-t1values.txt";
	$labels = "$outdir/regs/CC2T1.nii.gz";
	$Mask = "$outdir/mask_adjusted.nii.gz";
	
	// extract all values
    {
        
        system("fslmeants -i $T1map -o $T1out -m $Mask --label=$labels");

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
