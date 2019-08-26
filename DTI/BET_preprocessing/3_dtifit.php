#!/usr/bin/php
<?php
include 'setup_registration.php';

##################################

####
# Function to perform DTIFIT on all DWI rat brain scans
##
function DTIFIT( $datadir, $indir, $outdir, $subject )
{
    echo "*** Perform DTIFIT on rat: $subject \n";

	// make outdir if not exists
	if( !is_dir( $outdir) )
		mkdir( $outdir, 0755, true );

    	// construct relevant parameters to perform DTIFIT
    	$data = "$datadir/dtitot.nii.gz";
    	$output = "$outdir/dti";
	$mask = "$indir/mask_adjusted.nii.gz";
	$bvecs = "$indir/bvecs_fsl";
	$bvals = "$indir/bvals";
	
	// perform DTIFIT with defined parameters
    {
        system( "dtifit -k $data -o $output -m $mask -r $bvecs -b $bvals" );
    }
}
##################################

## Loop over all rats
foreach( $rats as $subject )
{  
	$datadir = "$niidir/$subject";        
	$indir = "$outputdir/$subject";
	$outdir = "$outputdir/$subject/dtifit";

        if( is_dir( $indir ) )
            DTIFIT( $datadir, $indir, $outdir, $subject );
}


?>
