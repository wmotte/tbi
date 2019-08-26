#!/usr/bin/php
<?php
include 'setup_registration.php';

##################################


####
# Register T1 to reference (nonlinear).
##
function registerT1( $indir, $refdir, $subject )
{
    echo "*** Register T1 to reference (nonlinear): $subject \n";

    // input with masks
    $in = "$indir/bet.nii.gz";
    $in_mask = "$indir/mask.nii.gz";
    $ref = "./T1_aff_mean.nii.gz";
    $ref_mask = "$refdir/mri-2mm.nii.gz";

    $aff = "$indir/T1-regs/T1_2ref_aff.mat";
    $config = "$refdir/fnirt.config";

    // output
    $outdir = "$indir/T1-regs/";
    
    if(!is_dir($outdir))
        {
        echo "Creating '$outdir'...\n";
        mkdir($outdir);        
        }
    
    $out = "$outdir/T1_2ref_nonl.nii.gz";
    $coef = "$outdir/T1_2ref_nonl.coef.nii.gz";

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
    $out_inv = "$outdir/ref2T1_nonl.nii.gz";
    $coef_inv = "$outdir/ref2T1_nonl.coef.nii.gz";

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
            registerT1( $indir, $refdir, $subject );
}

?>
