#!/usr/bin/php
<?php
include 'setup_registration.php';

##################################


####
# Make BET Images to check the adjusted BETs.
##
function BETimages ( $indir, $outputdir, $subject )
{
    echo "*** Make rs-fMRI + brain extraction images to check BET: $subject \n";

    // inputs
    $bet = "$outputdir/$subject/bet.nii.gz";
    $n3 = "$outputdir/$subject/MCoutput/rs-fmri-mean-N3.nii.gz";

    // output
    $outdir = "$outputdir/bet_checks/";
	
	// make outdir if not exists
	if( !is_dir( $outdir) )
		mkdir( $outdir, 0755, true );

    $outputbet = "$outdir/$subject"."_bet.png";
    $outputn3 = "$outdir/$subject"."_all.png";
  
    ## Make color maps of all images
    {
       system("colormap -b $n3 --nm  -c 4 --ss 10 --se 52 --sk 4 -d 1 --scale 4 -o $outputn3");
        system("colormap -b $bet ---nm -c 4 --ss 10 --se 52 --sk 4 -d 1 --scale 4 -o $outputbet");
        
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
