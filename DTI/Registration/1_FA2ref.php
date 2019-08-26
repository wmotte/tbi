#!/usr/bin/php
<?php
include 'setup_registration.php';

##################################

####
# Register FA map to reference (affine).
##
function registerFA( $indir, $refdir, $subject )
{
    echo "*** Register FA-map to reference (affine): $subject \n";

    // input (brain extracted images)
    $in = "$indir/dtifit/dti_FA.nii.gz";
    $ref = "$refdir/mri-2mm.nii.gz";

    // output
    $outdir = "$indir/regs/";
    
    if(!is_dir($outdir))
        {
        echo "Creating '$outdir'...\n";
        mkdir($outdir);        
        }
    
    $out = "$outdir/FA2ref_aff.nii.gz";
    $out_mat = "$outdir/FA2ref_aff.mat";

    if( file_exists( $in ) && file_exists( $ref ) && !file_exists( $out ) )
    {
        system( "nice flirt -in $in -ref $ref -omat $out_mat -o $out -cost corratio -searchcost corratio" );
    }
}
##################################


foreach( $rats as $subject )
{  
        $indir = "$outputdir/$subject";

        if( is_dir( $indir ) )
            registerFA( $indir, $refdir, $subject );
}


?>
