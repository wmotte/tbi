#!/usr/bin/php
<?php
include 'setup_registration.php';

##################################

####
# Register average rs-fMRI reference image to subject rs-fMRI (nonlinear).
##
function registerREF2T2nonl( $indir, $refdir, $subject )
{
    echo "*** Register average T2 reference image to subject T2 (nonlinear) for rat: $subject \n";

    // input with masks
    $in = "$refdir/T2-reference.nii.gz";
    $in_mask = "$refdir/T2_nonl_mean_mask.nii.gz";
    $ref = "$indir/bet_adjusted.nii.gz";
    $ref_mask = "$indir/mask_adjusted.nii.gz";

    $aff = "$indir/regs/ref2T2_aff.mat";
    $config = "$refdir/fnirt.config";

    // output
    $outdir = "$indir/regs/";
    
    if(!is_dir($outdir))
        {
        echo "Creating '$outdir'...\n";
        mkdir($outdir);        
        }
    
    $out = "$outdir/ref2T2_nonl.nii.gz";
    $coef = "$outdir/ref2T2_nonl.coef.nii.gz";

    // ref -> rsfmri
   
        system( "fnirt --aff=$aff --cout=$coef --iout=$out --inmask=$in_mask --refmask=$ref_mask --ref=$ref --in=$in --config=$config" );
    

    
}
##################################


foreach( $rats as $subject )
{  
        $indir = "$outputdir/$subject";

        if( is_dir( $indir ) )
            registerREF2T2nonl( $indir, $refdir, $subject );
}



?>
