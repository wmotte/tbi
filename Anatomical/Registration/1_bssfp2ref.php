#!/usr/bin/php
<?php
include 'setup_registration.php';

##################################

####
# Register BSSFP to reference (affine).
##
function registerBSSFP( $indir, $refdir, $subject )
{
    echo "*** Register BSSFP to reference (affine): $subject \n";

    // input (brain extracted images)
    $in = "$indir/bet.nii.gz";
    $ref = "$refdir/mri-2mm.nii.gz";

    // output
    $outdir = "$indir/regs/";
    
    if(!is_dir($outdir))
        {
        echo "Creating '$outdir'...\n";
        mkdir($outdir);        
        }
    
    $out = "$outdir/bssfp2ref_aff.nii.gz";
    $out_mat = "$outdir/bssfp2ref_aff.mat";

    if( file_exists( $in ) && file_exists( $ref ) && !file_exists( $out ) )
    {
        system( "flirt -in $in -ref $ref -omat $out_mat -o $out -cost corratio -searchcost corratio" );
    }
}
##################################


foreach( $rats as $subject )
{  
        $indir = "$outputdir/$subject";

        if( is_dir( $indir ) )
            registerBSSFP( $indir, $refdir, $subject );
}


?>
