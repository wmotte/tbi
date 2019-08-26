#!/usr/bin/php
<?php
include 'setup_registration.php';

##################################


####
# Make images to check the T1 BETs.
##
function BETimages ( $indir, $outputdir, $subject )
{
    echo "*** Make T1 images to check BET: $subject \n";

    // inputs
    $bet = "$outputdir/$subject/bet.nii.gz";
    $bias = "$outputdir/$subject/bias.nii.gz";

    // output
    $outdir = "$outputdir/bet_checks/";
	
	// make outdir if not exists
	if( !is_dir( $outdir) )
		mkdir( $outdir, 0755, true );

    $outputbet = "$outdir/$subject"."_b_bet.png";
    $outputbias = "$outdir/$subject"."_a_bias.png";
  
    ## Make color maps of all images
    {
       system("colormap -b $bias --nm  -c 4 --ss 38 --se 100 --sk 3 -scale 3 --min 0 --max 0.2 -d 1 -o $outputbias");
        system("colormap -b $bet ---nm -c 4 --ss 38 --se 100 --sk 3 -scale 3 --min 0 --max 0.2 -d 1 -o $outputbet");
        
    }
      
    

}
##################################

## Loop over all rats
foreach( $rats as $subject )
{  
        $indir = "$niidir/$subject";
        $workingdir = "$workingdir";

        if( is_dir( $indir ) )
            BETimages( $indir, $outputdir, $subject );
}


?>
