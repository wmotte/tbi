#!/usr/bin/php
<?php
include 'setup_registration.php';

##################################

####
# Warp the TBI ROIs reference image to subject T2 image. 
##
foreach( $rats as $subject )
{  

$warp = "$outputdir/$subject/regs/ref2T2_nonl.coef.nii.gz";
$input = "/home1/michel/projects/TBI/atlas/hippocampus.nii.gz";
$output = "$outputdir/$subject/regs/Hipp2T2.nii.gz";
$ref = "$outputdir/$subject/bet_adjusted.nii.gz";
$mask = "$outputdir/$subject/mask_adjusted.nii.gz";

        print "Apply warp from Atlas (rois) in standard space to subject T2 for Rat: $subject \n";

        // check if directory exists, otherwise make one
        if( (!file_exists( "$outputdir/$subject/regs/Hipp2T2.nii.gz" ) ) | true )
            
            system( "applywarp -i $input --interp=nn -o $output -m $mask -r $ref -w $warp " );

}

?>
