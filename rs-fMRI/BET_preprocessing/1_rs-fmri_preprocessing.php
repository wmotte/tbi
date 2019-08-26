#!/usr/bin/php
<?php
include 'setup_registration.php';

##################################

####
# Function to perform preprocessing (extract volumes, motion correction, N3 bias field correction)  on all rats.
##
function rsfMRIpreprocess( $indir, $outdir, $subject )
{
    echo "*** Preprocessing on rat rs-fMRI: $subject \n";

	// make outdir if not exists
	if( !is_dir( $outdir) )
		mkdir( $outdir, 0755, true );

	// make motion correction outdir if not exists
	if( !is_dir( "$outdir/MCoutput/") )
		mkdir( "$outdir/MCoutput/", 0755, true );

    	// construct relevant input and output parameters for preprocessing
	// input file    	
	$input = "$indir/3dge600_waxholm.nii.gz";
	
	// motion correction output file
	$mc_output = "$outdir/MCoutput/rs-fmri-mc";

	// average motion corrected rs-fMRI image
	$mean = "$outdir/MCoutput/rs-fmri-mean.nii.gz";
	
	// N3 corrected aveage image
	$mean_N3 = "$outdir/MCoutput/rs-fmri-mean-N3.nii.gz";
	
	

	// Perform motion correction on extract
	{
	system( "mcflirt -in $input -out $mc_output -spline_final -meanvol -stats -plots -report" );
	}	

	// Calculate mean fMRI image over all volumes
	{
	system( "fslmaths $mc_output -Tmean $mean" );
	}

	// Apply N3 inhomogeneity correction
	{
	system( "n3 --fwhm 15 --shrink-factor 4 4 2 -i $mean -o $mean_N3" );
	}

}
##################################

## Loop over all rats
foreach( $rats as $subject )
{  
        $indir = "$niidir/$subject";
	$outdir = "$outputdir/$subject";

        if( is_dir( $indir ) )
            rsfMRIpreprocess( $indir, $outdir, $subject );
}


?>
