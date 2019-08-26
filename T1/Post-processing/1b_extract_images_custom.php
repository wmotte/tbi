#!/usr/bin/php
<?php
include 'setup_registration.php';

##################################

####
# Some post-measurements are shorter, so they have to be done one by one.
##

## qs01_24h
echo "*** Extract 5 T1 volumes from both pre- and post-measurement for rat: qs01_24h \n";
system( "fslroi $niidir/qs01_24h/bbb_post.nii.gz $outputdir/qs01_24h/bbb_post_extract.nii.gz 4 5" );

## qs06_00h
echo "*** Extract 5 T1 volumes from both pre- and post-measurement for rat: qs06_00h \n";
system( "fslroi $niidir/qs06_00h/bbb_post.nii.gz $outputdir/qs06_00h/bbb_post_extract.nii.gz 19 5" );

## qs06_24h
echo "*** Extract 5 T1 volumes from both pre- and post-measurement for rat: qs06_24h \n";
system( "fslroi $niidir/qs06_24h/bbb_post.nii.gz $outputdir/qs06_24h/bbb_post_extract.nii.gz 17 5" );

## tbi09_24h
echo "*** Extract 5 T1 volumes from both pre- and post-measurement for rat: tbi09_24h \n";
system( "fslroi $niidir/tbi09_24h/bbb_post.nii.gz $outputdir/tbi09_24h/bbb_post_extract.nii.gz 6 5" );

## tbi11_24h
echo "*** Extract 5 T1 volumes from both pre- and post-measurement for rat: tbi11_24h \n";
system( "fslroi $niidir/tbi11_24h/bbb_post.nii.gz $outputdir/tbi11_24h/bbb_post_extract.nii.gz 13 5" );

## tbi121_24h
echo "*** Extract 5 T1 volumes from both pre- and post-measurement for rat: tbi121_24h \n";
system( "fslroi $niidir/tbi121_24h/bbb_post.nii.gz $outputdir/tbi121_24h/bbb_post_extract.nii.gz 11 5" );


?>
