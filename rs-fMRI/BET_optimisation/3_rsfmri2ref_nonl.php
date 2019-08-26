#!/usr/bin/php
<?php
include 'setup_registration.php';

##################################

####
# Register rs-fMRI to reference (nonlinear).
##
function registerFMRI( $indir, $refdir, $subject )
{
    echo "*** Register rs-fMRI average to reference (nonlinear): $subject \n";

    // input with masks
    $in = "$indir/bet.nii.gz";
    $in_mask = "$indir/mask.nii.gz";
    $ref = "./rs-fmri_aff_mean.nii.gz";
    $ref_mask = "$refdir/mri-2mm.nii.gz";

    $aff = "$indir/fmri-brainmask-regs/rs-fmri2ref_aff.mat";
    $config = "$refdir/fnirt.config";

    // output
    $outdir = "$indir/fmri-brainmask-regs/";
    
    if(!is_dir($outdir))
        {
        echo "Creating '$outdir'...\n";
        mkdir($outdir);        
        }
    
    $out = "$outdir/rs-fmri2ref_nonl.nii.gz";
    $coef = "$outdir/rs-fmri2ref_nonl.coef.nii.gz";

    // rsfmri -> ref
    if( file_exists( $in ) 
        && file_exists( $in_mask ) 
        && file_exists( $ref ) 
        && file_exists( $ref_mask ) 
        && file_exists( $aff ) 
        && file_exists( $config ) )
      #  && ! file_exists( $coef ) )
    {
        system( "fnirt --aff=$aff --cout=$coef --iout=$out --inmask=$in_mask --refmask=$ref_mask --ref=$ref --in=$in --config=$config" );
    }

    // invert warp ref -> bssfp
    $out_inv = "$outdir/ref2rs-fmri_nonl.nii.gz";
    $coef_inv = "$outdir/ref2rs-fmri_nonl.coef.nii.gz";

    #if( file_exists( $coef ) && file_exists( $ref ) && file_exists( $in ) && ! file_exists( $coef_inv ) )
    {
        system( "invwarp -w $coef -o $coef_inv -r $in" );
        system( "applywarp -w $coef_inv -r $in -i $ref -o $out_inv" );
    }
}
##################################


foreach( $rats as $subject )
{  
        $indir = "$outputdir/$subject";

        if( is_dir( $indir ) )
            registerFMRI( $indir, $refdir, $subject );
}



?>
