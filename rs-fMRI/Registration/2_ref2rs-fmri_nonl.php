#!/usr/bin/php
<?php
include 'setup_registration.php';

##################################

####
# Register average rs-fMRI reference image to subject rs-fMRI (nonlinear).
##
function registerREF2rsFMRInonl( $indir, $refdir, $subject )
{
    echo "*** Register average rs-fMRI reference image to subject rs-fMRI (nonlinear) for rat: $subject \n";

    // input with masks
    $in = "$refdir/rs-fmri-reference.nii.gz";
    $in_mask = "$refdir/rs-fmri_nonl_mean_mask_adjusted.nii.gz";
    $ref = "$indir/bet_adjusted.nii.gz";
    $ref_mask = "$indir/mask_adjusted.nii.gz";

    $aff = "$indir/regs/ref2rsfmri_aff.mat";
    $config = "$refdir/fnirt.config";

    // output
    $outdir = "$indir/regs/";
    
    if(!is_dir($outdir))
        {
        echo "Creating '$outdir'...\n";
        mkdir($outdir);        
        }
    
    $out = "$outdir/ref2rsfmri_nonl.nii.gz";
    $coef = "$outdir/ref2rsfmri_nonl.coef.nii.gz";

    // ref -> rsfmri
   
        system( "fnirt --aff=$aff --cout=$coef --iout=$out --inmask=$in_mask --refmask=$ref_mask --ref=$ref --in=$in --config=$config" );
    

    
}
##################################


foreach( $rats as $subject )
{  
        $indir = "$outputdir/$subject";

        if( is_dir( $indir ) )
            registerREF2rsFMRInonl( $indir, $refdir, $subject );
}



?>
