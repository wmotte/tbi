#!/usr/bin/php
<?php
include 'setup_registration.php';

##################################


####
# War ref brain mask to subject space.
##
function registerMASK ( $indir, $refdir, $subject )
{
    echo "*** Register mask to subject rs-fMRI (warp): $subject \n";

    // input with masks
    $in = "./rs-fmri_nonl_mean_mask_adjusted.nii.gz";
    $ref = "$indir/bet.nii.gz";
    $warp = "$indir/fmri-brainmask-regs/ref2rs-fmri_nonl.coef.nii.gz";

    // output
    $outdir = "$indir/fmri-brainmask-regs/";
    
    if(!is_dir($outdir))
        {
        echo "Creating '$outdir'...\n";
        mkdir($outdir);        
        }
    
    $output = "$outdir/mask2rs-fmri_nonl.nii.gz";

    // rsfmri -> ref
    if( file_exists( $in ) 
        && file_exists( $ref ) 
        && file_exists( $warp )
        && file_exists( $output ) )
    {
        system( "applywarp -i $in --interp=nn -o $output -r $ref -w $warp" );
    }
    
    // adjust BET based on new mask
    $bet = "$indir/bet.nii.gz";
    $bet2 = "$indir/bet_adjusted.nii.gz";
    
    if( file_exists( $output)
    && file_exists( $bet ) )
    {
        system( "fslmaths $bet -mas $output $bet2 " );
    }
    
    $mask2 = "$indir/mask_adjusted.nii.gz";
    
    if( file_exists( $bet2 ) )
    {
        system( "fslmaths $bet2 -bin $mask2 " );
    }
    
    

}
##################################


foreach( $rats as $subject )
{  
        $indir = "$outputdir/$subject";

        if( is_dir( $indir ) )
            registerMASK( $indir, $refdir, $subject );
}


?>
