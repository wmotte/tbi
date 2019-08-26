#!/usr/bin/php
<?php
include 'setup_registration.php';

##################################

####
# Function to extract T1 pre-bbb and post-bbb images
##
function ExtractT1( $indir, $outdir, $subject )
{
    echo "*** Extract 5 T1 volumes from both pre- and post-measurement for rat: $subject \n";

	// make outdir if not exists
	if( !is_dir( $outdir) )
		mkdir( $outdir, 0755, true );

    	// construct relevant parameters for bet.sh input
    	$input_pre = "$indir/bbb_pre.nii.gz";
	$input_post = "$indir/bbb_post.nii.gz";
    	$output_pre = "$outdir/bbb_pre_extract.nii.gz";
	$output_post = "$outdir/bbb_post_extract.nii.gz";
	
	// perform bet with bet.sh script
    {
        system( "fslroi $input_pre $output_pre 0 5" );
	system( "fslroi $input_post $output_post 27 5" );
    }
}
##################################

## Loop over all rats
foreach( $rats as $subject )
{  
        $indir = "$niidir/$subject";
	$outdir = "$outputdir/$subject";

        if( is_dir( $indir ) )
            ExtractT1( $indir, $outdir, $subject );
}


?>
