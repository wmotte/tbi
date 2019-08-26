#!/usr/bin/php
<?php
include 'setup_registration.php';

##################################

####
# Function to perform brain extraction on all anatomical rat brain scans.
##
function AnatomicalBet( $indir, $outdir, $subject )
{
    echo "*** Perform BET on rat: $subject \n";

	// make outdir if not exists
	if( !is_dir( $outdir) )
		mkdir( $outdir, 0755, true );

    	// construct relevant parameters for bet.sh input
    	$input = "$indir/bssfp.nii.gz";
    	$bias = "$outdir/bias.nii.gz";
	$bet = "$outdir/bet.nii.gz";
	$mask = "$outdir/mask.nii.gz";
	$fractional = 0.65;
	$radius = 93;
	
	// perform bet with bet.sh script
    {
        system( "./bet.sh $input $bias $bet $mask $radius $fractional" );
    }
}
##################################

## Loop over all rats
foreach( $rats as $subject )
{  
        $indir = "$niidir/$subject";
	$outdir = "$outputdir/$subject";

        if( is_dir( $indir ) )
            AnatomicalBet( $indir, $outdir, $subject );
}


?>
