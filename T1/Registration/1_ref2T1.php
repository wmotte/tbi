#!/usr/bin/php
<?php
include 'setup_registration.php';

####
# Create output (reg)dirs
##
foreach( $rats as $subject )
{  
    
        // check if directory exists, otherwise make one
        if( !is_dir( "$outputdir/$subject/regs" ) )
            system( "mkdir $outputdir/$subject/regs" );
    
    
}
    

####
# Register average T1 image in reference space (alligned with atlas ROIs) to subject-space.
##
function registerREF2T1( $indir, $maindir, $subject, $refdir )
{
    echo "*** Register reference T1 to subject T1 (linear) for rat: $subject \n";

    // input (brain extracted images)
    $in = "$refdir/T1-reference.nii.gz";
    $ref = "$indir/bet_adjusted.nii.gz";

    // output
    $out = "$indir/regs/ref2T1.nii.gz";
    $out_mat = "$indir/regs/ref2T1_aff.mat";

    if( (file_exists( $in ) && file_exists( $ref ) && ! file_exists( $out ) ) | true )
    {
        system( "nice flirt -in $in -ref $ref -omat $out_mat -o $out " );
    }
}
##################################

## Loop over all rats
foreach( $rats as $subject )
{  
        $indir = "$outputdir/$subject";
        $maindir = "$maindir";
        
        print "Register reference T1 to subject T1 for Rat: $subject \n";
        
        if( is_dir( $indir ) )
            registerREF2T1( $indir, $maindir, $subject, $refdir );
}


?>
