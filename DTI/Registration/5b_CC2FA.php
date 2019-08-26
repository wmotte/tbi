#!/usr/bin/php
<?php
include 'setup_registration.php';

##################################


####
# Register corpus callosum (CC) ROI to subject FA.
##
function registerCC( $indir, $subject )
{
    echo "*** Register CC ROI to subject FA map of subject: $subject \n";

    // input with masks
    $in = "$indir/dtifit/dti_FA.nii.gz";
    $ref = "$indir/mask_adjusted.nii.gz";
    $cc = "/home1/michel/projects/TBI/atlas/CC_roi_adjusted.nii.gz";

    $aff = "$indir/regs/FA2ref_aff.mat";
    $config = "/home1/michel/projects/TBI/reference/fnirt.config";

    // output
    $outdir = "$indir/regs/";
    
    if(!is_dir($outdir))
        {
        echo "Creating '$outdir'...\n";
        mkdir($outdir);        
        }
   
    // apply invert warp on whole-brain wm
    $out_cc = "$outdir/CC2FA_nonl.nii.gz";
    $coef_inv = "$outdir/ref2FA_nonl.coef.nii.gz";

    if( file_exists( $ref ) && file_exists( $cc ) && file_exists( $coef_inv ) )
    {
        system( "applywarp -w $coef_inv -r $ref -i $cc --interp=nn -o $out_cc" );
    }
}
##################################


foreach( $rats as $subject )
{  
        $indir = "$outputdir/$subject";

        if( is_dir( $indir ) )
            registerCC( $indir, $subject );
}



?>
