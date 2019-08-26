#!/usr/bin/php
<?php
include 'setup_registration.php';

##################################

####
# Function to perform brain extraction on all rats.
##
function T2Bet( $indir, $outdir, $subject )
{
    echo "*** Perform BET on rat T2 image: $subject \n";

	// make outdir if not exists
	if( !is_dir( $outdir) )
		mkdir( $outdir, 0755, true );

    	// construct relevant parameters for bet.sh input
    	$input = "$outdir/mean_te_array.nii.gz";
    	$bias = "$outdir/bias.nii.gz";
	$bet = "$outdir/bet.nii.gz";
	$mask = "$outdir/mask.nii.gz";
	$fractional = 0.75;
	$radius = 93;
	
	// perform bet with bet.sh script
    {
        system( "./bet-t2.sh $input $bias $bet $mask $radius $fractional" );
    }
}
##################################

## Loop over all rats
foreach( $rats as $subject )
{  
        $indir = "$niidir/$subject";
	$outdir = "$outputdir/$subject";

        if( is_dir( $indir ) )
            T2Bet( $indir, $outdir, $subject );
}


?>
