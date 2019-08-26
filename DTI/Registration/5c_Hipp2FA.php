#!/usr/bin/php
<?php
include 'setup_registration.php';

##################################


####
# Register new hippocampus ROI to subject FA.
##
function registerHipp( $indir, $subject )
{
    echo "*** Register Hippocampus ROI to subject FA map of subject: $subject \n";

    // input with masks
    $in = "$indir/dtifit/dti_FA.nii.gz";
    $ref = "$indir/mask_adjusted.nii.gz";
    $hipp = "/home1/michel/projects/TBI/atlas/hippocampus.nii.gz";

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
    $out_hipp = "$outdir/Hipp2FA_nonl.nii.gz";
    $coef_inv = "$outdir/ref2FA_nonl.coef.nii.gz";

    if( file_exists( $ref ) && file_exists( $hipp ) && file_exists( $coef_inv ) )
    {
        system( "applywarp -w $coef_inv -r $ref -i $hipp --interp=nn -o $out_hipp" );
    }
}
##################################


foreach( $rats as $subject )
{  
        $indir = "$outputdir/$subject";

        if( is_dir( $indir ) )
            registerHipp( $indir, $subject );
}



?>
