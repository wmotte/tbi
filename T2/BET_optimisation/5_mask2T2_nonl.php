#!/usr/bin/php
<?php
include 'setup_registration.php';

##################################


####
# Register T2 reference mask to subject (nonlinear).
##
function registerT2 ( $indir, $refdir, $subject )
{
    echo "*** Register mask to subject T2 (warp): $subject \n";

    // input with masks
    $in = "./T2_nonl_mean_mask.nii.gz";
    $ref = "$indir/bet.nii.gz";
    $warp = "$indir/T2-regs/ref2T2_nonl.coef.nii.gz";

    // output
    $outdir = "$indir/T2-regs/";
    
    if(!is_dir($outdir))
        {
        echo "Creating '$outdir'...\n";
        mkdir($outdir);        
        }
    
    $output = "$outdir/mask2T2_nonl.nii.gz";

    // Ref mask -> T2
    if( file_exists( $in ) 
        && file_exists( $ref ) 
        && file_exists( $warp )
        && ! file_exists( $output ) )
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
            registerT2( $indir, $refdir, $subject );
}


?>
