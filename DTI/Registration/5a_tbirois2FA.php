#!/usr/bin/php
<?php
include 'setup_registration.php';

##################################


####
# Register selected ROIs to subject FA map.
##
function registerROIs( $indir, $refdir, $subject )
{
    echo "*** Register selected ROIs to subject FA map of subject: $subject \n";

    // input with masks
    $in = "$indir/dtifit/dti_FA.nii.gz";
    $ref = "$indir/mask_adjusted.nii.gz";
    $rois = "/home1/michel/projects/TBI/atlas/atlas_TBI_DTI_20190424.nii.gz";

    $aff = "$indir/regs/FA2ref_aff.mat";
    $config = "$refdir/fnirt.config";

    // output
    $outdir = "$indir/regs/";
    
    if(!is_dir($outdir))
        {
        echo "Creating '$outdir'...\n";
        mkdir($outdir);        
        }
   
    // apply invert warp on whole-brain rois
    $out_rois = "$outdir/tbirois_new2FA_nonl.nii.gz";
    $coef_inv = "$outdir/ref2FA_nonl.coef.nii.gz";

    if( file_exists( $ref ) && file_exists( $rois ) && file_exists( $coef_inv ) )
    {
        system( "applywarp -w $coef_inv -r $ref -i $rois --interp=nn -o $out_rois" );
    }
}
##################################


foreach( $rats as $subject )
{  
        $indir = "$outputdir/$subject";

        if( is_dir( $indir ) )
            registerROIs( $indir, $refdir, $subject );
}



?>
