#!/usr/bin/php
<?php
include 'setup_registration.php';

##################################
## Datadir and refdir

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
# Register average T2 image in reference space (alligned with atlas ROIs) to subject-space.
##
function registerREF2T2( $indir, $maindir, $subject, $refdir )
{
    echo "*** Register reference T2 to subject T2 (linear) for rat: $subject \n";

    // input (brain extracted images)
    $in = "$refdir/T2-reference.nii.gz";
    $ref = "$indir/bet_adjusted.nii.gz";

    // output
    $out = "$indir/regs/ref2T2.nii.gz";
    $out_mat = "$indir/regs/ref2T2_aff.mat";

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
        
        print "Register reference T2 to subject T2 for Rat: $subject \n";
        
        if( is_dir( $indir ) )
            registerREF2T2( $indir, $maindir, $subject, $refdir );
}


?>
