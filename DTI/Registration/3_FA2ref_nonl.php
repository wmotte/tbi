#!/usr/bin/php
<?php
include 'setup_registration.php';

##################################


####
# Register FA map to reference (nonlinear).
##
function registerFA( $indir, $refdir, $subject )
{
    echo "*** Register FA map to reference (nonlinear): $subject \n";

    // input with masks
    $in = "$indir/dtifit/dti_FA.nii.gz";
    $in_mask = "$indir/mask.nii.gz";
    $ref = "$refdir/FA_aff_mean.nii.gz";
    $ref_mask = "$refdir/mri-2mm.nii.gz";

    $aff = "$indir/regs/FA2ref_aff.mat";
    $config = "$refdir/fnirt.config";

    // output
    $outdir = "$indir/regs/";
    
    if(!is_dir($outdir))
        {
        echo "Creating '$outdir'...\n";
        mkdir($outdir);        
        }
    
    $out = "$outdir/FA2ref_nonl.nii.gz";
    $coef = "$outdir/FA2ref_nonl.coef.nii.gz";

    // rsfmri -> ref
    if( file_exists( $in ) 
        && file_exists( $in_mask ) 
        && file_exists( $ref ) 
        && file_exists( $ref_mask ) 
        && file_exists( $aff ) 
        && file_exists( $config )
        && ! file_exists( $coef ) )
    {
        system( "fnirt --aff=$aff --cout=$coef --iout=$out --inmask=$in_mask --refmask=$ref_mask --ref=$ref --in=$in --config=$config" );
    }

    // invert warp ref -> fa
    $out_inv = "$outdir/ref2FA_nonl.nii.gz";
    $coef_inv = "$outdir/ref2FA_nonl.coef.nii.gz";

    if( file_exists( $coef ) && file_exists( $ref ) && file_exists( $in ) && ! file_exists( $coef_inv ) )
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
            registerFA( $indir, $refdir, $subject );
}



?>
