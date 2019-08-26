#!/usr/bin/php
<?php
include 'setup_registration.php';

####
# Make images to check the warped ROIs in subject space.
##
function REGimages ( $indir, $outputdir, $subject )
{
    echo "*** Make T1 and ROI images in subject space to check registration: $subject \n";

    // inputs
    $rois = "$outputdir/$subject/regs/rois2T1.nii.gz";
    $brain = "$outputdir/$subject/bet_adjusted.nii.gz";

    // output
    $outdir = "$outputdir/TBI_rois_checks/";
	
	// make outdir if not exists
	if( !is_dir( $outdir) )
		mkdir( $outdir, 0755, true );

    $outputrois = "$outdir/$subject"."_rois.png";
    $outputbrain = "$outdir/$subject"."_brain.png";
  
       
    {
       system("colormap -b $brain --nm -c 4 --ss 38 --se 100 --sk 3 --sf 4 -scale 3 --min 0 --max 0.2 -d 1 -o $outputbrain");
        system(" colormap -b $brain -i $rois --int 0 -l "."colorcube"." --nm -c 4 --ss 38 --se 100 --sk 3 --sf 4 -scale 3 --min 0 --max 0.2 -d 1 -o $outputrois");
        
    }
      
    

}
##################################

## Loop over all rats
foreach( $rats as $subject )
{  
        $indir = "$niidir/$subject";
        $workingdir = "$workingdir";

        if( is_dir( $indir ) )
            REGimages( $indir, $outputdir, $subject );
}


?>
