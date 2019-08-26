#!/usr/bin/php
<?php
include 'setup_registration.php';

##################################

####
# Function to calculate mean T1 image
##
function MeanT1( $indir, $outdir, $subject )
{
    echo "*** Calculate average T1 based on pre-measurement for rat: $subject \n";

	// make outdir if not exists
	if( !is_dir( $outdir) )
		mkdir( $outdir, 0755, true );

    	// construct relevant parameters for bet.sh input
    	$input = "$indir/bbb_pre.nii.gz";
    	$output = "$outdir/mean_bbb_pre.nii.gz";
	
	// perform bet with bet.sh script
    {
        system( "fslmaths $input -Tmean $output" );
    }
}
##################################

## Loop over all rats
foreach( $rats as $subject )
{  
        $indir = "$niidir/$subject";
	$outdir = "$outputdir/$subject";

        if( is_dir( $indir ) )
            MeanT1( $indir, $outdir, $subject );
}


?>
