#!/usr/bin/php
<?php
include 'setup_registration.php';

##################################

####
# Register DTI to reference (affine).
##
function registerDTI( $indir, $refdir, $subject )
{
    echo "*** Register DTI to reference (affine): $subject \n";

    // input (brain extracted images)
    $in = "$indir/bet.nii.gz";
    $ref = "$refdir/mri-2mm.nii.gz";

    // output
    $outdir = "$indir/dti-regs/";
    
    if(!is_dir($outdir))
        {
        echo "Creating '$outdir'...\n";
        mkdir($outdir);        
        }
    
    $out = "$outdir/dti2ref_aff.nii.gz";
    $out_mat = "$outdir/dti2ref_aff.mat";

   # if( file_exists( $in ) && file_exists( $ref ) && !file_exists( $out ) )
    {
        system( "flirt -in $in -ref $ref -omat $out_mat -o $out -cost corratio -searchcost corratio" );
    }
}
##################################


foreach( $rats as $subject )
{  
        $indir = "$outputdir/$subject";

        if( is_dir( $indir ) )
            registerDTI( $indir, $refdir, $subject );
}


?>
