#!/usr/bin/php
<?php
include 'setup_registration.php';

##################################

####
# Function to extract T1 pre-bbb and post-bbb images
##
function RatioT1( $indir, $outdir, $subject )
{
    echo "*** Determine average for and ratio between pre- and post-measurement for rat: $subject \n";

	// make outdir if not exists
	if( !is_dir( "$outdir/ratio/" ) )
		mkdir( "$outdir/ratio/", 0755, true );

    	// construct relevant parameters for bet.sh input
    	$input_pre = "$outdir/bbb_pre_extract.nii.gz";
	$input_post = "$outdir/bbb_post_extract.nii.gz";
	$average_pre = "$outdir/ratio/average_bbb_pre.nii.gz";
	$average_post = "$outdir/ratio/average_bbb_post.nii.gz";
	$ratio = "$outdir/ratio/bbb_ratio.nii.gz";
	
	
	// perform bet with bet.sh script
    {
        system( "fslmaths $input_pre -Tmean $average_pre" );
	 system( "fslmaths $input_post -Tmean $average_post" );
	system( "fslmaths $average_post -sub $average_pre -div $average_pre -mul 100 $ratio" );
    }
}
##################################

## Loop over all rats
foreach( $rats as $subject )
{  
        $indir = "$niidir/$subject";
	$outdir = "$outputdir/$subject";

        if( is_dir( $indir ) )
            RatioT1( $indir, $outdir, $subject );
}


?>
