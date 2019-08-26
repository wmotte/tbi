#!/usr/bin/php
<?php
include 'setup_registration.php';

##################################


####
# Make images to check the warped ROIs in subject space.
##
function REGimages ( $indir, $outputdir, $subject )
{
    echo "*** Make rs-fMRI and ROI images in subject space to check registration: $subject \n";

    // inputs
    $rois = "$outputdir/$subject/regs/rois2rs-fmri.nii.gz";
    $brain = "$outputdir/$subject/bet_adjusted.nii.gz";

    // output
    $outdir = "$outputdir/TBI_rois_checks/";
	
	// make outdir if not exists
	if( !is_dir( $outdir) )
		mkdir( $outdir, 0755, true );

    $outputrois = "$outdir/$subject"."_rois.png";
    $outputbrain = "$outdir/$subject"."_brain.png";
  
       
    {
       system("colormap -b $brain --nm  -c 4 --ss 20 --se 40 --sk 2 --sf 4 -d 1 -o $outputbrain");
        system(" colormap -b $brain -i $rois --int 0 -l "."colorcube"." --nm -c 4 --ss 20 --se 40 --sk 2 --sf 4 -d 1 -o $outputrois");
        
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
