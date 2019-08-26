#!/usr/bin/php
<?php
include 'setup_registration.php';

##################################

####
# Function to perform brain extraction on all rats.
##
function rsfMRIBet( $indir, $outdir, $subject )
{
    echo "*** Perform BET on rat rs-fMRI: $subject \n";

	// make outdir if not exists
	if( !is_dir( $outdir) )
		mkdir( $outdir, 0755, true );

    	// construct relevant parameters for bet.sh input
    	$input = "$indir/rs-fmri-mean-N3.nii.gz";
	$bet = "$outdir/bet.nii.gz";
	$mask = "$outdir/mask.nii.gz";
	$fractional = 0.75;
	$radius = 90;
	
	// perform bet with bet.sh script
    {
        system( "./bet-fmri.sh $input $bet $mask $radius $fractional" );
    }
}
##################################

## Loop over all rats
foreach( $rats as $subject )
{  
        $indir = "$outputdir/$subject/MCoutput/";
	$outdir = "$outputdir/$subject";

        if( is_dir( $indir ) )
            rsfMRIBet( $indir, $outdir, $subject );
}


?>
